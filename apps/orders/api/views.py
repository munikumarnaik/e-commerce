from rest_framework import status
from rest_framework.permissions import IsAuthenticated
from rest_framework.response import Response
from rest_framework.views import APIView

from apps.orders import services
from apps.orders.models import Order

from .serializers import (
    CancelOrderSerializer,
    CreateOrderSerializer,
    OrderDetailSerializer,
    OrderListSerializer,
    OrderTrackSerializer,
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
