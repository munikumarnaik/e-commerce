# API Endpoints Documentation
## RESTful API Design with Versioning

---

## 🌐 API Overview

### **Base URLs**
```
Development: http://localhost:8000/api/v1/
Staging:     https://staging-api.yourdomain.com/api/v1/
Production:  https://api.yourdomain.com/api/v1/
```

### **API Versioning Strategy**
- Current Version: **v1**
- URL-based versioning: `/api/v1/resource/`
- Future versions: `/api/v2/resource/` (backward compatible)

### **Authentication**
All authenticated endpoints require JWT token:
```http
Authorization: Bearer <access_token>
```

### **Response Format**
All responses follow standard JSON format:
```json
{
  "success": true,
  "data": {...},
  "message": "Success message",
  "errors": null
}
```

---

## 📑 API Endpoint Categories

1. **Authentication** - User auth & registration
2. **User Profile** - Profile management
3. **Addresses** - Delivery addresses
4. **Categories** - Product categories
5. **Products** - Product catalog
6. **Cart** - Shopping cart
7. **Wishlist** - User wishlist
8. **Orders** - Order management
9. **Payments** - Payment processing
10. **Reviews** - Product reviews
11. **Notifications** - User notifications
12. **Search** - Global search
13. **Admin** - Admin operations
14. **Vendor** - Vendor operations

---

## 1️⃣ Authentication Endpoints

### **POST** `/api/v1/auth/register/`
Register new user

**Access**: Public

**Request Body**:
```json
{
  "email": "user@example.com",
  "username": "johndoe",
  "password": "SecurePass123!",
  "password_confirm": "SecurePass123!",
  "first_name": "John",
  "last_name": "Doe",
  "phone": "+919876543210"
}
```

**Success Response** `201 Created`:
```json
{
  "success": true,
  "data": {
    "user": {
      "id": "uuid",
      "email": "user@example.com",
      "username": "johndoe",
      "first_name": "John",
      "last_name": "Doe",
      "role": "CUSTOMER",
      "is_verified": false
    },
    "tokens": {
      "access": "eyJ0eXAiOiJKV1...",
      "refresh": "eyJ0eXAiOiJKV1..."
    }
  },
  "message": "Registration successful. Please verify your email."
}
```

**Error Response** `400 Bad Request`:
```json
{
  "success": false,
  "data": null,
  "message": "Validation error",
  "errors": {
    "email": ["Email already exists"],
    "password": ["Password too weak"]
  }
}
```

---

### **POST** `/api/v1/auth/login/`
User login

**Access**: Public

**Request Body**:
```json
{
  "email": "user@example.com",
  "password": "SecurePass123!"
}
```

**Success Response** `200 OK`:
```json
{
  "success": true,
  "data": {
    "user": {
      "id": "uuid",
      "email": "user@example.com",
      "username": "johndoe",
      "first_name": "John",
      "last_name": "Doe",
      "role": "CUSTOMER",
      "profile_image": "https://...",
      "is_verified": true
    },
    "tokens": {
      "access": "eyJ0eXAiOiJKV1...",
      "refresh": "eyJ0eXAiOiJKV1..."
    }
  },
  "message": "Login successful"
}
```

---

### **POST** `/api/v1/auth/token/refresh/`
Refresh access token

**Access**: Public

**Request Body**:
```json
{
  "refresh": "eyJ0eXAiOiJKV1..."
}
```

**Success Response** `200 OK`:
```json
{
  "success": true,
  "data": {
    "access": "eyJ0eXAiOiJKV1...",
    "refresh": "eyJ0eXAiOiJKV1..."
  }
}
```

---

### **POST** `/api/v1/auth/logout/`
Logout user

**Access**: Authenticated

**Headers**:
```http
Authorization: Bearer <access_token>
```

**Request Body**:
```json
{
  "refresh": "eyJ0eXAiOiJKV1..."
}
```

**Success Response** `204 No Content`

---

### **POST** `/api/v1/auth/password/reset/`
Request password reset

**Access**: Public

**Request Body**:
```json
{
  "email": "user@example.com"
}
```

**Success Response** `200 OK`:
```json
{
  "success": true,
  "message": "Password reset email sent successfully"
}
```

---

### **POST** `/api/v1/auth/password/reset/confirm/`
Confirm password reset

**Access**: Public

**Request Body**:
```json
{
  "token": "reset-token-from-email",
  "password": "NewSecurePass123!",
  "password_confirm": "NewSecurePass123!"
}
```

**Success Response** `200 OK`:
```json
{
  "success": true,
  "message": "Password reset successful"
}
```

---

### **POST** `/api/v1/auth/verify-email/`
Verify email address

**Access**: Public

**Request Body**:
```json
{
  "token": "verification-token-from-email"
}
```

**Success Response** `200 OK`:
```json
{
  "success": true,
  "message": "Email verified successfully"
}
```

---

## 2️⃣ User Profile Endpoints

### **GET** `/api/v1/users/me/`
Get current user profile

**Access**: Authenticated

