# Database Schema Design
## PostgreSQL Database Architecture

---

## 🗂️ Database Design Principles

### **Core Principles**
1. **Normalization**: 3NF compliance for data integrity
2. **Polymorphic Design**: Support for multiple product types
3. **Soft Deletes**: Data retention for compliance
4. **Audit Fields**: Track all changes
5. **Indexing Strategy**: Optimized for common queries
6. **UUID Primary Keys**: Better for distributed systems
7. **JSONB Fields**: Flexible data storage where needed

---

## 📊 Entity Relationship Overview

```
┌─────────────┐
│    User     │──────┐
└─────────────┘      │
       │             │
       │ 1        M  ▼
       │      ┌──────────┐
       │      │ Address  │
       │      └──────────┘
       │
       │ 1        M
       ▼      ┌──────────┐      M      ┌──────────┐
  ┌──────┐────│CartItem  │─────────────│ Product  │
  │ Cart │    └──────────┘             └──────────┘
  └──────┘                                    │
                                              │ 1
       │ 1        M                           │
       ▼      ┌──────────┐                    │
  ┌─────────┐│WishlistI │                    │
  │Wishlist ││   tem    │                    │
  └─────────┘└──────────┘                    │
                                              │
       │ 1        M      1      M            ▼
       ▼      ┌────────┐───────┌──────────────────┐
  ┌───────┐──│OrderItem│       │ ProductVariant   │
  │ Order │  └────────┘        └──────────────────┘
  └───────┘       │
       │          │ M      1   ┌────────────┐
       │          └────────────│ Category   │
       │ 1        M            └────────────┘
       ▼      ┌────────┐
  ┌────────────┐       │       ┌────────────┐
  │OrderStatus │       └───────│   Brand    │
  │  History   │               └────────────┘
  └────────────┘

       │ 1        M
       ▼      ┌────────┐
  ┌────────────┐
  │   Review   │
  └────────────┘

       │ 1        M
       ▼      ┌──────────────┐
  ┌─────────────────┐
  │  Notification   │
  └─────────────────┘
```

---

## 1️⃣ User Management Schema

### **users.User**
```sql
CREATE TABLE users (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    email VARCHAR(255) UNIQUE NOT NULL,
    username VARCHAR(150) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    phone VARCHAR(15) UNIQUE,
    
    -- Profile
    first_name VARCHAR(150) NOT NULL,
    last_name VARCHAR(150) NOT NULL,
    profile_image TEXT,
    date_of_birth DATE,
    
    -- Role & Status
    role VARCHAR(20) NOT NULL DEFAULT 'CUSTOMER',
        -- VALUES: 'CUSTOMER', 'VENDOR', 'ADMIN'
    is_active BOOLEAN DEFAULT true,
    is_staff BOOLEAN DEFAULT false,
    is_verified BOOLEAN DEFAULT false,
    
    -- Preferences
    fcm_token VARCHAR(255),
    notification_enabled BOOLEAN DEFAULT true,
    email_notification_enabled BOOLEAN DEFAULT true,
    
    -- Audit
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    last_login TIMESTAMP,
    
    CONSTRAINT chk_role CHECK (role IN ('CUSTOMER', 'VENDOR', 'ADMIN'))
);

-- Indexes
CREATE INDEX idx_users_email ON users(email);
CREATE INDEX idx_users_username ON users(username);
CREATE INDEX idx_users_role_active ON users(role, is_active);
CREATE INDEX idx_users_phone ON users(phone) WHERE phone IS NOT NULL;
```

**Purpose**: Core user authentication and profile management

**Fields Explanation**:
- `role`: Defines user access level (Customer, Vendor, Admin)
- `fcm_token`: Firebase token for push notifications
- `is_verified`: Email verification status
- `notification_enabled`: User preference for notifications

---

