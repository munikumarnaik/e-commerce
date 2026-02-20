import uuid

import boto3
from botocore.config import Config
from django.conf import settings


def get_r2_client():
    """Create and return a boto3 S3 client configured for Cloudflare R2."""
    return boto3.client(
        's3',
        endpoint_url=settings.R2_ENDPOINT,
        aws_access_key_id=settings.R2_ACCESS_KEY_ID,
        aws_secret_access_key=settings.R2_SECRET_ACCESS_KEY,
        region_name=settings.R2_REGION,
        config=Config(signature_version='s3v4'),
    )


def upload_file_to_r2(file_obj, folder='uploads'):
    """
    Upload a file to Cloudflare R2 and return the URL.

    Args:
        file_obj: Django UploadedFile or file-like object
        folder: Folder path within the bucket (e.g. 'products', 'categories')

    Returns:
        str: The public URL of the uploaded file
    """
    client = get_r2_client()
    ext = file_obj.name.rsplit('.', 1)[-1].lower() if '.' in file_obj.name else 'bin'
    key = f'{folder}/{uuid.uuid4().hex}.{ext}'

    content_type = getattr(file_obj, 'content_type', 'application/octet-stream')

    client.upload_fileobj(
        file_obj,
        settings.R2_BUCKET_NAME,
        key,
        ExtraArgs={
            'ContentType': content_type,
            'CacheControl': 'max-age=86400',
        },
    )

    if settings.R2_CUSTOM_DOMAIN:
        return f'https://{settings.R2_CUSTOM_DOMAIN}/{key}'
    return f'{settings.R2_ENDPOINT}/{settings.R2_BUCKET_NAME}/{key}'


def delete_file_from_r2(file_url):
    """
    Delete a file from Cloudflare R2 given its URL.

    Args:
        file_url: The full URL of the file to delete
    """
    if not file_url:
        return

    # Extract the key from the URL
    bucket_prefix = f'{settings.R2_ENDPOINT}/{settings.R2_BUCKET_NAME}/'
    if file_url.startswith(bucket_prefix):
        key = file_url[len(bucket_prefix):]
    elif settings.R2_CUSTOM_DOMAIN and settings.R2_CUSTOM_DOMAIN in file_url:
        key = file_url.split(settings.R2_CUSTOM_DOMAIN + '/')[-1]
    else:
        return

    client = get_r2_client()
    client.delete_object(Bucket=settings.R2_BUCKET_NAME, Key=key)


def generate_presigned_url(key, expiration=3600):
    """Generate a presigned URL for temporary access to a private object."""
    client = get_r2_client()
    return client.generate_presigned_url(
        'get_object',
        Params={'Bucket': settings.R2_BUCKET_NAME, 'Key': key},
        ExpiresIn=expiration,
    )
