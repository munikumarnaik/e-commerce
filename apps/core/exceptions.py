from rest_framework import status
from rest_framework.exceptions import APIException
from rest_framework.response import Response
from rest_framework.views import exception_handler


def custom_exception_handler(exc, context):
    response = exception_handler(exc, context)

    if response is not None:
        errors = None
        message = 'An error occurred'

        if isinstance(response.data, dict):
            if 'detail' in response.data:
                message = str(response.data['detail'])
            else:
                formatted_errors = {}

                for field, value in response.data.items():
                    if isinstance(value, list) and len(value) > 0:
                        formatted_errors[field] = str(value[0])  # take first error
                    else:
                        formatted_errors[field] = str(value)

                errors = formatted_errors
                message = "Validation error"
                # errors = response.data
                # message = 'Validation error'
        elif isinstance(response.data, list):
            message = response.data[0] if response.data else 'An error occurred'

        response.data = {
            'success': False,
            'data': None,
            'status': response.status_code,
            'message': message,
            'errors': errors,
        }

    return response


class CustomAPIException(APIException):
    status_code = status.HTTP_400_BAD_REQUEST
    default_detail = 'A server error occurred.'
    default_code = 'error'

    def __init__(self, detail=None, code=None, status_code=None):
        if status_code is not None:
            self.status_code = status_code
        super().__init__(detail=detail, code=code)