**Success Response** `200 OK`:
```json
{
  "success": true,
  "data": {
    "id": "uuid",
    "email": "user@example.com",
    "username": "johndoe",
    "first_name": "John",
    "last_name": "Doe",
    "phone": "+919876543210",
    "profile_image": "https://s3.amazonaws.com/...",
    "date_of_birth": "1990-01-01",
    "role": "CUSTOMER",
    "is_verified": true,
    "notification_enabled": true,
    "email_notification_enabled": true,
    "created_at": "2024-01-01T00:00:00Z",
    "last_login": "2024-02-14T10:30:00Z"
  }
}
```

---

### **PATCH** `/api/v1/users/me/`
Update user profile

**Access**: Authenticated

**Request Body** (all fields optional):
```json
{
  "first_name": "John",
  "last_name": "Doe",
  "phone": "+919876543210",
  "date_of_birth": "1990-01-01",
  "notification_enabled": true,
  "email_notification_enabled": false
}
```

**Success Response** `200 OK`:
```json
{
  "success": true,
  "data": {...},
  "message": "Profile updated successfully"
}
```

---

### **POST** `/api/v1/users/me/upload-avatar/`
Upload profile image

**Access**: Authenticated

**Request**: `multipart/form-data`
```
avatar: <file> (max 5MB, jpg/png)
```

**Success Response** `200 OK`:
```json
{
  "success": true,
  "data": {
    "profile_image": "https://s3.amazonaws.com/bucket/profile/uuid.jpg"
  },
  "message": "Profile image uploaded successfully"
}
```

---

### **POST** `/api/v1/users/me/fcm-token/`
Update FCM token for push notifications

**Access**: Authenticated

**Request Body**:
```json
{
  "fcm_token": "firebase-cloud-messaging-token-string"
}
```

**Success Response** `200 OK`:
```json
{
  "success": true,
  "message": "FCM token updated successfully"
}
```

---

## 3️⃣ Address Endpoints

### **GET** `/api/v1/addresses/`
List user addresses

**Access**: Authenticated

**Query Parameters**:
- `is_default` (boolean): Filter by default address

**Success Response** `200 OK`:
```json
{
  "success": true,
  "data": {
    "count": 3,
    "results": [
      {
        "id": "uuid",
        "address_type": "HOME",
        "full_name": "John Doe",
        "phone": "+919876543210",
        "address_line1": "123 Main Street",
        "address_line2": "Apartment 4B",
        "city": "Mumbai",
        "state": "Maharashtra",
        "country": "India",
        "postal_code": "400001",
        "latitude": 19.0760,
        "longitude": 72.8777,
        "is_default": true,
        "is_active": true,
        "created_at": "2024-01-15T10:00:00Z"
      }
    ]
  }
}
```

---

### **POST** `/api/v1/addresses/`
Create new address

**Access**: Authenticated

**Request Body**:
```json
{
  "address_type": "HOME",
  "full_name": "John Doe",
  "phone": "+919876543210",
  "address_line1": "123 Main Street",
  "address_line2": "Apartment 4B",
  "city": "Mumbai",
  "state": "Maharashtra",
  "postal_code": "400001",
  "latitude": 19.0760,
  "longitude": 72.8777,
  "is_default": false
}
```

**Success Response** `201 Created`:
```json
{
  "success": true,
  "data": {...},
  "message": "Address created successfully"
}
```

---

### **PATCH** `/api/v1/addresses/{address_id}/`
Update address

**Access**: Authenticated (Owner only)

**Success Response** `200 OK`

---

### **DELETE** `/api/v1/addresses/{address_id}/`
Delete address

**Access**: Authenticated (Owner only)

**Success Response** `204 No Content`

---

### **POST** `/api/v1/addresses/{address_id}/set-default/`
Set address as default

**Access**: Authenticated (Owner only)

**Success Response** `200 OK`:
```json
{
  "success": true,
  "message": "Default address updated successfully"
}
```

---

## 4️⃣ Category Endpoints

### **GET** `/api/v1/categories/`
List all categories

**Access**: Public

**Query Parameters**:
- `category_type`: FOOD | CLOTHING
- `parent`: Parent category ID (for subcategories)
- `is_active`: true | false (default: true)

**Success Response** `200 OK`:
```json
{
  "success": true,
  "data": {
    "count": 12,
    "results": [
      {
        "id": "uuid",
        "name": "Beverages",
        "slug": "beverages",
        "category_type": "FOOD",
        "parent": null,
        "image": "https://s3.amazonaws.com/...",
        "icon": "https://s3.amazonaws.com/...",
        "description": "Hot and cold beverages",
        "display_order": 1,
        "product_count": 45,
        "subcategories": [
          {
            "id": "uuid",
            "name": "Hot Beverages",
            "slug": "hot-beverages",
            "product_count": 20
          },
          {
            "id": "uuid",
            "name": "Cold Beverages",
            "slug": "cold-beverages",
            "product_count": 25
          }
        ]
      }
    ]
  }
}
```

---