### **users.Address**
```sql
CREATE TABLE addresses (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    
    -- Address Type
    address_type VARCHAR(20) NOT NULL,
        -- VALUES: 'HOME', 'WORK', 'OTHER'
    
    -- Contact Details
    full_name VARCHAR(255) NOT NULL,
    phone VARCHAR(15) NOT NULL,
    
    -- Address Components
    address_line1 VARCHAR(255) NOT NULL,
    address_line2 VARCHAR(255),
    city VARCHAR(100) NOT NULL,
    state VARCHAR(100) NOT NULL,
    country VARCHAR(100) DEFAULT 'India',
    postal_code VARCHAR(10) NOT NULL,
    
    -- Geolocation
    latitude DECIMAL(9,6),
    longitude DECIMAL(9,6),
    
    -- Flags
    is_default BOOLEAN DEFAULT false,
    is_active BOOLEAN DEFAULT true,
    
    -- Audit
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    CONSTRAINT chk_address_type CHECK (address_type IN ('HOME', 'WORK', 'OTHER'))
);

-- Indexes
CREATE INDEX idx_addresses_user ON addresses(user_id);
CREATE INDEX idx_addresses_user_default ON addresses(user_id, is_default);
CREATE INDEX idx_addresses_postal_code ON addresses(postal_code);
```

**Purpose**: Store multiple delivery addresses per user

**Key Features**:
- Support for multiple addresses
- Default address selection
- Geolocation for delivery optimization
- Soft delete with `is_active`

---

## 2️⃣ Product Catalog Schema

### **products.Category**
```sql
CREATE TABLE categories (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name VARCHAR(100) NOT NULL,
    slug VARCHAR(100) UNIQUE NOT NULL,
    
    -- Category Type
    category_type VARCHAR(20) NOT NULL,
        -- VALUES: 'FOOD', 'CLOTHING'
    
    -- Hierarchy (Self-referencing)
    parent_id UUID REFERENCES categories(id) ON DELETE CASCADE,
    
    -- Media
    image TEXT,
    icon TEXT,
    
    -- Display
    description TEXT,
    display_order INTEGER DEFAULT 0,
    is_active BOOLEAN DEFAULT true,
    
    -- Audit
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    CONSTRAINT chk_category_type CHECK (category_type IN ('FOOD', 'CLOTHING'))
);

-- Indexes
CREATE INDEX idx_categories_slug ON categories(slug);
CREATE INDEX idx_categories_type_active ON categories(category_type, is_active);
CREATE INDEX idx_categories_parent ON categories(parent_id) WHERE parent_id IS NOT NULL;
CREATE INDEX idx_categories_display_order ON categories(display_order);
```

**Purpose**: Hierarchical category structure for both Food & Clothing

**Hierarchy Example**:
```
Food (parent)
├── Veg (child)
├── Non-Veg (child)
├── Snacks (child)
└── Beverages (child)

Clothing (parent)
├── Men (child)
│   ├── T-Shirts (grandchild)
│   └── Jeans (grandchild)
├── Women (child)
└── Kids (child)
```

---

### **products.Brand**
```sql
CREATE TABLE brands (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name VARCHAR(100) UNIQUE NOT NULL,
    slug VARCHAR(100) UNIQUE NOT NULL,
    logo TEXT,
    description TEXT,
    is_active BOOLEAN DEFAULT true,
    
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_brands_slug ON brands(slug);
CREATE INDEX idx_brands_active ON brands(is_active);
```

**Purpose**: Product brands (primarily for clothing)

---

