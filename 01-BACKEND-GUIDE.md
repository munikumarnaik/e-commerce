# 🛠️ Backend Implementation Guide
## Dual-Category E-Commerce — Food & Clothing
> **Stack:** Django REST Framework · PostgreSQL · Redis · Celery · AWS S3 · JWT · Docker · Gunicorn + Nginx

---

## 📌 Table of Contents

1. [Project Overview](#1-project-overview)
2. [Tech Stack](#2-tech-stack)
3. [Project Folder Structure](#3-project-folder-structure)
4. [Database Models & Schema](#4-database-models--schema)
5. [Authentication System](#5-authentication-system)
6. [API Endpoints Reference](#6-api-endpoints-reference)
7. [Product Catalog System](#7-product-catalog-system)
8. [Cart & Wishlist Module](#8-cart--wishlist-module)
9. [Coupon & Checkout System](#9-coupon--checkout-system)
10. [Order Management](#10-order-management)
11. [Payment Integration](#11-payment-integration)
12. [Reviews & Ratings](#12-reviews--ratings)
13. [AI Recommendations](#13-ai-recommendations)
14. [Push Notifications](#14-push-notifications)
15. [Admin & Vendor Dashboard](#15-admin--vendor-dashboard)
16. [Search & Filtering](#16-search--filtering)
17. [Caching Strategy](#17-caching-strategy)
18. [Background Tasks — Celery](#18-background-tasks--celery)
19. [Security Implementation](#19-security-implementation)
20. [DevOps & Deployment](#20-devops--deployment)
21. [Testing Strategy](#21-testing-strategy)
22. [Performance Targets](#22-performance-targets)
23. [Phase-wise Roadmap](#23-phase-wise-roadmap)

---

## 1. Project Overview

The backend is a RESTful API server that serves both the Flutter mobile app and the web admin panel. It manages all data, business logic, payment processing, notifications, and analytics for a dual-category e-commerce platform handling **Food** and **Clothing** verticals under one unified system.

### Responsibilities of the Backend

- User authentication and role-based access control
- Product catalog management for both Food and Clothing
- Cart, wishlist, coupon, and checkout processing
- Order lifecycle management with state tracking
- Payment processing and webhook handling
- Push notification delivery via Firebase
- AI-based product recommendations
- Admin analytics and vendor management
- File uploads to AWS S3
- Background job processing via Celery

---

## 2. Tech Stack

| Layer | Technology | Version | Purpose |
|-------|-----------|---------|---------|
| Web Framework | Django | 5.0 | Core application framework |
| API Layer | Django REST Framework | 3.15 | RESTful API builder |
| Database | PostgreSQL | 15 | Primary relational database |
| Cache | Redis | 7 | API caching, session store, Celery broker |
| Task Queue | Celery | 5.3 | Async and scheduled background tasks |
| File Storage | AWS S3 + django-storages | Latest | Product images, invoices, exports |
| Authentication | JWT — SimpleJWT | 5.3 | Stateless token-based auth |
| Payment — India | Razorpay | 1.4 | INR payment processing |
| Payment — Global | Stripe | 8.5 | International payment processing |
| Push Notifications | Firebase Admin SDK | 6.4 | FCM-based mobile notifications |
| Email | AWS SES / SMTP | — | Transactional emails via Celery |
| Web Server | Gunicorn + Nginx | 21.2 | Production WSGI server + reverse proxy |
| Containerization | Docker + Docker Compose | Latest | Consistent dev and prod environments |
| CI/CD | GitHub Actions | — | Automated test and deployment pipeline |
| Monitoring | Sentry | 1.40 | Error tracking and alerting |
| APM | New Relic | — | Application performance monitoring |
| Logging | AWS CloudWatch / ELK Stack | — | Centralized log management |
| Search | PostgreSQL Full-Text Search | — | Product search with tsvector ranking |

---

## 3. Project Folder Structure

```
ecommerce_backend/
│
├── config/                        ← Django project configuration
│   ├── settings/
│   │   ├── base.py                ← Shared settings
│   │   ├── development.py         ← Dev-specific settings
│   │   └── production.py          ← Production settings
│   ├── urls.py                    ← Root URL routing
│   ├── wsgi.py
│   └── asgi.py
│
├── apps/                          ← All Django applications
│   ├── users/                     ← User model, auth, addresses
│   ├── products/                  ← Base product and category models
│   ├── food/                      ← Food-specific product extension
│   ├── clothing/                  ← Clothing-specific product extension
│   ├── cart/                      ← Cart and CartItem management
│   ├── wishlist/                  ← Wishlist management
│   ├── orders/                    ← Order lifecycle and tracking
│   ├── payments/                  ← Payment processing and webhooks
│   ├── coupons/                   ← Coupon and discount system
│   ├── reviews/                   ← Product reviews and ratings
│   ├── recommendations/           ← AI recommendation engine
│   ├── notifications/             ← FCM and in-app notifications
│   └── analytics/                 ← Admin analytics and reports
│
├── core/                          ← Shared utilities
│   ├── permissions.py             ← Custom DRF permissions
│   ├── pagination.py              ← Custom pagination classes
│   ├── exceptions.py              ← Custom error handlers
│   ├── mixins.py                  ← Reusable view mixins
│   └── utils.py                   ← Helper functions
│
├── services/                      ← Third-party service wrappers
│   ├── s3_service.py              ← AWS S3 upload/delete logic
│   ├── payment_service.py         ← Razorpay / Stripe abstraction
│   ├── email_service.py           ← Email sending logic
│   └── fcm_service.py             ← Firebase push notification logic
│
├── celery_tasks/                  ← All Celery background tasks
│   ├── notification_tasks.py      ← Order status notifications
│   ├── recommendation_tasks.py    ← Recommendation generation
│   ├── email_tasks.py             ← Async email sending
│   └── report_tasks.py            ← Scheduled daily/weekly reports
│
├── requirements/
│   ├── base.txt                   ← Shared dependencies
│   ├── development.txt            ← Dev-only dependencies
│   └── production.txt             ← Production dependencies
│
├── docker/
│   ├── Dockerfile                 ← App container definition
│   └── docker-compose.yml        ← Multi-service local setup
│
├── .github/
│   └── workflows/
│       └── deploy.yml             ← GitHub Actions CI/CD pipeline
│
└── manage.py
```

---

## 4. Database Models & Schema

### 4.1 User & Access Models

| Model | Key Fields | Description |
|-------|-----------|-------------|
| `User` | id (UUID), email, phone, full_name, role, avatar, is_verified, fcm_token, created_at | Central user model with roles: Customer, Vendor, Admin |
| `Address` | id, user, label, full_name, phone, line1, line2, city, state, pincode, lat, lng, is_default | Multiple saved delivery addresses per user |

**User Roles**

| Role | Description |
|------|-------------|
| Customer | Can browse, add to cart, place orders, write reviews |
| Vendor | Can manage their own products, inventory, and view their orders |
| Admin | Full access to all data, analytics, and management tools |

---

### 4.2 Product Catalog Models

| Model | Key Fields | Description |
|-------|-----------|-------------|
| `Category` | id, name, slug, type (food/clothing), parent, icon, banner, sort_order, is_active | Hierarchical categories supporting both verticals |
| `Product` | id, vendor, category, name, slug, description, base_price, mrp, stock, sku, status, rating_avg, rating_count | Base product shared across Food and Clothing |
| `FoodProduct` | product (OneToOne), cuisine, diet_type, calories, allergens, ingredients, prep_time, is_halal, is_gluten_free, nutritional_info, expiry_days | Food-specific extension of Product |
| `ClothingProduct` | product (OneToOne), gender, brand, fabric, fit, care_instructions, country_of_origin | Clothing-specific extension of Product |
| `ProductVariant` | id, product, size, color, color_hex, price, stock, sku, images | Size and colour variants for a product |
| `ProductImage` | id, product, url, is_primary, sort_order | Multiple S3-hosted images per product |

**Food-Specific Fields Explained**

| Field | Type | Values / Notes |
|-------|------|----------------|
| diet_type | Enum | Vegetarian, Non-Vegetarian, Vegan |
| cuisine | String | Indian, Chinese, Italian, etc. |
| calories | Integer | Per serving |
| allergens | JSON Array | e.g. ["nuts", "gluten", "dairy"] |
| prep_time | Integer | Minutes |
| is_halal | Boolean | Halal certified |
| is_gluten_free | Boolean | Gluten-free certified |
| nutritional_info | JSON Object | protein, carbs, fat, fiber values |

**Clothing-Specific Fields Explained**

| Field | Type | Values / Notes |
|-------|------|----------------|
| gender | Enum | Men, Women, Unisex, Kids |
| brand | String | Brand name |
| fabric | String | Cotton, Polyester, Linen, Silk, etc. |
| fit | String | Slim, Regular, Relaxed, Oversized |
| care_instructions | Text | Wash and care guidelines |
| country_of_origin | String | Manufacturing country |

---

### 4.3 Commerce Models

| Model | Key Fields | Description |
|-------|-----------|-------------|
| `Cart` | id, user (OneToOne), expires_at, updated_at | One active cart per user, expires after 30 days |
| `CartItem` | id, cart, product, variant, quantity, added_at | Individual item within the cart |
| `Wishlist` | id, user (OneToOne) | One wishlist per user |
| `WishlistItem` | id, wishlist, product, variant, added_at | Saved items in the wishlist |
| `Coupon` | id, code, discount_type, value, min_order_amount, max_discount, expiry, usage_limit, used_count, is_active | Promotional coupon codes |
| `Order` | id, order_number, user, address, status, subtotal, tax, delivery_charge, discount, total, coupon, notes, created_at | Master order record |
| `OrderItem` | id, order, product, variant, quantity, unit_price, total_price | Individual line items in an order |
| `OrderStatusHistory` | id, order, status, note, updated_by, updated_at | Full audit trail of all status changes |

**Order Status Flow**

```
Pending → Confirmed → Processing → Shipped → Out for Delivery → Delivered
                                  ↘ Cancelled
                                  ↘ Refunded
```

---

### 4.4 Payment Models

| Model | Key Fields | Description |
|-------|-----------|-------------|
| `Payment` | id, order, gateway (razorpay/stripe), gateway_order_id, payment_id, signature, amount, currency, status, created_at | Payment transaction record |
| `Refund` | id, payment, amount, reason, status, gateway_refund_id, processed_at | Tracks refund requests and processing |

---

### 4.5 Review & Rating Models

| Model | Key Fields | Description |
|-------|-----------|-------------|
| `Review` | id, user, product, rating (1–5), title, body, images, is_verified_purchase, is_approved, created_at | User-submitted product review |
| `ReviewResponse` | id, review, vendor, body, created_at | Vendor reply to a review |
| `ReviewHelpful` | id, review, user | Tracks who found a review helpful |

---

### 4.6 Recommendation & Notification Models

| Model | Key Fields | Description |
|-------|-----------|-------------|
| `BrowsingHistory` | id, user, product, viewed_at, view_count | Tracks products viewed by a user |
| `ProductRecommendation` | id, user, product, score, reason, created_at | Pre-computed recommendations per user |
| `Notification` | id, user, title, body, type, data (JSON), is_read, created_at | In-app notification history |
| `NotificationPreference` | id, user, order_updates, promotions, new_arrivals, email_enabled, push_enabled | Per-user notification settings |

---

### 4.7 Database Indexing Strategy

| Table | Index | Reason |
|-------|-------|--------|
| products | (category, status) | Category listing queries |
| products | (vendor, status) | Vendor product management |
| products | (-created_at) | Newest products sorting |
| products | GIN on search_vector | Full-text search performance |
| orders | (user, -created_at) | Order history queries |
| cart_items | (cart, product) | Cart lookup queries |
| browsing_history | (user, -viewed_at) | Recommendation engine input |
| notifications | (user, is_read) | Unread notification count |

---

## 5. Authentication System

### Flow Diagram

```
User Registers
      ↓
OTP sent to Email (Celery Task, 10 min TTL in Redis)
      ↓
User Verifies Email → is_verified = True
      ↓
User Logs In → Access Token (2 hrs) + Refresh Token (30 days)
      ↓
Access Token Expires
      ↓
Refresh Token used → New Access Token issued + Old Refresh Token blacklisted
      ↓
Refresh Token Expires → User must log in again
```

### Token Configuration

| Parameter | Value |
|-----------|-------|
| Access Token Lifetime | 2 hours |
| Refresh Token Lifetime | 30 days |
| Token Rotation | Enabled |
| Blacklisting on Rotation | Enabled |
| Header Format | `Authorization: Bearer <token>` |
| User Identifier in Token | UUID (`user_id`) |

### Role-Based Access Rules

| Endpoint Type | Customer | Vendor | Admin |
|---------------|----------|--------|-------|
| Browse Products | ✅ | ✅ | ✅ |
| Place Orders | ✅ | ✅ | ✅ |
| Manage Own Products | ❌ | ✅ | ✅ |
| Approve Vendors | ❌ | ❌ | ✅ |
| View All Orders | ❌ | Own only | ✅ |
| Access Analytics | ❌ | Own only | ✅ |
| Manage Users | ❌ | ❌ | ✅ |

---

## 6. API Endpoints Reference

### Base URL
```
Production:   https://api.shopverse.com/api/v1/
Development:  http://localhost:8000/api/v1/
```

### Standard Response Format

| Scenario | Response Structure |
|----------|-------------------|
| Success (single) | `{ status, data: {...}, message }` |
| Success (list) | `{ status, data: [...], pagination: { page, per_page, total, pages } }` |
| Validation Error | `{ status, code, message, details: { field: [errors] } }` |
| Auth Error | `{ status, code: "unauthorized", message }` |
| Server Error | `{ status, code: "server_error", message }` |

---

### 6.1 Authentication Endpoints

| Method | Endpoint | Description | Auth Required |
|--------|----------|-------------|--------------|
| POST | `/auth/register/` | Register new user | No |
| POST | `/auth/login/` | Login and receive JWT tokens | No |
| POST | `/auth/token/refresh/` | Refresh access token using refresh token | No |
| POST | `/auth/logout/` | Blacklist refresh token to log out | Yes |
| POST | `/auth/verify-email/` | Verify email OTP after registration | No |
| POST | `/auth/resend-otp/` | Resend email verification OTP | No |
| POST | `/auth/forgot-password/` | Request password reset OTP | No |
| POST | `/auth/reset-password/` | Set new password using OTP | No |
| GET | `/auth/profile/` | Get logged-in user's profile | Yes |
| PUT | `/auth/profile/` | Update profile details | Yes |
| POST | `/auth/change-password/` | Change password (requires current password) | Yes |
| GET | `/auth/addresses/` | List all saved addresses | Yes |
| POST | `/auth/addresses/` | Add new address | Yes |
| PUT | `/auth/addresses/{id}/` | Update existing address | Yes |
| DELETE | `/auth/addresses/{id}/` | Delete an address | Yes |
| PATCH | `/auth/addresses/{id}/set-default/` | Set address as default | Yes |

---

### 6.2 Product Endpoints

| Method | Endpoint | Description | Auth Required |
|--------|----------|-------------|--------------|
| GET | `/products/` | List all products with filters + pagination | No |
| GET | `/products/{id}/` | Single product detail with variants and images | No |
| GET | `/products/featured/` | Featured / promoted products | No |
| GET | `/products/trending/` | Trending products by views and purchases | No |
| GET | `/categories/` | Full category tree (Food + Clothing) | No |
| GET | `/categories/{slug}/` | Category detail | No |
| GET | `/categories/{slug}/products/` | Products under a specific category | No |

---

### 6.3 Food-Specific Endpoints

| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/food/products/` | Food products (filters: diet type, cuisine, calories, halal, gluten-free) |
| GET | `/food/cuisines/` | List of all available cuisines |
| GET | `/food/restaurants/` | All food vendor stores |
| GET | `/food/restaurants/{id}/` | Restaurant detail with ratings |
| GET | `/food/restaurants/{id}/menu/` | Full menu of a specific restaurant |

---

### 6.4 Clothing-Specific Endpoints

| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/clothing/products/` | Clothing products (filters: gender, size, color, brand, fabric) |
| GET | `/clothing/brands/` | All available clothing brands |
| GET | `/clothing/sizes/` | Available sizes grouped by category |
| GET | `/clothing/colors/` | Available color options |

---

### 6.5 Search Endpoints

| Method | Endpoint | Description | Auth Required |
|--------|----------|-------------|--------------|
| GET | `/search/?q=` | Full-text search across both Food and Clothing | No |
| GET | `/search/suggestions/?q=` | Real-time autocomplete suggestions | No |
| GET | `/search/history/` | User's recent search queries | Yes |
| DELETE | `/search/history/` | Clear search history | Yes |

---

### 6.6 Cart Endpoints

| Method | Endpoint | Description | Auth Required |
|--------|----------|-------------|--------------|
| GET | `/cart/` | Get cart with all items and price breakdown | Yes |
| POST | `/cart/add/` | Add a product/variant to cart | Yes |
| PUT | `/cart/items/{id}/` | Update item quantity | Yes |
| DELETE | `/cart/items/{id}/` | Remove item from cart | Yes |
| DELETE | `/cart/clear/` | Remove all items from cart | Yes |
| GET | `/cart/count/` | Get cart item count (for badge) | Yes |

---

### 6.7 Wishlist Endpoints

| Method | Endpoint | Description | Auth Required |
|--------|----------|-------------|--------------|
| GET | `/wishlist/` | Get all wishlist items | Yes |
| POST | `/wishlist/add/` | Add product to wishlist | Yes |
| DELETE | `/wishlist/{id}/` | Remove item from wishlist | Yes |
| POST | `/wishlist/{id}/move-to-cart/` | Move wishlist item into cart | Yes |
| GET | `/wishlist/check/{product_id}/` | Check if product is wishlisted | Yes |

---

### 6.8 Order Endpoints

| Method | Endpoint | Description | Auth Required |
|--------|----------|-------------|--------------|
| POST | `/orders/` | Create a new order from cart | Yes |
| GET | `/orders/` | Order history with filters (status, date range) | Yes |
| GET | `/orders/{id}/` | Full order detail with items and status history | Yes |
| POST | `/orders/{id}/cancel/` | Cancel a pending order | Yes |
| POST | `/orders/{id}/reorder/` | Add all order items back to cart | Yes |
| GET | `/orders/{id}/track/` | Live tracking timeline | Yes |
| GET | `/orders/{id}/invoice/` | Download PDF invoice | Yes |

---

### 6.9 Payment Endpoints

| Method | Endpoint | Description | Auth Required |
|--------|----------|-------------|--------------|
| POST | `/payments/initiate/` | Create Razorpay or Stripe payment order | Yes |
| POST | `/payments/verify/` | Verify payment signature after gateway completion | Yes |
| GET | `/payments/history/` | Full transaction history | Yes |
| POST | `/payments/refund/{id}/` | Request a refund | Yes |
| POST | `/payments/webhook/razorpay/` | Razorpay server-to-server webhook | No (signature verified) |
| POST | `/payments/webhook/stripe/` | Stripe server-to-server webhook | No (signature verified) |

---

### 6.10 Review Endpoints

| Method | Endpoint | Description | Auth Required |
|--------|----------|-------------|--------------|
| GET | `/products/{id}/reviews/` | All reviews for a product (with filters) | No |
| POST | `/products/{id}/reviews/` | Submit a review (verified purchase only) | Yes |
| PUT | `/reviews/{id}/` | Edit own review | Yes |
| DELETE | `/reviews/{id}/` | Delete own review | Yes |
| POST | `/reviews/{id}/helpful/` | Mark a review as helpful | Yes |
| POST | `/reviews/{id}/response/` | Vendor reply to a review | Vendor |

---

### 6.11 Recommendation Endpoints

| Method | Endpoint | Description | Auth Required |
|--------|----------|-------------|--------------|
| GET | `/recommendations/for-you/` | Personalised recommendations | Yes |
| GET | `/recommendations/trending/` | Trending products across both categories | No |
| GET | `/products/{id}/similar/` | Similar products on product detail page | No |
| GET | `/products/{id}/bought-together/` | Frequently bought together | No |
| POST | `/recommendations/track/` | Track a recommendation click event | Yes |

---

### 6.12 Notification Endpoints

| Method | Endpoint | Description | Auth Required |
|--------|----------|-------------|--------------|
| GET | `/notifications/` | All notifications with unread count | Yes |
| PATCH | `/notifications/{id}/read/` | Mark a single notification as read | Yes |
| PATCH | `/notifications/read-all/` | Mark all notifications as read | Yes |
| GET | `/notifications/preferences/` | Get notification preferences | Yes |
| PUT | `/notifications/preferences/` | Update notification preferences | Yes |
| POST | `/notifications/fcm-token/` | Register or update FCM device token | Yes |

---

### 6.13 Admin Endpoints

| Method | Endpoint | Description | Auth Required |
|--------|----------|-------------|--------------|
| GET | `/admin/dashboard/` | KPI summary — orders, revenue, users, products | Admin |
| GET | `/admin/products/` | All products with management options | Admin |
| POST | `/admin/products/` | Create new product | Admin |
| PUT | `/admin/products/{id}/` | Update product details | Admin |
| DELETE | `/admin/products/{id}/` | Delete a product | Admin |
| POST | `/admin/products/bulk-upload/` | Upload products via CSV file | Admin |
| GET | `/admin/users/` | All users with filters | Admin |
| PATCH | `/admin/users/{id}/status/` | Activate or deactivate a user | Admin |
| GET | `/admin/vendors/` | All vendors with approval status | Admin |
| POST | `/admin/vendors/{id}/approve/` | Approve a vendor | Admin |
| POST | `/admin/vendors/{id}/reject/` | Reject a vendor with reason | Admin |
| GET | `/admin/orders/` | All orders with filters | Admin |
| PATCH | `/admin/orders/{id}/status/` | Update order status | Admin |
| GET | `/admin/analytics/sales/` | Sales trend analytics | Admin |
| GET | `/admin/analytics/revenue/` | Revenue breakdown analytics | Admin |
| GET | `/admin/analytics/users/` | User growth analytics | Admin |
| GET | `/admin/analytics/products/` | Top products report | Admin |
| GET | `/admin/reports/export/` | Download full report as CSV/Excel | Admin |

---

## 7. Product Catalog System

### Dual-Category Design Approach

The system uses a **single base `Product` model** with **two separate extension models** — `FoodProduct` and `ClothingProduct`. This design ensures:

- All shared logic (cart, orders, reviews, search, recommendations) works identically for both verticals
- Category-specific fields are isolated cleanly without polluting the base product table
- APIs can return unified product responses or category-specific detail responses

### Product Status Lifecycle

| Status | Description |
|--------|-------------|
| Draft | Created by vendor, not visible to customers |
| Pending Approval | Submitted by vendor, awaiting admin review |
| Active | Live and visible to customers |
| Out of Stock | Active but stock = 0 |
| Archived | Removed from listing, retained for order history |

### Image Management via S3

- Product images are uploaded directly to AWS S3 via the backend API
- Each product can have multiple images with a sort order
- A primary image flag is maintained per product
- Images are served via CloudFront CDN for fast delivery
- Thumbnail variants are auto-generated on upload

### Bulk Product Upload (Admin/Vendor)

- CSV file upload accepted at `/admin/products/bulk-upload/`
- Server validates each row before saving
- Errors returned per row with the row number for correction
- Successful rows are saved; failing rows are reported
- Background Celery task handles large file processing

---

## 8. Cart & Wishlist Module

### Cart Behaviour

- Each logged-in user has exactly one active cart
- Cart expires and is auto-cleared after 30 days of inactivity
- Cart validates stock availability when items are added and at checkout
- Cart stores product + variant reference to ensure correct pricing
- Price at time of cart addition is stored; latest price is fetched at checkout

### Cart Price Calculation

| Component | Calculation |
|-----------|-------------|
| Subtotal | Sum of (item unit_price × quantity) for all items |
| Tax | Applied as a percentage based on product category tax rate |
| Delivery Charge | Fixed or rule-based (free above a threshold) |
| Coupon Discount | Applied as flat amount or percentage |
| Grand Total | Subtotal + Tax + Delivery Charge − Coupon Discount |

### Wishlist Behaviour

- Each user has one persistent wishlist
- Wishlist items do not expire
- "Move to Cart" transfers the item to cart with stock validation
- Wishlisted products show stock status (In Stock / Out of Stock)

---

## 9. Coupon & Checkout System

### Coupon Types

| Type | Behaviour |
|------|-----------|
| Flat Discount | Fixed amount deducted from order total |
| Percentage Discount | Percentage deducted, up to a maximum cap |
| Free Delivery | Delivery charge waived |
| Category-Specific | Applies only to Food or Clothing items |

### Coupon Validation Rules

- Coupon code is checked for existence and active status
- Expiry date is verified against current timestamp
- Minimum order amount threshold must be met
- Usage limit per coupon is enforced
- Per-user usage limit is also enforced (to prevent abuse)
- Invalid coupons return a descriptive error message

### Checkout Flow Steps (Backend)

1. Validate cart is non-empty and all items are in stock
2. Validate the selected delivery address belongs to the user
3. Apply and validate coupon (if provided)
4. Calculate final order total including tax and delivery
5. Create `Order` and `OrderItem` records with status = Pending
6. Initiate payment via Razorpay/Stripe and return payment details
7. On payment success → update order status to Confirmed
8. Send confirmation email and push notification (Celery tasks)
9. Clear the user's cart

---

## 10. Order Management

### Order State Machine

| Transition | Triggered By |
|-----------|-------------|
| Pending → Confirmed | Payment verified successfully |
| Confirmed → Processing | Admin or vendor updates status |
| Processing → Shipped | Admin or vendor marks as shipped with tracking info |
| Shipped → Out for Delivery | Delivery partner update |
| Out for Delivery → Delivered | Delivery confirmation |
| Any → Cancelled | Customer cancels (within cancellation window) or admin cancels |
| Delivered → Refunded | Refund approved by admin |

### Cancellation Policy (Backend Rules)

- Orders can be cancelled by customer only before status = Shipped
- Orders cancelled before payment confirmation do not create a payment record
- Cancelled paid orders auto-trigger refund flow
- Admin can cancel any order at any status with a reason note

### Order Tracking Data

Each tracking update stores: status, timestamp, location (if available), note, and who made the update (vendor/admin/system). The tracking timeline API returns all status history entries for a given order.

---

## 11. Payment Integration

### Razorpay Flow (India)

| Step | Action |
|------|--------|
| 1 | Client calls `/payments/initiate/` with order ID |
| 2 | Backend creates Razorpay order and returns `razorpay_order_id` and `key_id` |
| 3 | Client opens Razorpay payment sheet using returned details |
| 4 | User completes payment on the Razorpay sheet |
| 5 | Client receives `payment_id` and `signature` from Razorpay |
| 6 | Client calls `/payments/verify/` with all three IDs |
| 7 | Backend verifies HMAC signature to confirm authenticity |
| 8 | On success: order status updated, notification sent, cart cleared |

### Razorpay Webhook Events Handled

| Event | Action |
|-------|--------|
| payment.captured | Mark order as Confirmed |
| payment.failed | Notify user of failure, keep order as Pending |
| refund.processed | Update refund record to Processed |

### Stripe Flow (International)

| Step | Action |
|------|--------|
| 1 | Client calls `/payments/initiate/` |
| 2 | Backend creates Stripe PaymentIntent and returns `client_secret` |
| 3 | Client uses `client_secret` to confirm payment via Stripe SDK |
| 4 | Client calls `/payments/verify/` to notify backend of completion |
| 5 | Backend fetches PaymentIntent status directly from Stripe to confirm |

### Refund Rules

- Refund requests accepted within 7 days of delivery
- Full or partial refunds supported
- Refund is processed via the same gateway used for payment
- Refund status is tracked as: Requested → Processing → Processed → Failed

---

## 12. Reviews & Ratings

### Review Eligibility Rules

- Only users with a verified delivered order for the product can leave a review
- One review per user per product
- Review goes to moderation queue if flagged
- Admin can approve, reject, or hide reviews

### Rating Aggregation

- `rating_avg` on the Product model is recalculated on every new review submission
- `rating_count` is incremented on every approved review
- Rating breakdown (1★ to 5★ count) is returned via the reviews API
- Recalculation is handled by a database trigger or Celery task

---

## 13. AI Recommendations

### Data Inputs

| Signal | Weight | Description |
|--------|--------|-------------|
| Product views | Medium | Products a user has viewed |
| Wishlist additions | High | Products a user has saved |
| Purchase history | Highest | Products a user has bought |
| Review activity | Medium | Products a user has reviewed |
| Category preference | Medium | Which category user spends more time in |

### Recommendation Types

| Type | Description | Where Used |
|------|-------------|-----------|
| Personalised For You | Based on user's individual history | Home screen |
| You May Also Like | Similar products to what user is viewing | Product detail page |
| Trending Now | High view + purchase velocity in last 7 days | Home screen + category pages |
| Frequently Bought Together | Items commonly ordered together | Product detail + cart page |
| New Arrivals | Recently added products in user's preferred category | Home screen |

### Generation Process

- A Celery scheduled task runs nightly to regenerate recommendations for all active users
- Results are pre-stored in `ProductRecommendation` table with a relevance score
- The API reads from these pre-computed results for fast response
- Redis caches recommendation results per user for 1 hour

---

## 14. Push Notifications

### Notification Types

| Type | Trigger | Channel |
|------|---------|---------|
| Order Confirmed | Payment verified | Push + Email |
| Order Shipped | Status updated to Shipped | Push + Email |
| Out for Delivery | Status updated to Out for Delivery | Push |
| Order Delivered | Status updated to Delivered | Push + Email |
| Order Cancelled | Order cancelled by customer or admin | Push + Email |
| Refund Processed | Refund completed | Push + Email |
| Promo / Offer | Admin-triggered campaign | Push |
| New Arrival | Products added in user's preferred category | Push |
| Wishlist Back in Stock | Out-of-stock wishlist item is restocked | Push |

### FCM Token Management

- Device FCM token is sent to backend on every app launch (PATCH to `/notifications/fcm-token/`)
- Token is stored per user and updated when refreshed by Firebase
- Stale tokens (30+ days without refresh) are removed automatically

### Notification Delivery Architecture

1. Order status changes in backend
2. Signal or service triggers Celery task
3. Celery task reads user's FCM token from database
4. Firebase Admin SDK sends push to device
5. Notification stored in `Notification` table for in-app history
6. If email is enabled in preferences, email is sent via AWS SES

---

## 15. Admin & Vendor Dashboard

### Admin Dashboard KPIs

| Metric | Description |
|--------|-------------|
| Total Orders Today | Orders placed in current calendar day |
| Revenue Today | Gross revenue for current day |
| New Users Today | User registrations in current day |
| Pending Vendor Approvals | Count of vendors awaiting approval |
| Low Inventory Alerts | Products with stock below threshold |
| Order Status Breakdown | Pie chart data: Pending, Confirmed, Shipped, Delivered, Cancelled |
| Revenue Trend | Last 30 days daily revenue chart data |
| Top 10 Products | Best-selling products by revenue |
| Category Split | Food vs Clothing revenue percentage |

### Vendor Dashboard KPIs

| Metric | Description |
|--------|-------------|
| Total Products | Count of vendor's active and draft products |
| Orders To Fulfil | Confirmed orders pending the vendor's action |
| Revenue This Month | Vendor's gross revenue in the current month |
| Average Rating | Vendor's overall average product rating |
| Low Stock Alerts | Vendor's products with stock below 10 units |

### Vendor Approval Workflow

1. Vendor submits registration with business details
2. Status set to `Pending Approval`
3. Admin reviews vendor profile in dashboard
4. Admin approves → vendor receives email + can now list products
5. Admin rejects → vendor receives rejection email with reason
6. Approved vendors' products also go through product approval before going live

---

## 16. Search & Filtering

### Search Implementation

- Uses **PostgreSQL Full-Text Search** with `tsvector` and `tsquery`
- Search vector is computed from: product name (weight A), description (weight B), category name (weight C)
- Results are ranked by relevance score
- Search also includes partial match via trigram similarity for typo tolerance

### Available Filters

**Common Filters (Both Categories)**

| Filter | Type | Description |
|--------|------|-------------|
| min_price | Number | Minimum price filter |
| max_price | Number | Maximum price filter |
| min_rating | Number | Minimum average rating |
| category | String (slug) | Filter by category slug |
| in_stock | Boolean | Show only in-stock items |
| sort_by | Enum | price_asc, price_desc, rating, newest, popular |

**Food-Specific Filters**

| Filter | Description |
|--------|-------------|
| diet_type | Veg, Non-Veg, Vegan |
| cuisine | Indian, Chinese, Italian, etc. |
| max_calories | Maximum calories per serving |
| is_halal | Halal certified only |
| is_gluten_free | Gluten-free only |
| max_prep_time | Maximum prep time in minutes |

**Clothing-Specific Filters**

| Filter | Description |
|--------|-------------|
| gender | Men, Women, Unisex, Kids |
| brand | Filter by brand name |
| size | XS, S, M, L, XL, XXL or numeric sizes |
| color | Filter by colour name |
| fabric | Cotton, Polyester, Linen, etc. |
| fit | Slim, Regular, Oversized |

---

## 17. Caching Strategy

| Data Type | Cache Key Pattern | TTL | Invalidation Trigger |
|-----------|------------------|-----|---------------------|
| Product detail | `product:{id}` | 15 minutes | Product update |
| Product list page | `product_list:{params_hash}` | 5 minutes | Any product update |
| Category tree | `category_tree` | 1 hour | Category update |
| Trending products | `trending:{category}` | 30 minutes | Scheduled refresh |
| User cart count | `cart_count:{user_id}` | 10 minutes | Cart add/remove |
| Recommendations | `reco:{user_id}` | 1 hour | Nightly recalculation |
| Search suggestions | `search_suggest:{query}` | 1 hour | Product update |
| Dashboard metrics | `admin_dashboard` | 5 minutes | Scheduled refresh |

---

## 18. Background Tasks — Celery

| Task Name | Trigger | Description |
|-----------|---------|-------------|
| `send_verification_email` | User registration | Sends OTP email to new users |
| `send_order_notification` | Order status change | Sends push + email notification |
| `send_promo_notification` | Admin trigger | Sends bulk promotional push |
| `generate_recommendations` | Nightly schedule (2 AM) | Rebuilds recommendation table for all users |
| `send_back_in_stock_alerts` | Stock update | Notifies users with wishlisted item now in stock |
| `generate_daily_report` | Daily schedule (6 AM) | Compiles and emails daily KPI report to admin |
| `cleanup_expired_carts` | Daily schedule | Removes carts older than 30 days |
| `cleanup_expired_otps` | Hourly schedule | Removes expired OTP entries from Redis |
| `process_bulk_upload` | File upload trigger | Processes large CSV product upload in background |
| `generate_invoice_pdf` | Order completion | Generates downloadable invoice PDF |

---

## 19. Security Implementation

### API Security Measures

| Measure | Implementation |
|---------|----------------|
| Rate Limiting | Anonymous: 100 requests/hour, Authenticated: 1000 requests/hour, Login: 10 requests/minute |
| HTTPS | SSL/TLS via Let's Encrypt, enforced via Nginx redirect |
| CORS | Restricted to known frontend origins only |
| Input Validation | All inputs validated by DRF serializers before processing |
| SQL Injection Prevention | Django ORM used exclusively — no raw SQL queries |
| XSS Protection | DRF serializers escape all output by default |
| CSRF Protection | Enabled for web admin panel, not applicable for JWT API |
| Security Headers | X-Content-Type-Options, X-Frame-Options, Strict-Transport-Security |
| DDoS Protection | Cloudflare WAF and rate limiting at DNS level |
| Webhook Signature Verification | HMAC-SHA256 signature verified for Razorpay and Stripe webhooks |
| Audit Logging | All admin and vendor actions logged with user ID, timestamp, and action |

### Payment Security

- Payment amount is always re-calculated server-side before creating the gateway order
- Client-supplied amounts are ignored entirely
- Payment signature verification is mandatory before order status update
- PCI-DSS compliance maintained by delegating card data to gateway SDKs

---

## 20. DevOps & Deployment

### Infrastructure Components

| Component | Technology | Hosting |
|-----------|-----------|---------|
| Application Server | Gunicorn (4 workers) | AWS EC2 / DigitalOcean Droplet |
| Reverse Proxy | Nginx | Same server as app |
| Primary Database | PostgreSQL 15 | AWS RDS (managed) |
| Cache + Broker | Redis 7 | AWS ElastiCache (managed) |
| File Storage | AWS S3 + CloudFront CDN | AWS |
| Container Orchestration | Docker + Docker Compose | AWS EC2 |
| CI/CD Pipeline | GitHub Actions | GitHub |
| Error Monitoring | Sentry | Cloud (SaaS) |
| Performance Monitoring | New Relic | Cloud (SaaS) |
| Log Management | AWS CloudWatch | AWS |

### CI/CD Pipeline Steps

1. Developer pushes code to `main` branch
2. GitHub Actions triggers automated test run
3. If tests pass, Docker image is built
4. Image is pushed to AWS ECR (container registry)
5. GitHub Actions SSHs into production server
6. New Docker image is pulled and containers are restarted (zero downtime)
7. Database migrations are applied automatically
8. Smoke test is run to verify deployment success

### Backup Strategy

| Data | Backup Frequency | Retention | Method |
|------|-----------------|-----------|--------|
| PostgreSQL | Daily automated snapshot | 30 days | AWS RDS automated backups |
| S3 Files | Continuous versioning | 90 days | S3 versioning enabled |
| Redis | Not backed up | — | Ephemeral cache data only |
| Application Logs | Shipped to CloudWatch | 90 days | CloudWatch log streams |

---

## 21. Testing Strategy

### Backend Test Types

| Test Type | Tool | Target Coverage |
|-----------|------|----------------|
| Unit Tests | pytest + pytest-django | All model methods and service functions |
| API Tests | pytest + DRF test client | All API endpoints — happy path and error cases |
| Integration Tests | pytest | Multi-step flows — registration, checkout, payment |
| Load Tests | Apache JMeter | Sustained load at 100 concurrent users |
| Security Tests | OWASP ZAP | Common vulnerability scanning |
| Webhook Tests | Simulated webhook payloads | All Razorpay and Stripe webhook events |

### Coverage Targets

| Module | Target Coverage |
|--------|----------------|
| User Auth | 95% |
| Product Catalog | 90% |
| Cart & Orders | 95% |
| Payments | 90% |
| Notifications | 80% |
| Recommendations | 80% |
| Admin APIs | 85% |
| **Overall Target** | **≥ 85%** |

---

## 22. Performance Targets

| Metric | Target |
|--------|--------|
| API response time (p95) | < 200 ms |
| Search response time | < 500 ms |
| Payment initiation | < 1 second |
| Database queries per request | < 10 queries |
| Cache hit rate | > 80% |
| Celery task processing time | < 30 seconds per task |
| Daily active user capacity | 50,000+ |
| Concurrent requests supported | 500+ |
| Uptime SLA | 99.9% |

---

## 23. Phase-wise Roadmap

| Phase | Weeks | Backend Tasks |
|-------|-------|---------------|
| Phase 1 — Foundation | 1–2 | Django setup, PostgreSQL, JWT auth, User model, API versioning, Redis, email verification |
| Phase 2 — Products | 3–4 | Category model, Product model, FoodProduct, ClothingProduct, ProductVariant, S3 integration, filtering, full-text search |
| Phase 3 — Cart & Wishlist | 5 | Cart model, CartItem, stock validation, cart expiry, Wishlist, move-to-cart API |
| Phase 4 — Checkout | 6–7 | Address model, Coupon model, Order model, OrderItem, order creation flow, invoice generation, order email notifications |
| Phase 5 — Payments | 7–8 | Razorpay integration, Stripe integration, Payment model, webhook handler, refund logic, transaction logging |
| Phase 6 — Order Tracking | 8–9 | Order state machine, tracking API, vendor assignment, order analytics, cancellation and reorder |
| Phase 7 — Reviews | 9 | Review model, review moderation, rating aggregation, review image upload, helpful votes |
| Phase 8 — Recommendations | 10 | BrowsingHistory model, collaborative filtering algorithm, trending algorithm, Celery recommendation task, caching |
| Phase 9 — Notifications | 10–11 | FCM setup, Notification model, token management, push triggers, email notifications, notification preferences |
| Phase 10 — Admin Dashboard | 11–13 | Analytics APIs, vendor management, bulk upload, inventory endpoints, sales reports, user management |
| Phase 11 — Search & Performance | 13–14 | PostgreSQL full-text search tuning, Redis caching strategy, API response compression, database indexing, CDN setup |
| Phase 12 — Security | 14 | Rate limiting, security headers, audit logging, DDoS protection, input validation hardening |
| Phase 13 — Testing & QA | 15 | Unit tests, API tests, integration tests, load tests, coverage reports |
| Phase 14 — Deployment | 15–16 | Docker containers, Docker Compose, Gunicorn + Nginx, AWS RDS, ElastiCache, CI/CD pipeline, Sentry, monitoring |
| Phase 15 — Post Launch | 16+ | Performance monitoring, bug fixes, feature iterations, scaling |

---

*Backend Guide Version 1.0.0 | Last Updated: February 2026 | Status: Production Ready*