### **GET** `/api/v1/categories/{slug}/`
Get category details

**Access**: Public

**Success Response** `200 OK`:
```json
{
  "success": true,
  "data": {
    "id": "uuid",
    "name": "T-Shirts",
    "slug": "tshirts",
    "category_type": "CLOTHING",
    "parent": {
      "id": "uuid",
      "name": "Men",
      "slug": "men"
    },
    "image": "https://...",
    "description": "Casual and formal t-shirts",
    "product_count": 156,
    "subcategories": []
  }
}
```

---

### **GET** `/api/v1/categories/tree/`
Get hierarchical category tree

**Access**: Public

**Query Parameters**:
- `category_type`: FOOD | CLOTHING (optional, returns all if not specified)

**Success Response** `200 OK`:
```json
{
  "success": true,
  "data": {
    "FOOD": [
      {
        "id": "uuid",
        "name": "Beverages",
        "slug": "beverages",
        "icon": "https://...",
        "children": [
          {
            "id": "uuid",
            "name": "Hot Beverages",
            "slug": "hot-beverages",
            "children": []
          },
          {
            "id": "uuid",
            "name": "Cold Beverages",
            "slug": "cold-beverages",
            "children": []
          }
        ]
      }
    ],
    "CLOTHING": [...]
  }
}
```

---

## 5️⃣ Product Endpoints

### **GET** `/api/v1/products/`
List products with advanced filtering

**Access**: Public

**Query Parameters**:

**Common Filters**:
- `search`: Search by name/description
- `category`: Category UUID
- `category_type`: FOOD | CLOTHING
- `product_type`: FOOD | CLOTHING
- `min_price`: Minimum price
- `max_price`: Maximum price
- `is_featured`: true | false
- `brand`: Brand UUID

**Food-specific Filters**:
- `food_type`: VEG | NON_VEG | VEGAN | EGG
- `cuisine_type`: Indian, Chinese, Italian, etc.
- `spice_level`: 0-5

**Clothing-specific Filters**:
- `gender`: MEN | WOMEN | KIDS | UNISEX
- `size`: S, M, L, XL, etc.
- `color`: Color name
- `material`: Cotton, Polyester, etc.
- `clothing_type`: TOPWEAR | BOTTOMWEAR | FOOTWEAR | ACCESSORIES

**Sorting**:
- `ordering`: price | -price | -created_at | -average_rating | name

**Pagination**:
- `page`: Page number (default: 1)
- `page_size`: Items per page (default: 20, max: 100)

**Success Response** `200 OK`:
```json
{
  "success": true,
  "data": {
    "count": 450,
    "next": "http://api/v1/products/?page=2",
    "previous": null,
    "page": 1,
    "page_size": 20,
    "total_pages": 23,
    "results": [
      {
        "id": "uuid",
        "name": "Classic Cotton T-Shirt",
        "slug": "classic-cotton-tshirt",
        "sku": "CLO-TSH-001",
        "product_type": "CLOTHING",
        "category": {
          "id": "uuid",
          "name": "T-Shirts",
          "slug": "tshirts"
        },
        "brand": {
          "id": "uuid",
          "name": "Nike",
          "logo": "https://..."
        },
        "description": "Comfortable cotton t-shirt perfect for everyday wear...",
        "short_description": "Classic cotton tee for everyday comfort",
        "price": "999.00",
        "compare_at_price": "1499.00",
        "discount_percentage": "33.36",
        "stock_quantity": 150,
        "track_inventory": true,
        "thumbnail": "https://s3.amazonaws.com/...",
        "images": [
          {
            "id": "uuid",
            "image_url": "https://...",
            "alt_text": "Front view",
            "is_primary": true
          },
          {
            "id": "uuid",
            "image_url": "https://...",
            "alt_text": "Back view",
            "is_primary": false
          }
        ],
        "average_rating": 4.5,
        "total_reviews": 23,
        "is_featured": true,
        "is_available": true,
        "has_variants": true,
        "variants_preview": [
          {
            "id": "uuid",
            "size": "M",
            "color": "Red",
            "color_hex": "#FF0000",
            "stock_quantity": 25
          }
        ],
        "clothing_details": {
          "gender": "MEN",
          "clothing_type": "TOPWEAR",
          "material": "100% Cotton",
          "fit_type": "Regular"
        },
        "created_at": "2024-01-10T00:00:00Z"
      }
    ]
  }
}
```

---

### **GET** `/api/v1/products/{slug}/`
Get product details

**Access**: Public