### **products.Product** (Base Table)
```sql
CREATE TABLE products (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    
    -- Basic Info
    name VARCHAR(255) NOT NULL,
    slug VARCHAR(255) UNIQUE NOT NULL,
    sku VARCHAR(100) UNIQUE NOT NULL,
    product_type VARCHAR(20) NOT NULL,
        -- VALUES: 'FOOD', 'CLOTHING'
    
    -- Relations
    category_id UUID NOT NULL REFERENCES categories(id) ON DELETE PROTECT,
    brand_id UUID REFERENCES brands(id) ON DELETE SET NULL,
    vendor_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    
    -- Description
    description TEXT NOT NULL,
    short_description VARCHAR(500),
    
    -- Pricing
    price DECIMAL(10,2) NOT NULL,
    compare_at_price DECIMAL(10,2),  -- Original price (for discount display)
    cost_price DECIMAL(10,2),  -- For vendor analytics
    discount_percentage DECIMAL(5,2) DEFAULT 0,
    
    -- Inventory
    stock_quantity INTEGER DEFAULT 0,
    low_stock_threshold INTEGER DEFAULT 10,
    track_inventory BOOLEAN DEFAULT true,
    
    -- Media
    thumbnail TEXT NOT NULL,
    
    -- SEO
    meta_title VARCHAR(255),
    meta_description TEXT,
    
    -- Ratings
    average_rating DECIMAL(3,2) DEFAULT 0.0,
    total_reviews INTEGER DEFAULT 0,
    
    -- Stats
    view_count INTEGER DEFAULT 0,
    order_count INTEGER DEFAULT 0,
    
    -- Flags
    is_active BOOLEAN DEFAULT true,
    is_featured BOOLEAN DEFAULT false,
    is_available BOOLEAN DEFAULT true,
    
    -- Audit
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    CONSTRAINT chk_product_type CHECK (product_type IN ('FOOD', 'CLOTHING')),
    CONSTRAINT chk_price_positive CHECK (price >= 0),
    CONSTRAINT chk_rating_range CHECK (average_rating >= 0 AND average_rating <= 5)
);

-- Indexes (Critical for Performance)
CREATE INDEX idx_products_slug ON products(slug);
CREATE INDEX idx_products_sku ON products(sku);
CREATE INDEX idx_products_type_active ON products(product_type, is_active);
CREATE INDEX idx_products_category ON products(category_id);
CREATE INDEX idx_products_vendor ON products(vendor_id);
CREATE INDEX idx_products_created_desc ON products(created_at DESC);
CREATE INDEX idx_products_rating_desc ON products(average_rating DESC);
CREATE INDEX idx_products_price ON products(price);
CREATE INDEX idx_products_featured ON products(is_featured) WHERE is_featured = true;
```

**Purpose**: Base product table for both Food & Clothing

**Key Fields**:
- `product_type`: Distinguishes between Food and Clothing
- `compare_at_price`: Shows original price for discount display
- `track_inventory`: Some food items might not track inventory
- `is_featured`: For homepage featured products

---

### **products.FoodProduct**
```sql
CREATE TABLE food_products (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    product_id UUID UNIQUE NOT NULL REFERENCES products(id) ON DELETE CASCADE,
    
    -- Food Type
    food_type VARCHAR(20) NOT NULL,
        -- VALUES: 'VEG', 'NON_VEG', 'VEGAN', 'EGG'
    cuisine_type VARCHAR(100),  -- Indian, Chinese, Italian, etc.
    spice_level INTEGER DEFAULT 0,  -- 0-5 scale
    
    -- Nutritional Info
    calories INTEGER,
    protein DECIMAL(5,2),  -- in grams
    carbs DECIMAL(5,2),    -- in grams
    fat DECIMAL(5,2),      -- in grams
    
    -- Serving
    serving_size VARCHAR(100),  -- "1 plate", "500ml", etc.
    preparation_time INTEGER,   -- minutes
    
    -- Allergen Info (Boolean flags)
    contains_gluten BOOLEAN DEFAULT false,
    contains_dairy BOOLEAN DEFAULT false,
    contains_nuts BOOLEAN DEFAULT false,
    
    -- Packaging
    packaging_type VARCHAR(100),
    is_perishable BOOLEAN DEFAULT true,
    expiry_days INTEGER,  -- Days until expiry
    
    CONSTRAINT chk_food_type CHECK (food_type IN ('VEG', 'NON_VEG', 'VEGAN', 'EGG')),
    CONSTRAINT chk_spice_level CHECK (spice_level >= 0 AND spice_level <= 5)
);

CREATE INDEX idx_food_products_product ON food_products(product_id);
CREATE INDEX idx_food_products_food_type ON food_products(food_type);
CREATE INDEX idx_food_products_cuisine ON food_products(cuisine_type);
```

**Purpose**: Food-specific attributes

**Use Cases**:
- Veg/Non-veg filtering
- Nutritional information display
- Allergen warnings
- Cuisine-based search

---

