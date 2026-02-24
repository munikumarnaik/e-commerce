from django.db.models import Q

from rest_framework import status
from rest_framework.permissions import IsAuthenticated
from rest_framework.response import Response
from rest_framework.views import APIView

from django.shortcuts import get_object_or_404

from apps.core.permissions import IsAdmin, IsVendor
from apps.orders import services
from apps.orders.models import Coupon, Order

from .serializers import (
    AdminCouponCreateSerializer,
    AdminCouponSerializer,
    AdminOrderListSerializer,
    AdminUpdateOrderStatusSerializer,
    CancelOrderSerializer,
    CreateOrderSerializer,
    OrderDetailSerializer,
    OrderListSerializer,
    OrderTrackSerializer,
    PublicCouponSerializer,
    VendorOrderItemSerializer,
)


class OrderListView(APIView):
    """GET /orders/ — List user's orders."""
    permission_classes = [IsAuthenticated]

    def get(self, request, *args, **kwargs):
        orders = Order.objects.filter(user=request.user)

        # Filter by status
        order_status = request.query_params.get('status')
        if order_status:
            orders = orders.filter(status=order_status.upper())

        # Ordering
        ordering = request.query_params.get('ordering', '-created_at')
        allowed_ordering = ['created_at', '-created_at', '-total', 'total']
        if ordering in allowed_ordering:
            orders = orders.order_by(ordering)

        serializer = OrderListSerializer(orders, many=True)
        return Response({
            'success': True,
            'data': {
                'count': orders.count(),
                'results': serializer.data,
            },
        })


class OrderDetailView(APIView):
    """GET /orders/{order_number}/ — Get order details."""
    permission_classes = [IsAuthenticated]

    def get(self, request, *args, **kwargs):
        order_number = kwargs.get('order_number')
        try:
            order = Order.objects.prefetch_related(
                'items', 'status_history',
            ).get(order_number=order_number, user=request.user)
        except Order.DoesNotExist:
            return Response(
                {'success': False, 'message': 'Order not found.'},
                status=status.HTTP_404_NOT_FOUND,
            )

        serializer = OrderDetailSerializer(order)
        return Response({
            'success': True,
            'data': serializer.data,
        })


class OrderCreateView(APIView):
    """POST /orders/create/ — Create order from cart."""
    permission_classes = [IsAuthenticated]

    def post(self, request, *args, **kwargs):
        serializer = CreateOrderSerializer(data=request.data)
        serializer.is_valid(raise_exception=True)

        data = serializer.validated_data
        coupon_code = data.get('coupon_code', '').strip() or None

        order = services.create_order(
            user=request.user,
            shipping_address_id=data['shipping_address_id'],
            billing_address_id=data.get('billing_address_id'),
            payment_method=data.get('payment_method', 'cod'),
            customer_note=data.get('customer_note', ''),
            coupon_code=coupon_code,
        )

        return Response({
            'success': True,
            'data': {
                'order_id': str(order.id),
                'order_number': order.order_number,
                'total': str(order.total),
                'payment_method': order.payment_method,
            },
            'message': 'Order created successfully.',
        }, status=status.HTTP_201_CREATED)


class OrderCancelView(APIView):
    """POST /orders/{order_number}/cancel/ — Cancel order."""
    permission_classes = [IsAuthenticated]

    def post(self, request, *args, **kwargs):
        serializer = CancelOrderSerializer(data=request.data)
        serializer.is_valid(raise_exception=True)

        order_number = kwargs.get('order_number')
        services.cancel_order(
            user=request.user,
            order_number=order_number,
            reason=serializer.validated_data.get('reason', ''),
        )

        return Response({
            'success': True,
            'message': 'Order cancelled successfully.',
        })


class OrderReorderView(APIView):
    """POST /orders/{order_number}/reorder/ — Add previous order items to cart."""
    permission_classes = [IsAuthenticated]

    def post(self, request, *args, **kwargs):
        order_number = kwargs.get('order_number')
        added, skipped = services.reorder(user=request.user, order_number=order_number)

        message = 'Items added to cart.'
        if skipped:
            message += f' {len(skipped)} item(s) skipped (unavailable).'

        return Response({
            'success': True,
            'data': {'added': added, 'skipped': skipped},
            'message': message,
        })