**Success Response** `200 OK`:
```json
{
  "success": true,
  "data": {
    "id": "uuid",
    "name": "Margherita Pizza",
    "slug": "margherita-pizza",
    "sku": "FOOD-PIZ-001",
    "product_type": "FOOD",
    "category": {
      "id": "uuid",
      "name": "Pizzas",
      "slug": "pizzas",
      "breadcrumb": ["Food", "Italian", "Pizzas"]
    },
    "vendor": {
      "id": "uuid",
      "name": "Pizzeria Uno",
      "profile_image": "https://...",
      "average_rating": 4.7
    },
    "description": "Classic margherita pizza with fresh mozzarella, tomato sauce, and basil...",
    "short_description": "Classic Italian margherita",
    "price": "299.00",
    "compare_at_price": "399.00",
    "discount_percentage": "25.06",
    "stock_quantity": 0,
    "track_inventory": false,
    "thumbnail": "https://...",
    "images": [
      {
        "id": "uuid",
        "image_url": "https://...",
        "alt_text": "Margherita Pizza",
        "display_order": 0,
        "is_primary": true
      }
    ],
    "average_rating": 4.8,
    "total_reviews": 156,
    "reviews_summary": {
      "5_star": 120,
      "4_star": 25,
      "3_star": 8,
      "2_star": 2,
      "1_star": 1
    },
    "food_details": {
      "food_type": "VEG",
      "cuisine_type": "Italian",
      "spice_level": 1,
      "calories": 250,
      "protein": 12.5,
      "carbs": 35.0,
      "fat": 8.5,
      "serving_size": "1 medium pizza",
      "preparation_time": 20,
      "contains_gluten": true,
      "contains_dairy": true,
      "contains_nuts": false,
      "is_perishable": true
    },
    "recommendations": [
      {
        "id": "uuid",
        "name": "Pepperoni Pizza",
        "slug": "pepperoni-pizza",
        "thumbnail": "https://...",
        "price": "349.00",
        "average_rating": 4.6
      }
    ],
    "is_in_wishlist": false,
    "view_count": 1245,
    "created_at": "2024-01-05T00:00:00Z"
  }
}
```

---

### **GET** `/api/v1/products/{slug}/variants/`
Get product variants

**Access**: Public

**Success Response** `200 OK`:
```json
{
  "success": true,
  "data": [
    {
      "id": "uuid",
      "sku": "CLO-TSH-001-RED-M",
      "size": "M",
      "color": "Red",
      "color_hex": "#FF0000",
      "price": "999.00",
      "stock_quantity": 25,
      "image_url": "https://...",
      "is_active": true
    },
    {
      "id": "uuid",
      "sku": "CLO-TSH-001-RED-L",
      "size": "L",
      "color": "Red",
      "color_hex": "#FF0000",
      "price": "999.00",
      "stock_quantity": 30,
      "image_url": "https://...",
      "is_active": true
    }
  ]
}
```

---

### **GET** `/api/v1/products/featured/`
Get featured products

**Access**: Public

**Query Parameters**:
- `category_type`: FOOD | CLOTHING
- `limit`: Number of products (default: 10)

**Success Response** `200 OK`

---

### **GET** `/api/v1/products/recommendations/`
Get personalized recommendations for user

**Access**: Authenticated

**Query Parameters**:
- `limit`: Number of recommendations (default: 10)

**Success Response** `200 OK`:
```json
{
  "success": true,
  "data": {
    "recommended_for_you": [...],
    "trending": [...],
    "based_on_history": [...]
  }
}
```

---

### **POST** `/api/v1/products/{slug}/view/`
Track product view (for recommendations)

**Access**: Authenticated (optional - can track for guests)

**Success Response** `200 OK`

---

## 6️⃣ Cart Endpoints

### **GET** `/api/v1/cart/`
Get user's cart

**Access**: Authenticated

**Success Response** `200 OK`:
```json
{
  "success": true,
  "data": {
    "id": "uuid",
    "items": [
      {
        "id": "uuid",
        "product": {
          "id": "uuid",
          "name": "Classic Cotton T-Shirt",
          "slug": "classic-cotton-tshirt",
          "thumbnail": "https://...",
          "is_available": true,
          "stock_quantity": 150
        },
        "variant": {
          "id": "uuid",
          "size": "M",
          "color": "Red",
          "color_hex": "#FF0000",
          "stock_quantity": 25
        },
        "quantity": 2,
        "unit_price": "999.00",
        "total_price": "1998.00",
        "created_at": "2024-02-10T10:00:00Z"
      }
    ],
    "items_count": 2,
    "subtotal": "1998.00",
    "tax": "359.64",
    "shipping_cost": "0.00",
    "discount": "199.80",
    "total": "2157.84",
    "coupon": {
      "code": "SAVE10",
      "discount_type": "PERCENTAGE",
      "discount_value": "10.00",
      "discount_amount": "199.80"
    },
    "created_at": "2024-02-10T10:00:00Z",
    "updated_at": "2024-02-14T15:30:00Z"
  }
}
```

---

### **POST** `/api/v1/cart/add/`
Add item to cart

**Access**: Authenticated

**Request Body**:
```json
{
  "product_id": "uuid",
  "variant_id": "uuid",  // optional, required for products with variants
  "quantity": 1
}
```

**Success Response** `201 Created`:
```json
{
  "success": true,
  "data": {
    "cart_item": {...},
    "cart_summary": {
      "items_count": 3,
      "total": "2999.00"
    }
  },
  "message": "Item added to cart"
}
```