### **products.ClothingProduct**
```sql
CREATE TABLE clothing_products (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    product_id UUID UNIQUE NOT NULL REFERENCES products(id) ON DELETE CASCADE,
    
    -- Clothing Specific
    gender VARCHAR(20) NOT NULL,
        -- VALUES: 'MEN', 'WOMEN', 'KIDS', 'UNISEX'
    clothing_type VARCHAR(20) NOT NULL,
        -- VALUES: 'TOPWEAR', 'BOTTOMWEAR', 'FOOTWEAR', 'ACCESSORIES'
    
    -- Material
    material VARCHAR(100) NOT NULL,  -- "100% Cotton", "Polyester Blend"
    fabric VARCHAR(100),             -- "Denim", "Silk", etc.
    care_instructions TEXT,
    
    -- Fit & Style
    fit_type VARCHAR(50),   -- Slim, Regular, Loose
    pattern VARCHAR(50),    -- Solid, Striped, Printed
    
    -- Dimensions
    length DECIMAL(5,2),    -- in cm
    width DECIMAL(5,2),     -- in cm
    
    -- Season
    season VARCHAR(50),     -- Summer, Winter, All Season
    
    CONSTRAINT chk_gender CHECK (gender IN ('MEN', 'WOMEN', 'KIDS', 'UNISEX')),
    CONSTRAINT chk_clothing_type CHECK (clothing_type IN ('TOPWEAR', 'BOTTOMWEAR', 'FOOTWEAR', 'ACCESSORIES'))
);

CREATE INDEX idx_clothing_products_product ON clothing_products(product_id);
CREATE INDEX idx_clothing_products_gender ON clothing_products(gender);
CREATE INDEX idx_clothing_products_type ON clothing_products(clothing_type);
CREATE INDEX idx_clothing_products_material ON clothing_products(material);
```

**Purpose**: Clothing-specific attributes

**Use Cases**:
- Gender-based filtering
- Material-based search
- Size chart information
- Care instructions display

---

### **products.ProductVariant**
```sql
CREATE TABLE product_variants (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    product_id UUID NOT NULL REFERENCES products(id) ON DELETE CASCADE,
    
    -- Variant Details
    sku VARCHAR(100) UNIQUE NOT NULL,
    size VARCHAR(20),      -- S, M, L, XL, 32, 34, etc.
    color VARCHAR(50),     -- Red, Blue, Black, etc.
    color_hex VARCHAR(7),  -- #FF0000, #0000FF
    
    -- Pricing (if different from base product)
    price DECIMAL(10,2),
    
    -- Inventory
    stock_quantity INTEGER DEFAULT 0,
    
    -- Media
    image_url TEXT,  -- Variant-specific image
    
    -- Flags
    is_active BOOLEAN DEFAULT true,
    
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    CONSTRAINT uq_variant UNIQUE (product_id, size, color)
);

-- Indexes
CREATE INDEX idx_variants_product ON product_variants(product_id);
CREATE INDEX idx_variants_sku ON product_variants(sku);
CREATE INDEX idx_variants_active ON product_variants(product_id, is_active);
```

**Purpose**: Product variations (size/color combinations)

**Example**:
```
Product: "Cotton T-Shirt"
Variants:
  - SKU: TSH-001-RED-M, Size: M, Color: Red, Stock: 25
  - SKU: TSH-001-RED-L, Size: L, Color: Red, Stock: 30
  - SKU: TSH-001-BLU-M, Size: M, Color: Blue, Stock: 15
```

---

### **products.ProductImage**
```sql
CREATE TABLE product_images (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    product_id UUID NOT NULL REFERENCES products(id) ON DELETE CASCADE,
    
    image_url TEXT NOT NULL,  -- S3 URL
    alt_text VARCHAR(255),
    display_order INTEGER DEFAULT 0,
    is_primary BOOLEAN DEFAULT false,
    
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    CONSTRAINT uq_primary_image UNIQUE (product_id, is_primary) WHERE is_primary = true
);

CREATE INDEX idx_product_images_product ON product_images(product_id);
CREATE INDEX idx_product_images_order ON product_images(product_id, display_order);
```

**Purpose**: Multiple images per product

---

## 3️⃣ Shopping Cart Schema

