from decimal import Decimal

from django.db import transaction
from django.db.models import Count, F, Q, Sum
from django.utils import timezone
from rest_framework.exceptions import ValidationError

from apps.cart.services import add_to_cart, get_or_create_cart
from apps.orders.models import Coupon, Order, OrderItem, OrderStatusHistory
from apps.users.models import Address


def validate_coupon(code, user, subtotal):
    """Validate a coupon code and return the coupon + discount amount."""
    try:
        coupon = Coupon.objects.get(code__iexact=code)
    except Coupon.DoesNotExist:
        raise ValidationError({'coupon': 'Invalid coupon code.'})

    if not coupon.is_valid:
        if not coupon.is_active:
            raise ValidationError({'coupon': 'This coupon is no longer active.'})
        if coupon.max_usage and coupon.usage_count >= coupon.max_usage:
            raise ValidationError({'coupon': 'This coupon has reached its usage limit.'})
        raise ValidationError({'coupon': 'This coupon has expired.'})

    if subtotal < coupon.min_order_value:
        raise ValidationError(
            {'coupon': f'Minimum order value of {coupon.min_order_value} required.'},
        )

    # Check per-user usage
    user_usage = Order.objects.filter(
        user=user, coupon=coupon,
    ).exclude(status='CANCELLED').count()
    if user_usage >= coupon.usage_per_user:
        raise ValidationError({'coupon': 'You have already used this coupon.'})

    discount = coupon.calculate_discount(subtotal)
    return coupon, discount


@transaction.atomic
def apply_coupon_to_cart(user, coupon_code):
    """Apply a coupon to the user's cart and recalculate totals."""
    cart = get_or_create_cart(user)

    if cart.items.count() == 0:
        raise ValidationError({'cart': 'Your cart is empty.'})

    coupon, discount = validate_coupon(coupon_code, user, cart.subtotal)

    cart.discount = discount
    cart.total = cart.subtotal + cart.tax - discount
    cart.save(update_fields=['discount', 'total', 'updated_at'])

    return coupon, discount, cart


@transaction.atomic
def remove_coupon_from_cart(user):
    """Remove coupon from cart and recalculate."""
    cart = get_or_create_cart(user)
    cart.discount = Decimal('0.00')
    cart.total = cart.subtotal + cart.tax
    cart.save(update_fields=['discount', 'total', 'updated_at'])
    return cart


@transaction.atomic
def create_order(user, shipping_address_id, billing_address_id=None,
                 payment_method='cod', customer_note='', coupon_code=None):
    """Create an order from the user's cart."""
    cart = get_or_create_cart(user)

    if cart.items.count() == 0:
        raise ValidationError({'cart': 'Your cart is empty.'})

    # Validate shipping address
    try:
        shipping_addr = Address.objects.get(
            id=shipping_address_id, user=user, is_active=True,
        )
    except Address.DoesNotExist:
        raise ValidationError({'shipping_address': 'Shipping address not found.'})

    billing_addr = None
    if billing_address_id:
        try:
            billing_addr = Address.objects.get(
                id=billing_address_id, user=user, is_active=True,
            )
        except Address.DoesNotExist:
            raise ValidationError({'billing_address': 'Billing address not found.'})

    # Validate coupon if provided
    coupon = None
    discount = Decimal('0.00')
    if coupon_code:
        coupon, discount = validate_coupon(coupon_code, user, cart.subtotal)

    # Validate stock for all items
    cart_items = cart.items.select_related('product', 'variant')
    for item in cart_items:
        product = item.product
        if not product.is_active or not product.is_available:
            raise ValidationError(
                {'stock': f'{product.name} is no longer available.'},
            )
        if item.variant:
            if item.variant.stock_quantity < item.quantity:
                raise ValidationError(
                    {'stock': f'Insufficient stock for {product.name} ({item.variant.size} {item.variant.color}).'},
                )
        elif product.track_inventory and product.stock_quantity < item.quantity:
            raise ValidationError(
                {'stock': f'Insufficient stock for {product.name}.'},
            )

    # Calculate totals
    subtotal = cart.subtotal
    tax = cart.tax
    total = subtotal + tax - discount

    # Create the order
    order = Order.objects.create(
        order_number=Order.generate_order_number(),
        user=user,
        shipping_address=shipping_addr.to_snapshot(),
        billing_address=billing_addr.to_snapshot() if billing_addr else None,
        status=Order.Status.PENDING,
        payment_status=Order.PaymentStatus.PENDING,
        subtotal=subtotal,
        tax=tax,
        discount=discount,
        total=total,
        payment_method=payment_method,
        customer_note=customer_note,
        coupon=coupon,
    )

    # Create order items and deduct stock
    for item in cart_items:
        sku = item.variant.sku if item.variant else item.product.sku

        OrderItem.objects.create(
            order=order,
            product=item.product,
            variant=item.variant,
            product_name=item.product.name,
            product_image=item.product.thumbnail,
            sku=sku,
            variant_size=item.variant.size if item.variant else '',
            variant_color=item.variant.color if item.variant else '',
            quantity=item.quantity,
            unit_price=item.unit_price,
            total_price=item.total_price,
            vendor=item.product.vendor,
        )

        # Deduct stock
        if item.variant:
            item.variant.stock_quantity = F('stock_quantity') - item.quantity
            item.variant.save(update_fields=['stock_quantity'])
        elif item.product.track_inventory:
            item.product.stock_quantity = F('stock_quantity') - item.quantity
            item.product.save(update_fields=['stock_quantity'])

        # Increment order count
        item.product.order_count = F('order_count') + item.quantity
        item.product.save(update_fields=['order_count'])

    # Increment coupon usage
    if coupon:
        coupon.usage_count = F('usage_count') + 1
        coupon.save(update_fields=['usage_count'])

    # Record initial status
    OrderStatusHistory.objects.create(
        order=order,
        status=Order.Status.PENDING,
        notes='Order placed.',
        changed_by=user,
    )

    # Clear the cart
    cart.clear_items()

    return order