**Error Response** `400 Bad Request`:
```json
{
  "success": false,
  "message": "Product out of stock",
  "errors": {
    "stock": ["Only 5 items available"]
  }
}
```

---

### **PATCH** `/api/v1/cart/items/{item_id}/`
Update cart item quantity

**Access**: Authenticated (Owner only)

**Request Body**:
```json
{
  "quantity": 3
}
```

**Success Response** `200 OK`:
```json
{
  "success": true,
  "data": {
    "cart_item": {...},
    "cart_summary": {...}
  },
  "message": "Cart updated"
}
```

---

### **DELETE** `/api/v1/cart/items/{item_id}/`
Remove item from cart

**Access**: Authenticated (Owner only)

**Success Response** `204 No Content`

---

### **POST** `/api/v1/cart/apply-coupon/`
Apply coupon code

**Access**: Authenticated

**Request Body**:
```json
{
  "coupon_code": "SAVE10"
}
```

**Success Response** `200 OK`:
```json
{
  "success": true,
  "data": {
    "coupon": {
      "code": "SAVE10",
      "discount_type": "PERCENTAGE",
      "discount_value": "10.00"
    },
    "discount": "199.80",
    "total": "2157.84"
  },
  "message": "Coupon applied successfully"
}
```

**Error Response** `400 Bad Request`:
```json
{
  "success": false,
  "message": "Invalid coupon",
  "errors": {
    "coupon": ["Coupon has expired"]
  }
}
```

---

### **DELETE** `/api/v1/cart/remove-coupon/`
Remove applied coupon

**Access**: Authenticated

**Success Response** `200 OK`

---

### **DELETE** `/api/v1/cart/clear/`
Clear entire cart

**Access**: Authenticated

**Success Response** `204 No Content`

---

## 7️⃣ Wishlist Endpoints

### **GET** `/api/v1/wishlist/`
Get user's wishlist

**Access**: Authenticated

**Success Response** `200 OK`:
```json
{
  "success": true,
  "data": {
    "count": 5,
    "items": [
      {
        "id": "uuid",
        "product": {
          "id": "uuid",
          "name": "Classic Cotton T-Shirt",
          "slug": "classic-cotton-tshirt",
          "thumbnail": "https://...",
          "price": "999.00",
          "compare_at_price": "1499.00",
          "discount_percentage": "33.36",
          "average_rating": 4.5,
          "is_available": true,
          "stock_quantity": 150
        },
        "added_at": "2024-01-15T10:30:00Z"
      }
    ]
  }
}
```

---

### **POST** `/api/v1/wishlist/add/`
Add product to wishlist

**Access**: Authenticated

**Request Body**:
```json
{
  "product_id": "uuid"
}
```

**Success Response** `201 Created`:
```json
{
  "success": true,
  "message": "Added to wishlist"
}
```

---

### **DELETE** `/api/v1/wishlist/remove/{product_id}/`
Remove product from wishlist

**Access**: Authenticated

**Success Response** `204 No Content`

---

### **POST** `/api/v1/wishlist/move-to-cart/{product_id}/`
Move wishlist item to cart

**Access**: Authenticated

**Success Response** `200 OK`:
```json
{
  "success": true,
  "message": "Item moved to cart"
}
```

---

### **DELETE** `/api/v1/wishlist/clear/`
Clear wishlist

**Access**: Authenticated

**Success Response** `204 No Content`

---

## 8️⃣ Order Endpoints

### **GET** `/api/v1/orders/`
List user orders

**Access**: Authenticated

**Query Parameters**:
- `status`: PENDING | CONFIRMED | PROCESSING | SHIPPED | DELIVERED | CANCELLED
- `ordering`: -created_at | created_at | -total
- `page`: Page number
- `page_size`: Items per page

**Success Response** `200 OK`:
```json
{
  "success": true,
  "data": {
    "count": 15,
    "next": null,
    "previous": null,
    "results": [
      {
        "id": "uuid",
        "order_number": "ORD-2024-001234",
        "status": "DELIVERED",
        "payment_status": "PAID",
        "total": "2157.84",
        "items_count": 2,
        "items_preview": [
          {
            "product_name": "Classic Cotton T-Shirt",
            "product_image": "https://...",
            "quantity": 2
          }
        ],
        "created_at": "2024-01-15T10:30:00Z",
        "estimated_delivery": "2024-01-18T00:00:00Z",
        "delivered_at": "2024-01-18T14:20:00Z"
      }
    ]
  }
}
```

---

### **GET** `/api/v1/orders/{order_number}/`
Get order details

**Access**: Authenticated (Owner/Admin)