### **cart.Cart**
```sql
CREATE TABLE carts (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID UNIQUE NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    
    -- Session support for guest users (future feature)
    session_key VARCHAR(255) UNIQUE,
    
    -- Totals (cached for performance)
    subtotal DECIMAL(10,2) DEFAULT 0,
    tax DECIMAL(10,2) DEFAULT 0,
    discount DECIMAL(10,2) DEFAULT 0,
    total DECIMAL(10,2) DEFAULT 0,
    
    -- Applied Coupon
    coupon_id UUID REFERENCES coupons(id) ON DELETE SET NULL,
    
    -- Audit
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    expires_at TIMESTAMP  -- Cart expiry (30 days)
);

CREATE INDEX idx_carts_user ON carts(user_id);
CREATE INDEX idx_carts_session ON carts(session_key) WHERE session_key IS NOT NULL;
```

**Purpose**: User shopping cart

---

### **cart.CartItem**
```sql
CREATE TABLE cart_items (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    cart_id UUID NOT NULL REFERENCES carts(id) ON DELETE CASCADE,
    product_id UUID NOT NULL REFERENCES products(id) ON DELETE CASCADE,
    variant_id UUID REFERENCES product_variants(id) ON DELETE CASCADE,
    
    -- Quantity
    quantity INTEGER NOT NULL DEFAULT 1,
    
    -- Pricing (snapshot at time of adding)
    unit_price DECIMAL(10,2) NOT NULL,
    total_price DECIMAL(10,2) NOT NULL,
    
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    CONSTRAINT chk_quantity_positive CHECK (quantity > 0),
    CONSTRAINT uq_cart_product_variant UNIQUE (cart_id, product_id, variant_id)
);

CREATE INDEX idx_cart_items_cart ON cart_items(cart_id);
CREATE INDEX idx_cart_items_product ON cart_items(product_id);
```

**Purpose**: Items in shopping cart

---

## 4️⃣ Wishlist Schema

### **wishlist.Wishlist**
```sql
CREATE TABLE wishlists (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID UNIQUE NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_wishlists_user ON wishlists(user_id);
```

### **wishlist.WishlistItem**
```sql
CREATE TABLE wishlist_items (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    wishlist_id UUID NOT NULL REFERENCES wishlists(id) ON DELETE CASCADE,
    product_id UUID NOT NULL REFERENCES products(id) ON DELETE CASCADE,
    
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    CONSTRAINT uq_wishlist_product UNIQUE (wishlist_id, product_id)
);

CREATE INDEX idx_wishlist_items_wishlist ON wishlist_items(wishlist_id);
CREATE INDEX idx_wishlist_items_product ON wishlist_items(product_id);
```

**Purpose**: User wishlist/favorites

---

## 5️⃣ Order Management Schema

### **orders.Order**
```sql
CREATE TABLE orders (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    order_number VARCHAR(20) UNIQUE NOT NULL,  -- ORD-2024-001234
    
    -- Relations
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE PROTECT,
    
    -- Delivery Address (JSON snapshot - address might be deleted later)
    shipping_address JSONB NOT NULL,
    billing_address JSONB,
    
    -- Status
    status VARCHAR(20) NOT NULL DEFAULT 'PENDING',
        -- VALUES: 'PENDING', 'CONFIRMED', 'PROCESSING', 'SHIPPED', 
        --         'OUT_FOR_DELIVERY', 'DELIVERED', 'CANCELLED', 'REFUNDED'
    payment_status VARCHAR(20) NOT NULL DEFAULT 'PENDING',
        -- VALUES: 'PENDING', 'PAID', 'FAILED', 'REFUNDED'
    
    -- Pricing
    subtotal DECIMAL(10,2) NOT NULL,
    tax DECIMAL(10,2) DEFAULT 0,
    shipping_cost DECIMAL(10,2) DEFAULT 0,
    discount DECIMAL(10,2) DEFAULT 0,
    total DECIMAL(10,2) NOT NULL,
    
    -- Payment
    payment_method VARCHAR(50) NOT NULL,  -- razorpay, stripe, cod
    payment_id VARCHAR(255),              -- Gateway payment ID
    transaction_id VARCHAR(255),          -- Transaction reference
    
    -- Delivery
    tracking_number VARCHAR(100),
    estimated_delivery TIMESTAMP,
    delivered_at TIMESTAMP,
    
    -- Notes
    customer_note TEXT,
    admin_note TEXT,
    
    -- Coupon
    coupon_id UUID REFERENCES coupons(id) ON DELETE SET NULL,
    
    -- Audit
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    CONSTRAINT chk_order_status CHECK (status IN ('PENDING', 'CONFIRMED', 'PROCESSING', 'SHIPPED', 'OUT_FOR_DELIVERY', 'DELIVERED', 'CANCELLED', 'REFUNDED')),
    CONSTRAINT chk_payment_status CHECK (payment_status IN ('PENDING', 'PAID', 'FAILED', 'REFUNDED')),
    CONSTRAINT chk_total_positive CHECK (total >= 0)
);

-- Indexes (Critical for order queries)
CREATE INDEX idx_orders_number ON orders(order_number);
CREATE INDEX idx_orders_user_created ON orders(user_id, created_at DESC);
CREATE INDEX idx_orders_status_payment ON orders(status, payment_status);
CREATE INDEX idx_orders_created_desc ON orders(created_at DESC);
CREATE INDEX idx_orders_transaction ON orders(transaction_id) WHERE transaction_id IS NOT NULL;
```