@transaction.atomic
def cancel_order(user, order_number, reason=''):
    """Cancel an order and restore stock."""
    try:
        order = Order.objects.get(order_number=order_number, user=user)
    except Order.DoesNotExist:
        raise ValidationError({'order': 'Order not found.'})

    if not order.is_cancellable:
        raise ValidationError(
            {'status': f'Order cannot be cancelled (current status: {order.get_status_display()}).'},
        )

    order.status = Order.Status.CANCELLED
    order.save(update_fields=['status', 'updated_at'])

    OrderStatusHistory.objects.create(
        order=order,
        status=Order.Status.CANCELLED,
        notes=reason or 'Order cancelled by customer.',
        changed_by=user,
    )

    # Restore stock
    for item in order.items.select_related('product', 'variant'):
        if item.variant:
            item.variant.stock_quantity = F('stock_quantity') + item.quantity
            item.variant.save(update_fields=['stock_quantity'])
        elif item.product.track_inventory:
            item.product.stock_quantity = F('stock_quantity') + item.quantity
            item.product.save(update_fields=['stock_quantity'])

    return order


@transaction.atomic
def reorder(user, order_number):
    """Add items from a previous order to the user's cart."""
    try:
        order = Order.objects.prefetch_related('items').get(
            order_number=order_number, user=user,
        )
    except Order.DoesNotExist:
        raise ValidationError({'order': 'Order not found.'})

    added = []
    skipped = []

    for item in order.items.all():
        try:
            add_to_cart(
                user=user,
                product_id=item.product_id,
                variant_id=item.variant_id,
                quantity=item.quantity,
            )
            added.append(item.product_name)
        except ValidationError:
            skipped.append(item.product_name)

    if not added and skipped:
        raise ValidationError(
            {'items': 'None of the items could be added to cart (unavailable or out of stock).'},
        )

    return added, skipped


def update_order_status(order, new_status, changed_by=None, notes=''):
    """Update order status with validation and history tracking."""
    if not order.can_transition_to(new_status):
        raise ValidationError(
            {'status': f'Cannot transition from {order.status} to {new_status}.'},
        )

    order.status = new_status
    update_fields = ['status', 'updated_at']

    if new_status == 'DELIVERED':
        order.delivered_at = timezone.now()
        update_fields.append('delivered_at')

    order.save(update_fields=update_fields)

    OrderStatusHistory.objects.create(
        order=order,
        status=new_status,
        notes=notes,
        changed_by=changed_by,
    )

    return order


# ──────────────────────────────────────────────
# Admin Order Management
# ──────────────────────────────────────────────
@transaction.atomic
def admin_update_order_status(order_id, new_status, changed_by, tracking_number='', notes=''):
    """Admin: update order status, optionally set tracking number."""
    try:
        order = Order.objects.get(id=order_id)
    except Order.DoesNotExist:
        raise ValidationError({'order': 'Order not found.'})

    if not order.can_transition_to(new_status):
        raise ValidationError(
            {'status': f'Cannot transition from {order.status} to {new_status}.'},
        )

    order.status = new_status
    update_fields = ['status', 'updated_at']

    if tracking_number:
        order.tracking_number = tracking_number
        update_fields.append('tracking_number')

    if new_status == 'DELIVERED':
        order.delivered_at = timezone.now()
        update_fields.append('delivered_at')

    if new_status == 'SHIPPED' and not order.estimated_delivery:
        # Set estimated delivery to 5 days from now
        order.estimated_delivery = timezone.now() + timezone.timedelta(days=5)
        update_fields.append('estimated_delivery')

    order.save(update_fields=update_fields)

    OrderStatusHistory.objects.create(
        order=order,
        status=new_status,
        notes=notes,
        changed_by=changed_by,
    )

    return order