**Success Response** `200 OK`:
```json
{
  "success": true,
  "data": {
    "id": "uuid",
    "order_number": "ORD-2024-001234",
    "status": "DELIVERED",
    "payment_status": "PAID",
    "items": [
      {
        "id": "uuid",
        "product_name": "Classic Cotton T-Shirt",
        "product_image": "https://...",
        "sku": "CLO-TSH-001",
        "variant_size": "M",
        "variant_color": "Red",
        "quantity": 2,
        "unit_price": "999.00",
        "total_price": "1998.00",
        "discount": "0.00",
        "vendor": {
          "id": "uuid",
          "name": "Fashion Store",
          "phone": "+919876543210"
        }
      }
    ],
    "subtotal": "1998.00",
    "tax": "359.64",
    "shipping_cost": "0.00",
    "discount": "199.80",
    "total": "2157.84",
    "shipping_address": {
      "full_name": "John Doe",
      "phone": "+919876543210",
      "address_line1": "123 Main Street",
      "address_line2": "Apartment 4B",
      "city": "Mumbai",
      "state": "Maharashtra",
      "country": "India",
      "postal_code": "400001"
    },
    "billing_address": {...},
    "payment_method": "razorpay",
    "payment_id": "pay_abc123xyz",
    "transaction_id": "txn_xyz789abc",
    "tracking_number": "TRK123456789",
    "estimated_delivery": "2024-01-18T00:00:00Z",
    "delivered_at": "2024-01-18T14:20:00Z",
    "customer_note": "Please deliver in evening",
    "status_history": [
      {
        "status": "PENDING",
        "notes": "Order placed",
        "created_at": "2024-01-15T10:30:00Z"
      },
      {
        "status": "CONFIRMED",
        "notes": "Payment confirmed",
        "created_at": "2024-01-15T10:31:00Z"
      },
      {
        "status": "PROCESSING",
        "notes": "Order being prepared",
        "created_at": "2024-01-15T14:00:00Z"
      },
      {
        "status": "SHIPPED",
        "notes": "Order shipped",
        "created_at": "2024-01-16T09:00:00Z"
      },
      {
        "status": "OUT_FOR_DELIVERY",
        "notes": "Out for delivery",
        "created_at": "2024-01-18T08:00:00Z"
      },
      {
        "status": "DELIVERED",
        "notes": "Order delivered successfully",
        "created_at": "2024-01-18T14:20:00Z"
      }
    ],
    "created_at": "2024-01-15T10:30:00Z",
    "updated_at": "2024-01-18T14:20:00Z"
  }
}
```

---

### **POST** `/api/v1/orders/create/`
Create order from cart

**Access**: Authenticated

**Request Body**:
```json
{
  "shipping_address_id": "uuid",
  "billing_address_id": "uuid",  // optional, defaults to shipping
  "payment_method": "razorpay",
  "customer_note": "Please deliver in evening"
}
```

**Success Response** `201 Created`:
```json
{
  "success": true,
  "data": {
    "order_id": "uuid",
    "order_number": "ORD-2024-001234",
    "total": "2157.84",
    "payment_required": true,
    "payment_details": {
      "razorpay_order_id": "order_abc123xyz",
      "amount": 215784,  // in paise
      "currency": "INR",
      "key_id": "rzp_live_..."
    }
  },
  "message": "Order created successfully"
}
```

---

### **POST** `/api/v1/orders/{order_number}/cancel/`
Cancel order

**Access**: Authenticated (Owner only)

**Request Body**:
```json
{
  "reason": "Changed my mind"
}
```

**Success Response** `200 OK`:
```json
{
  "success": true,
  "message": "Order cancelled successfully"
}
```

**Error Response** `400 Bad Request`:
```json
{
  "success": false,
  "message": "Cannot cancel order",
  "errors": {
    "status": ["Order already shipped"]
  }
}
```

---

### **POST** `/api/v1/orders/{order_number}/reorder/`
Reorder (add items to cart)

**Access**: Authenticated (Owner only)

**Success Response** `200 OK`:
```json
{
  "success": true,
  "message": "Items added to cart"
}
```

---

### **GET** `/api/v1/orders/{order_number}/track/`
Track order status

**Access**: Authenticated (Owner only)

**Success Response** `200 OK`:
```json
{
  "success": true,
  "data": {
    "order_number": "ORD-2024-001234",
    "status": "OUT_FOR_DELIVERY",
    "tracking_number": "TRK123456789",
    "estimated_delivery": "2024-01-18T00:00:00Z",
    "timeline": [...]
  }
}
```

---

### **GET** `/api/v1/orders/{order_number}/invoice/`
Download invoice PDF

**Access**: Authenticated (Owner only)

**Success Response**: PDF file download

---

## 9️⃣ Payment Endpoints

### **POST** `/api/v1/payments/verify/`
Verify payment (Razorpay/Stripe)

**Access**: Authenticated

**Request Body** (Razorpay):
```json
{
  "razorpay_order_id": "order_abc123xyz",
  "razorpay_payment_id": "pay_xyz789abc",
  "razorpay_signature": "signature_string"
}
```

**Success Response** `200 OK`:
```json
{
  "success": true,
  "data": {
    "order_number": "ORD-2024-001234",
    "payment_status": "PAID",
    "transaction_id": "txn_xyz789abc"
  },
  "message": "Payment verified successfully"
}
```

---

### **POST** `/api/v1/payments/webhook/`
Payment gateway webhook (Internal use)