**Purpose**: Customer orders

**Status Flow**:
```
PENDING → CONFIRMED → PROCESSING → SHIPPED → OUT_FOR_DELIVERY → DELIVERED
                                     ↓
                                 CANCELLED
```

---

### **orders.OrderItem**
```sql
CREATE TABLE order_items (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    order_id UUID NOT NULL REFERENCES orders(id) ON DELETE CASCADE,
    product_id UUID NOT NULL REFERENCES products(id) ON DELETE PROTECT,
    variant_id UUID REFERENCES product_variants(id) ON DELETE PROTECT,
    
    -- Snapshot data (product might change later)
    product_name VARCHAR(255) NOT NULL,
    product_image TEXT NOT NULL,
    sku VARCHAR(100) NOT NULL,
    
    -- Variant details (if applicable)
    variant_size VARCHAR(20),
    variant_color VARCHAR(50),
    
    -- Pricing
    quantity INTEGER NOT NULL,
    unit_price DECIMAL(10,2) NOT NULL,
    total_price DECIMAL(10,2) NOT NULL,
    discount DECIMAL(10,2) DEFAULT 0,
    
    -- Vendor
    vendor_id UUID NOT NULL REFERENCES users(id) ON DELETE PROTECT,
    
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    CONSTRAINT chk_quantity_positive CHECK (quantity > 0)
);

CREATE INDEX idx_order_items_order ON order_items(order_id);
CREATE INDEX idx_order_items_product ON order_items(product_id);
CREATE INDEX idx_order_items_vendor ON order_items(vendor_id);
```

**Purpose**: Items in an order (snapshot)

---

### **orders.OrderStatusHistory**
```sql
CREATE TABLE order_status_history (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    order_id UUID NOT NULL REFERENCES orders(id) ON DELETE CASCADE,
    
    status VARCHAR(20) NOT NULL,
    notes TEXT,
    
    -- Who changed it
    changed_by_id UUID REFERENCES users(id) ON DELETE SET NULL,
    
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_order_status_history_order ON order_status_history(order_id, created_at DESC);
```

**Purpose**: Track order status changes for timeline display

---

### **orders.Coupon**
```sql
CREATE TABLE coupons (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    code VARCHAR(50) UNIQUE NOT NULL,
    
    -- Discount
    discount_type VARCHAR(20) NOT NULL,
        -- VALUES: 'PERCENTAGE', 'FIXED'
    discount_value DECIMAL(10,2) NOT NULL,
    max_discount DECIMAL(10,2),  -- Maximum discount for percentage type
    
    -- Conditions
    min_order_value DECIMAL(10,2) DEFAULT 0,
    max_usage INTEGER,           -- Total usage limit
    usage_per_user INTEGER DEFAULT 1,
    
    -- Validity
    valid_from TIMESTAMP NOT NULL,
    valid_until TIMESTAMP NOT NULL,
    
    -- Stats
    usage_count INTEGER DEFAULT 0,
    
    -- Flags
    is_active BOOLEAN DEFAULT true,
    
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    CONSTRAINT chk_discount_type CHECK (discount_type IN ('PERCENTAGE', 'FIXED')),
    CONSTRAINT chk_discount_value CHECK (discount_value > 0)
);

CREATE INDEX idx_coupons_code_active ON coupons(code, is_active);
CREATE INDEX idx_coupons_validity ON coupons(valid_from, valid_until);
```