class OrderTrackView(APIView):
    """GET /orders/{order_number}/track/ — Track order status."""
    permission_classes = [IsAuthenticated]

    def get(self, request, *args, **kwargs):
        order_number = kwargs.get('order_number')
        try:
            order = Order.objects.prefetch_related('status_history').get(
                order_number=order_number, user=request.user,
            )
        except Order.DoesNotExist:
            return Response(
                {'success': False, 'message': 'Order not found.'},
                status=status.HTTP_404_NOT_FOUND,
            )

        serializer = OrderTrackSerializer(order)
        return Response({
            'success': True,
            'data': serializer.data,
        })


# ──────────────────────────────────────────────
# Public Coupon Views
# ──────────────────────────────────────────────
class AvailableCouponsView(APIView):
    """GET /coupons/available/ — List active coupons visible to users.
    Optional query: ?product_id=<uuid> to filter coupons for a specific product.
    """
    permission_classes = [IsAuthenticated]

    def get(self, request, *args, **kwargs):
        from django.utils import timezone
        now = timezone.now()

        coupons = Coupon.objects.filter(
            is_active=True,
            valid_from__lte=now,
            valid_until__gte=now,
        ).prefetch_related('applicable_products')

        # Exclude fully used coupons
        coupons = [c for c in coupons if c.is_valid]

        # Filter by product if specified
        product_id = request.query_params.get('product_id')
        if product_id:
            coupons = [
                c for c in coupons
                if not c.applicable_products.exists()
                or c.applicable_products.filter(id=product_id).exists()
            ]

        serializer = PublicCouponSerializer(coupons, many=True)
        return Response({
            'success': True,
            'data': {
                'count': len(coupons),
                'results': serializer.data,
            },
        })


# ──────────────────────────────────────────────
# Admin Views
# ──────────────────────────────────────────────
class AdminOrderListView(APIView):
    """GET /admin/orders/ — List all orders (admin)."""
    permission_classes = [IsAdmin]

    def get(self, request, *args, **kwargs):
        orders = Order.objects.select_related('user').all()

        # Filter by status
        order_status = request.query_params.get('status')
        if order_status:
            orders = orders.filter(status=order_status.upper())

        # Filter by payment status
        payment_status = request.query_params.get('payment_status')
        if payment_status:
            orders = orders.filter(payment_status=payment_status.upper())

        # Search by order number or customer email
        search = request.query_params.get('search')
        if search:
            orders = orders.filter(
                Q(order_number__icontains=search)
                | Q(user__email__icontains=search)
                | Q(user__first_name__icontains=search)
            )

        # Ordering
        ordering = request.query_params.get('ordering', '-created_at')
        allowed = ['created_at', '-created_at', '-total', 'total', 'status']
        if ordering in allowed:
            orders = orders.order_by(ordering)

        serializer = AdminOrderListSerializer(orders, many=True)
        return Response({
            'success': True,
            'data': {
                'count': orders.count(),
                'results': serializer.data,
            },
        })


class AdminOrderDetailView(APIView):
    """GET /admin/orders/{order_id}/ — Get order details (admin)."""
    permission_classes = [IsAdmin]

    def get(self, request, *args, **kwargs):
        order_id = kwargs.get('order_id')
        try:
            order = Order.objects.prefetch_related(
                'items', 'status_history',
            ).select_related('user').get(id=order_id)
        except Order.DoesNotExist:
            return Response(
                {'success': False, 'message': 'Order not found.'},
                status=status.HTTP_404_NOT_FOUND,
            )

        serializer = OrderDetailSerializer(order)
        return Response({
            'success': True,
            'data': serializer.data,
        })


class AdminOrderStatusUpdateView(APIView):
    """PATCH /admin/orders/{order_id}/status/ — Update order status (admin)."""
    permission_classes = [IsAdmin]

    def patch(self, request, *args, **kwargs):
        serializer = AdminUpdateOrderStatusSerializer(data=request.data)
        serializer.is_valid(raise_exception=True)

        data = serializer.validated_data
        order_id = kwargs.get('order_id')

        order = services.admin_update_order_status(
            order_id=order_id,
            new_status=data['status'],
            changed_by=request.user,
            tracking_number=data.get('tracking_number', ''),
            notes=data.get('notes', ''),
        )

        return Response({
            'success': True,
            'data': {
                'order_number': order.order_number,
                'status': order.status,
                'tracking_number': order.tracking_number,
            },
            'message': f'Order status updated to {order.get_status_display()}.',
        })