**Access**: Webhook signature verification

**Request Body**: Gateway-specific payload

**Success Response** `200 OK`

---

## 🔟 Review Endpoints

### **GET** `/api/v1/products/{slug}/reviews/`
Get product reviews

**Access**: Public

**Query Parameters**:
- `rating`: Filter by rating (1-5)
- `ordering`: -created_at | -helpful_count | rating
- `page`: Page number
- `page_size`: Items per page

**Success Response** `200 OK`:
```json
{
  "success": true,
  "data": {
    "count": 23,
    "average_rating": 4.5,
    "rating_distribution": {
      "5": 15,
      "4": 5,
      "3": 2,
      "2": 1,
      "1": 0
    },
    "results": [
      {
        "id": "uuid",
        "user": {
          "id": "uuid",
          "username": "johndoe",
          "profile_image": "https://..."
        },
        "rating": 5,
        "title": "Excellent product!",
        "comment": "Very comfortable and good quality. Highly recommended!",
        "images": ["https://...", "https://..."],
        "is_verified_purchase": true,
        "helpful_count": 12,
        "response": {
          "comment": "Thank you for your feedback!",
          "user": {
            "name": "Fashion Store",
            "role": "VENDOR"
          },
          "created_at": "2024-01-16T10:00:00Z"
        },
        "created_at": "2024-01-15T14:30:00Z"
      }
    ]
  }
}
```

---

### **POST** `/api/v1/reviews/create/`
Create product review

**Access**: Authenticated

**Request Body**:
```json
{
  "product_id": "uuid",
  "order_item_id": "uuid",  // optional, for verified purchase
  "rating": 5,
  "title": "Excellent product!",
  "comment": "Very comfortable and good quality...",
  "images": ["data:image/jpeg;base64,..."]  // Base64 encoded, max 5 images
}
```

**Success Response** `201 Created`:
```json
{
  "success": true,
  "data": {...},
  "message": "Review submitted successfully"
}
```

---

### **PATCH** `/api/v1/reviews/{review_id}/`
Update review

**Access**: Authenticated (Owner only)

**Success Response** `200 OK`

---

### **DELETE** `/api/v1/reviews/{review_id}/`
Delete review

**Access**: Authenticated (Owner only)

**Success Response** `204 No Content`

---

### **POST** `/api/v1/reviews/{review_id}/helpful/`
Mark review as helpful

**Access**: Authenticated

**Success Response** `200 OK`:
```json
{
  "success": true,
  "message": "Marked as helpful"
}
```

---

## 1️⃣1️⃣ Notification Endpoints

### **GET** `/api/v1/notifications/`
Get user notifications

**Access**: Authenticated

**Query Parameters**:
- `is_read`: true | false
- `notification_type`: ORDER_PLACED | ORDER_SHIPPED | etc.
- `page`: Page number

**Success Response** `200 OK`:
```json
{
  "success": true,
  "data": {
    "count": 25,
    "unread_count": 5,
    "results": [
      {
        "id": "uuid",
        "notification_type": "ORDER_SHIPPED",
        "title": "Order Shipped!",
        "message": "Your order ORD-2024-001234 has been shipped",
        "action_url": "/orders/ORD-2024-001234",
        "is_read": false,
        "created_at": "2024-01-16T09:00:00Z"
      }
    ]
  }
}
```

---

### **PATCH** `/api/v1/notifications/{notification_id}/read/`
Mark notification as read

**Access**: Authenticated (Owner only)

**Success Response** `200 OK`

---

### **POST** `/api/v1/notifications/mark-all-read/`
Mark all notifications as read

**Access**: Authenticated

**Success Response** `200 OK`

---

### **DELETE** `/api/v1/notifications/{notification_id}/`
Delete notification

**Access**: Authenticated (Owner only)

**Success Response** `204 No Content`

---

## 1️⃣2️⃣ Search Endpoints

### **GET** `/api/v1/search/`
Global search

**Access**: Public

**Query Parameters**:
- `q`: Search query (required, min 2 chars)
- `type`: products | categories | brands (optional)

**Success Response** `200 OK`:
```json
{
  "success": true,
  "data": {
    "query": "cotton tshirt",
    "products": {
      "count": 45,
      "results": [...]
    },
    "categories": {
      "count": 2,
      "results": [...]
    },
    "brands": {
      "count": 5,
      "results": [...]
    }
  }
}
```

---

### **GET** `/api/v1/search/suggestions/`
Search autocomplete suggestions

**Access**: Public

**Query Parameters**:
- `q`: Search query (required, min 2 chars)

**Success Response** `200 OK`:
```json
{
  "success": true,
  "data": {
    "suggestions": [
      "cotton tshirt",
      "cotton shirt",
      "cotton pants",
      "cotton dress"
    ]
  }
}
```

---

## 1️⃣3️⃣ Admin Endpoints

**Note**: All admin endpoints require `role=ADMIN`

### **GET** `/api/v1/admin/dashboard/stats/`
Dashboard statistics