**Purpose**: Discount coupons

---

## 6️⃣ Reviews & Ratings Schema

### **reviews.Review**
```sql
CREATE TABLE reviews (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    product_id UUID NOT NULL REFERENCES products(id) ON DELETE CASCADE,
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    order_item_id UUID REFERENCES order_items(id) ON DELETE SET NULL,
    
    -- Review Content
    rating INTEGER NOT NULL,  -- 1-5
    title VARCHAR(255) NOT NULL,
    comment TEXT NOT NULL,
    
    -- Media
    images JSONB DEFAULT '[]',  -- Array of image URLs
    
    -- Verification
    is_verified_purchase BOOLEAN DEFAULT false,
    
    -- Moderation
    is_approved BOOLEAN DEFAULT false,
    is_flagged BOOLEAN DEFAULT false,
    
    -- Helpfulness
    helpful_count INTEGER DEFAULT 0,
    
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    CONSTRAINT chk_rating_range CHECK (rating >= 1 AND rating <= 5),
    CONSTRAINT uq_review_order_item UNIQUE (product_id, user_id, order_item_id)
);

CREATE INDEX idx_reviews_product_created ON reviews(product_id, created_at DESC);
CREATE INDEX idx_reviews_user ON reviews(user_id);
CREATE INDEX idx_reviews_rating ON reviews(rating);
CREATE INDEX idx_reviews_approved ON reviews(is_approved) WHERE is_approved = true;
```

**Purpose**: Product reviews and ratings

---

### **reviews.ReviewResponse**
```sql
CREATE TABLE review_responses (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    review_id UUID UNIQUE NOT NULL REFERENCES reviews(id) ON DELETE CASCADE,
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,  -- Admin or Vendor
    
    comment TEXT NOT NULL,
    
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_review_responses_review ON review_responses(review_id);
```

**Purpose**: Vendor/Admin responses to reviews

---

## 7️⃣ Notifications Schema

### **notifications.Notification**
```sql
CREATE TABLE notifications (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    
    -- Content
    notification_type VARCHAR(30) NOT NULL,
        -- VALUES: 'ORDER_PLACED', 'ORDER_CONFIRMED', 'ORDER_SHIPPED', 
        --         'ORDER_DELIVERED', 'ORDER_CANCELLED', 'PAYMENT_SUCCESS', 
        --         'PAYMENT_FAILED', 'PROMOTIONAL', 'SYSTEM'
    title VARCHAR(255) NOT NULL,
    message TEXT NOT NULL,
    
    -- Action
    action_url VARCHAR(500),  -- Deep link or screen route
    
    -- Related Objects
    order_id UUID REFERENCES orders(id) ON DELETE SET NULL,
    
    -- Status
    is_read BOOLEAN DEFAULT false,
    read_at TIMESTAMP,
    
    -- FCM
    fcm_sent BOOLEAN DEFAULT false,
    fcm_sent_at TIMESTAMP,
    
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    CONSTRAINT chk_notification_type CHECK (notification_type IN ('ORDER_PLACED', 'ORDER_CONFIRMED', 'ORDER_SHIPPED', 'ORDER_DELIVERED', 'ORDER_CANCELLED', 'PAYMENT_SUCCESS', 'PAYMENT_FAILED', 'PROMOTIONAL', 'SYSTEM'))
);

CREATE INDEX idx_notifications_user_created ON notifications(user_id, created_at DESC);
CREATE INDEX idx_notifications_user_read ON notifications(user_id, is_read);
CREATE INDEX idx_notifications_type ON notifications(notification_type);
```

**Purpose**: User notifications

---