def get_admin_dashboard_stats():
    """Return aggregate stats for admin dashboard."""
    from apps.users.models import User
    from apps.products.models import Product

    now = timezone.now()
    today_start = now.replace(hour=0, minute=0, second=0, microsecond=0)

    total_orders = Order.objects.count()
    total_revenue = Order.objects.filter(
        payment_status=Order.PaymentStatus.PAID,
    ).aggregate(total=Sum('total'))['total'] or Decimal('0.00')

    pending_orders = Order.objects.filter(status=Order.Status.PENDING).count()
    completed_orders = Order.objects.filter(status=Order.Status.DELIVERED).count()
    total_users = User.objects.filter(role=User.Role.CUSTOMER).count()
    total_vendors = User.objects.filter(role=User.Role.VENDOR).count()

    # Today's stats
    today_orders = Order.objects.filter(created_at__gte=today_start).count()
    today_revenue = Order.objects.filter(
        created_at__gte=today_start,
        payment_status=Order.PaymentStatus.PAID,
    ).aggregate(total=Sum('total'))['total'] or Decimal('0.00')
    new_users_today = User.objects.filter(created_at__gte=today_start).count()

    # Order status breakdown
    status_breakdown = dict(
        Order.objects.values_list('status').annotate(count=Count('id')).values_list('status', 'count')
    )

    # Orders by product type (orders that contain at least one food/clothing item)
    food_orders = Order.objects.filter(
        items__product__product_type='FOOD'
    ).distinct().count()
    clothing_orders = Order.objects.filter(
        items__product__product_type='CLOTHING'
    ).distinct().count()

    # Product stats
    active_products = Product.objects.filter(is_active=True)
    total_products = active_products.count()
    out_of_stock_products = active_products.filter(stock_quantity=0).count()
    low_stock_products = active_products.filter(
        stock_quantity__gt=0, stock_quantity__lte=5
    ).count()
    food_products = active_products.filter(product_type='FOOD').count()
    clothing_products = active_products.filter(product_type='CLOTHING').count()

    # Top products by order count (last 30 days)
    thirty_days_ago = now - timezone.timedelta(days=30)
    top_products = list(
        OrderItem.objects.filter(order__created_at__gte=thirty_days_ago)
        .values('product_name', 'product_image')
        .annotate(total_sold=Sum('quantity'), revenue=Sum('total_price'))
        .order_by('-total_sold')[:5]
    )

    # Recent orders
    recent_orders = list(
        Order.objects.select_related('user').order_by('-created_at')[:10]
        .values('order_number', 'status', 'total', 'created_at', 'user__first_name', 'user__last_name')
    )

    return {
        'overview': {
            'total_users': total_users,
            'total_vendors': total_vendors,
            'total_orders': total_orders,
            'total_revenue': str(total_revenue),
            'pending_orders': pending_orders,
            'completed_orders': completed_orders,
        },
        'today': {
            'orders': today_orders,
            'revenue': str(today_revenue),
            'new_users': new_users_today,
        },
        'product_type_orders': {
            'food_orders': food_orders,
            'clothing_orders': clothing_orders,
        },
        'product_stats': {
            'total_products': total_products,
            'out_of_stock': out_of_stock_products,
            'low_stock': low_stock_products,
            'food_products': food_products,
            'clothing_products': clothing_products,
        },
        'status_breakdown': status_breakdown,
        'top_products': top_products,
        'recent_orders': recent_orders,
    }


# ──────────────────────────────────────────────
# Vendor Order Management
# ──────────────────────────────────────────────
def get_vendor_orders(vendor):
    """Get all order items assigned to a vendor, grouped by order."""
    return OrderItem.objects.filter(vendor=vendor).select_related(
        'order', 'order__user',
    ).order_by('-order__created_at')


def get_vendor_dashboard_stats(vendor):
    """Return aggregate stats for vendor dashboard."""
    now = timezone.now()
    month_start = now.replace(day=1, hour=0, minute=0, second=0, microsecond=0)

    vendor_items = OrderItem.objects.filter(vendor=vendor)

    total_items = vendor_items.count()
    total_revenue = vendor_items.filter(
        order__payment_status=Order.PaymentStatus.PAID,
    ).aggregate(total=Sum('total_price'))['total'] or Decimal('0.00')

    pending_items = vendor_items.filter(
        order__status__in=[Order.Status.PENDING, Order.Status.CONFIRMED],
    ).count()

    this_month_revenue = vendor_items.filter(
        order__created_at__gte=month_start,
        order__payment_status=Order.PaymentStatus.PAID,
    ).aggregate(total=Sum('total_price'))['total'] or Decimal('0.00')

    # Unique orders
    total_orders = vendor_items.values('order').distinct().count()
    pending_orders = vendor_items.filter(
        order__status__in=[Order.Status.PENDING, Order.Status.CONFIRMED],
    ).values('order').distinct().count()

    # Top products
    top_products = list(
        vendor_items.values('product_name', 'product_image')
        .annotate(total_sold=Sum('quantity'), revenue=Sum('total_price'))
        .order_by('-total_sold')[:5]
    )

    return {
        'total_products': total_items,
        'total_orders': total_orders,
        'pending_orders': pending_orders,
        'total_revenue': str(total_revenue),
        'this_month_revenue': str(this_month_revenue),
        'top_products': top_products,
    }
