from rest_framework.renderers import JSONRenderer


class CustomJSONRenderer(JSONRenderer):
    def render(self, data, accepted_media_type=None, renderer_context=None):
        response = renderer_context.get('response') if renderer_context else None

        if response and response.status_code >= 400:
            # Error responses are already formatted by the exception handler
            return super().render(data, accepted_media_type, renderer_context)

        # Wrap successful responses if not already wrapped
        if isinstance(data, dict) and 'success' in data:
            return super().render(data, accepted_media_type, renderer_context)

        wrapped = {
            'success': True,
            'data': data,
            'message': None,
            'errors': None,
        }
        return super().render(wrapped, accepted_media_type, renderer_context)