**Success Response** `200 OK`:
```json
{
  "success": true,
  "data": {
    "overview": {
      "total_users": 1523,
      "total_vendors": 45,
      "total_orders": 4567,
      "total_revenue": "1234567.89",
      "pending_orders": 23,
      "low_stock_products": 15
    },
    "today": {
      "orders": 45,
      "revenue": "45678.90",
      "new_users": 12
    },
    "top_products": [...],
    "recent_orders": [...],
    "revenue_chart": {
      "labels": ["Jan", "Feb", "Mar", "Apr", "May", "Jun"],
      "data": [120000, 150000, 180000, 165000, 195000, 210000]
    }
  }
}
```

---

### **GET** `/api/v1/admin/users/`
List all users

**Query Parameters**:
- `role`: CUSTOMER | VENDOR | ADMIN
- `is_active`: true | false
- `search`: Search by name/email

**Success Response** `200 OK`

---

### **PATCH** `/api/v1/admin/users/{user_id}/toggle-active/`
Activate/deactivate user

**Success Response** `200 OK`

---

### **GET** `/api/v1/admin/vendors/pending/`
List pending vendor approvals

**Success Response** `200 OK`

---

### **POST** `/api/v1/admin/vendors/{vendor_id}/approve/`
Approve vendor

**Success Response** `200 OK`

---

### **POST** `/api/v1/admin/products/`
Create product (admin)

**Request Body**: Same as vendor product creation

**Success Response** `201 Created`

---

### **POST** `/api/v1/admin/products/bulk-upload/`
Bulk upload products via CSV

**Request**: `multipart/form-data`
```
file: <csv_file>
```

**Success Response** `200 OK`:
```json
{
  "success": true,
  "data": {
    "total_rows": 100,
    "successful": 95,
    "failed": 5,
    "errors": [...]
  },
  "message": "Bulk upload completed"
}
```

---

### **PATCH** `/api/v1/admin/orders/{order_id}/status/`
Update order status

**Request Body**:
```json
{
  "status": "SHIPPED",
  "tracking_number": "TRK123456789",
  "notes": "Order shipped via FedEx"
}
```

**Success Response** `200 OK`

---

## 1️⃣4️⃣ Vendor Endpoints

**Note**: All vendor endpoints require `role=VENDOR`

### **GET** `/api/v1/vendor/dashboard/`
Vendor dashboard stats

**Success Response** `200 OK`:
```json
{
  "success": true,
  "data": {
    "total_products": 45,
    "active_products": 42,
    "total_orders": 234,
    "pending_orders": 12,
    "total_revenue": "45678.90",
    "this_month_revenue": "12345.67",
    "top_products": [...]
  }
}
```

---

### **GET** `/api/v1/vendor/products/`
List vendor's products

**Success Response** `200 OK`

---

### **POST** `/api/v1/vendor/products/`
Create product (vendor)

**Success Response** `201 Created`

---

### **GET** `/api/v1/vendor/orders/`
List vendor's orders

**Success Response** `200 OK`

---

### **PATCH** `/api/v1/vendor/orders/{order_item_id}/fulfill/`
Mark order item as fulfilled

**Success Response** `200 OK`

---

## 📊 Error Response Format

All errors follow this format:

```json
{
  "success": false,
  "data": null,
  "message": "Error message",
  "errors": {
    "field_name": ["Error description"]
  }
}
```

### **Common Error Codes**:
- `400` - Bad Request (Validation errors)
- `401` - Unauthorized (Authentication required)
- `403` - Forbidden (Permission denied)
- `404` - Not Found
- `409` - Conflict (Duplicate resource)
- `429` - Too Many Requests (Rate limit)
- `500` - Internal Server Error

---

## 🔄 Rate Limiting

**Limits**:
- Anonymous: 100 requests/hour
- Authenticated: 1000 requests/hour
- Admin/Vendor: 5000 requests/hour

**Response Headers**:
```http
X-RateLimit-Limit: 1000
X-RateLimit-Remaining: 998
X-RateLimit-Reset: 1640995200
```

**Rate Limit Exceeded** `429`:
```json
{
  "success": false,
  "message": "Rate limit exceeded. Try again in 30 minutes."
}
```

---

## 📝 Pagination

**Query Parameters**:
- `page`: Page number (default: 1)
- `page_size`: Items per page (default: 20, max: 100)

**Response**:
```json
{
  "count": 450,
  "next": "http://api/v1/products/?page=2",
  "previous": null,
  "page": 1,
  "page_size": 20,
  "total_pages": 23,
  "results": [...]
}
```

---

## 🔍 Filtering & Ordering

**Common Parameters**:
- `search`: Full-text search
- `ordering`: Field to order by (prefix `-` for descending)
- Filter by any field: `?field_name=value`

**Example**:
```
GET /api/v1/products/?search=cotton&ordering=-created_at&min_price=500&max_price=2000&food_type=VEG
```

---

**API Documentation Complete** ✅  
**Version**: 1.0.0  
**Total Endpoints**: 80+  
**Last Updated**: February 2026