## 8️⃣ Analytics & Recommendations Schema

### **analytics.UserBrowsingHistory**
```sql
CREATE TABLE user_browsing_history (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    product_id UUID NOT NULL REFERENCES products(id) ON DELETE CASCADE,
    
    view_count INTEGER DEFAULT 1,
    last_viewed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    CONSTRAINT uq_user_product UNIQUE (user_id, product_id)
);

CREATE INDEX idx_browsing_history_user_viewed ON user_browsing_history(user_id, last_viewed_at DESC);
CREATE INDEX idx_browsing_history_product ON user_browsing_history(product_id);
```

**Purpose**: Track product views for AI recommendations

---

### **analytics.ProductRecommendation**
```sql
CREATE TABLE product_recommendations (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    product_id UUID NOT NULL REFERENCES products(id) ON DELETE CASCADE,
    recommended_product_id UUID NOT NULL REFERENCES products(id) ON DELETE CASCADE,
    
    score DECIMAL(5,3) NOT NULL,  -- 0.000 to 1.000
    reason VARCHAR(100),           -- 'collaborative', 'similar', 'trending'
    
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    CONSTRAINT uq_product_recommendation UNIQUE (product_id, recommended_product_id),
    CONSTRAINT chk_score_range CHECK (score >= 0 AND score <= 1)
);

CREATE INDEX idx_product_recommendations_product_score ON product_recommendations(product_id, score DESC);
```

**Purpose**: Pre-computed product recommendations

---

## 🔧 Database Optimization Strategy

### **Indexing Guidelines**
1. **Foreign Keys**: Always indexed
2. **Frequently Queried**: Status, created_at, is_active
3. **Composite Indexes**: For multi-column WHERE clauses
4. **Partial Indexes**: For specific conditions (e.g., WHERE is_active = true)

### **Query Optimization**
- Use `EXPLAIN ANALYZE` for slow queries
- Implement connection pooling
- Use database query caching (Redis)
- Regular VACUUM and ANALYZE

### **Data Archival Strategy**
- Archive orders older than 2 years
- Soft delete for data retention
- Periodic cleanup of expired carts

---

## 📊 Sample Queries

### Get User's Cart with Items
```sql
SELECT c.*, ci.*, p.name, p.price, p.thumbnail
FROM carts c
JOIN cart_items ci ON c.id = ci.cart_id
JOIN products p ON ci.product_id = p.id
WHERE c.user_id = 'user-uuid'
  AND c.expires_at > NOW();
```

### Get Product with All Details
```sql
SELECT 
    p.*,
    c.name as category_name,
    b.name as brand_name,
    fp.food_type,
    cp.gender,
    array_agg(pi.image_url) as images
FROM products p
LEFT JOIN categories c ON p.category_id = c.id
LEFT JOIN brands b ON p.brand_id = b.id
LEFT JOIN food_products fp ON p.id = fp.product_id
LEFT JOIN clothing_products cp ON p.id = cp.product_id
LEFT JOIN product_images pi ON p.id = pi.product_id
WHERE p.slug = 'product-slug'
GROUP BY p.id, c.name, b.name, fp.food_type, cp.gender;
```

### Get Order Status Timeline
```sql
SELECT 
    osh.status,
    osh.notes,
    osh.created_at,
    u.first_name || ' ' || u.last_name as changed_by
FROM order_status_history osh
LEFT JOIN users u ON osh.changed_by_id = u.id
WHERE osh.order_id = 'order-uuid'
ORDER BY osh.created_at ASC;
```

---

## 🚀 Migration Strategy

### Phase 1: Core Tables
1. users, addresses
2. categories, brands
3. products (base)

### Phase 2: Product Extensions
1. food_products
2. clothing_products
3. product_variants
4. product_images

### Phase 3: Commerce
1. carts, cart_items
2. wishlists, wishlist_items
3. orders, order_items, order_status_history
4. coupons

### Phase 4: Engagement
1. reviews, review_responses
2. notifications
3. user_browsing_history
4. product_recommendations

---

**Database Schema Complete** ✅  
**Total Tables**: 23  
**Normalized**: 3NF  
**Optimized**: Yes
