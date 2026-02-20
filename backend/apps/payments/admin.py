from django.contrib import admin

from apps.payments.models import Payment


@admin.register(Payment)
class PaymentAdmin(admin.ModelAdmin):
    list_display = [
        'order', 'user', 'gateway', 'status',
        'amount', 'currency', 'amount_refunded', 'created_at',
    ]
    list_filter = ['gateway', 'status', 'currency', 'created_at']
    search_fields = [
        'order__order_number', 'user__email',
        'gateway_order_id', 'gateway_payment_id', 'refund_id',
    ]
    readonly_fields = [
        'id', 'order', 'user', 'gateway', 'amount', 'currency',
        'gateway_order_id', 'gateway_payment_id', 'gateway_signature',
        'webhook_data', 'created_at', 'updated_at',
    ]
    fieldsets = [
        ('Order', {'fields': ['id', 'order', 'user']}),
        ('Payment', {'fields': ['gateway', 'status', 'amount', 'currency']}),
        ('Gateway IDs', {'fields': [
            'gateway_order_id', 'gateway_payment_id', 'gateway_signature',
        ]}),
        ('Refund', {'fields': ['amount_refunded', 'refund_id']}),
        ('Failure', {'fields': ['failure_code', 'failure_description']}),
        ('Audit', {'fields': ['webhook_data', 'created_at', 'updated_at']}),
    ]
    ordering = ['-created_at']