class AdminDashboardStatsView(APIView):
    """GET /admin/dashboard/stats/ — Dashboard statistics."""
    permission_classes = [IsAdmin]

    def get(self, request, *args, **kwargs):
        stats = services.get_admin_dashboard_stats()
        return Response({
            'success': True,
            'data': stats,
        })


# ──────────────────────────────────────────────
# Admin Coupon Views
# ──────────────────────────────────────────────
class AdminCouponListView(APIView):
    """GET /admin/coupons/ — List all coupons."""
    permission_classes = [IsAdmin]

    def get(self, request, *args, **kwargs):
        coupons = Coupon.objects.all().order_by('-created_at')
        # Filter by active status
        is_active = request.query_params.get('is_active')
        if is_active is not None:
            coupons = coupons.filter(is_active=is_active.lower() == 'true')
        serializer = AdminCouponSerializer(coupons, many=True)
        return Response({
            'success': True,
            'data': {
                'count': coupons.count(),
                'results': serializer.data,
            },
        })


class AdminCouponCreateView(APIView):
    """POST /admin/coupons/create/ — Create a coupon."""
    permission_classes = [IsAdmin]

    def post(self, request, *args, **kwargs):
        serializer = AdminCouponCreateSerializer(data=request.data)
        serializer.is_valid(raise_exception=True)
        coupon = serializer.save()
        return Response({
            'success': True,
            'data': AdminCouponSerializer(coupon).data,
            'message': 'Coupon created successfully.',
        }, status=status.HTTP_201_CREATED)


class AdminCouponUpdateView(APIView):
    """PATCH /admin/coupons/{coupon_id}/update/ — Update a coupon."""
    permission_classes = [IsAdmin]

    def patch(self, request, *args, **kwargs):
        coupon = get_object_or_404(Coupon, id=kwargs['coupon_id'])
        serializer = AdminCouponCreateSerializer(coupon, data=request.data, partial=True)
        serializer.is_valid(raise_exception=True)
        coupon = serializer.save()
        return Response({
            'success': True,
            'data': AdminCouponSerializer(coupon).data,
            'message': 'Coupon updated successfully.',
        })


class AdminCouponDeleteView(APIView):
    """DELETE /admin/coupons/{coupon_id}/delete/ — Delete a coupon."""
    permission_classes = [IsAdmin]

    def delete(self, request, *args, **kwargs):
        coupon = get_object_or_404(Coupon, id=kwargs['coupon_id'])
        coupon.delete()
        return Response({
            'success': True,
            'message': 'Coupon deleted successfully.',
        }, status=status.HTTP_200_OK)


class AdminCouponToggleView(APIView):
    """POST /admin/coupons/{coupon_id}/toggle/ — Toggle active status."""
    permission_classes = [IsAdmin]

    def post(self, request, *args, **kwargs):
        coupon = get_object_or_404(Coupon, id=kwargs['coupon_id'])
        coupon.is_active = not coupon.is_active
        coupon.save(update_fields=['is_active', 'updated_at'])
        return Response({
            'success': True,
            'data': AdminCouponSerializer(coupon).data,
            'message': f'Coupon {"activated" if coupon.is_active else "deactivated"} successfully.',
        })


# ──────────────────────────────────────────────
# Vendor Views
# ──────────────────────────────────────────────
class VendorOrderListView(APIView):
    """GET /vendor/orders/ — List vendor's order items."""
    permission_classes = [IsVendor]

    def get(self, request, *args, **kwargs):
        items = services.get_vendor_orders(vendor=request.user)

        # Filter by order status
        order_status = request.query_params.get('status')
        if order_status:
            items = items.filter(order__status=order_status.upper())

        serializer = VendorOrderItemSerializer(items, many=True)
        return Response({
            'success': True,
            'data': {
                'count': items.count(),
                'results': serializer.data,
            },
        })


class VendorDashboardView(APIView):
    """GET /vendor/dashboard/ — Vendor dashboard stats."""
    permission_classes = [IsVendor]

    def get(self, request, *args, **kwargs):
        stats = services.get_vendor_dashboard_stats(vendor=request.user)
        return Response({
            'success': True,
            'data': stats,
        })
