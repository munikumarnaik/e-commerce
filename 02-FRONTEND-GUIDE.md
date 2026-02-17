# 📱 Frontend Implementation Guide
## Dual-Category Flutter App — Food & Clothing
> **Stack:** Flutter 3.16+ · Riverpod · GoRouter · Dio · Lottie · Rive · Flutter Animate · Firebase

---

## 📌 Table of Contents

1. [Project Overview](#1-project-overview)
2. [Tech Stack & Libraries](#2-tech-stack--libraries)
3. [Project Folder Structure](#3-project-folder-structure)
4. [Dual App Identity — Food & Clothing](#4-dual-app-identity--food--clothing)
5. [Theme System](#5-theme-system)
6. [Animation System](#6-animation-system)
7. [Splash Screen](#7-splash-screen)
8. [Onboarding Screen](#8-onboarding-screen)
9. [App Navigation](#9-app-navigation)
10. [Authentication Screens](#10-authentication-screens)
11. [Home Screen](#11-home-screen)
12. [Food Section — Screens & UI](#12-food-section--screens--ui)
13. [Clothing Section — Screens & UI](#13-clothing-section--screens--ui)
14. [Product Detail Screen](#14-product-detail-screen)
15. [Search Screen](#15-search-screen)
16. [Cart Screen](#16-cart-screen)
17. [Wishlist Screen](#17-wishlist-screen)
18. [Checkout Flow](#18-checkout-flow)
19. [Payment Screens](#19-payment-screens)
20. [Order Tracking Screen](#20-order-tracking-screen)
21. [Order Success Screen](#21-order-success-screen)
22. [Reviews & Ratings Screen](#22-reviews--ratings-screen)
23. [Notifications Screen](#23-notifications-screen)
24. [Profile & Settings Screen](#24-profile--settings-screen)
25. [Shared UI Components](#25-shared-ui-components)
26. [State Management Strategy](#26-state-management-strategy)
27. [API Integration Layer](#27-api-integration-layer)
28. [Local Storage Strategy](#28-local-storage-strategy)
29. [Push Notification Handling](#29-push-notification-handling)
30. [Security Measures](#30-security-measures)
31. [Performance Optimisation](#31-performance-optimisation)
32. [App Store Release Checklist](#32-app-store-release-checklist)
33. [Testing Strategy](#33-testing-strategy)
34. [Phase-wise Roadmap](#34-phase-wise-roadmap)

---

## 1. Project Overview

The Flutter mobile app is the customer-facing interface for the dual-category e-commerce platform. It supports both the **Food** ordering experience and the **Clothing** shopping experience within a single application, with the two sections having distinctly different visual identities, colour schemes, and interaction patterns. The app communicates entirely with the Django backend via REST APIs over HTTPS.

### App Users
- **Customers** — Browse, order, track, and review products from both categories
- **Vendors (Mobile)** — A simplified vendor view for managing orders and inventory on mobile

---

## 2. Tech Stack & Libraries

### Core Libraries

| Category | Library | Purpose |
|----------|---------|---------|
| State Management | flutter_riverpod | Reactive, testable state management |
| Navigation | go_router | Declarative routing with deep link support |
| HTTP Client | dio | API calls with interceptors and retry |
| Secure Storage | flutter_secure_storage | Store JWT tokens securely |
| Local Cache | hive_flutter | Fast local key-value store for offline support |
| Image Loading | cached_network_image | Network image caching |
| App Icons | flutter_launcher_icons | Auto-generates icons for Android and iOS |
| Splash Screen | flutter_native_splash | Native splash before Flutter engine starts |

### Animation Libraries

| Library | Purpose | Used In |
|---------|---------|---------|
| **flutter_animate** | Code-driven micro-animations and transitions | Throughout the entire app |
| **lottie** | JSON-based vector animations | Splash screen, onboarding, empty states, success screens |
| **rive** | Interactive and stateful animations | Logo animation, bottom navigation |
| **shimmer** | Skeleton loading shimmer effect | Product lists, order history while loading |
| **skeletonizer** | Widget-level skeleton wrapping | Any loading screen |
| **confetti** | Particle burst effect | Order success screen |
| **animated_bottom_navigation_bar** | Animated tab bar with icons | Main app shell |

### UI Libraries

| Library | Purpose |
|---------|---------|
| flutter_staggered_animations | List and grid items animate in with stagger delay |
| carousel_slider | Image carousel on product detail and banner |
| smooth_page_indicator | Page dots for onboarding and image carousels |
| flutter_rating_bar | Star rating widget for reviews |
| pinput | OTP input field for email verification |
| google_maps_flutter | Map view for delivery address |
| geolocator | GPS location for auto-fill address |

---

## 3. Project Folder Structure

```
lib/
│
├── main.dart                          ← App entry point
├── app.dart                           ← Root widget with theme and router
│
├── core/                              ← App-wide shared logic
│   ├── constants/
│   │   ├── app_colors.dart            ← All colour definitions (food + clothing themes)
│   │   ├── app_text_styles.dart       ← Typography styles
│   │   ├── app_dimensions.dart        ← Spacing and sizing constants
│   │   └── app_strings.dart           ← Static string constants
│   ├── theme/
│   │   ├── app_theme.dart             ← ThemeData builder for both categories
│   │   ├── food_theme.dart            ← Food-specific colour overrides
│   │   └── clothing_theme.dart        ← Clothing-specific colour overrides
│   ├── router/
│   │   ├── app_router.dart            ← GoRouter configuration
│   │   └── route_names.dart           ← All route path constants
│   ├── network/
│   │   ├── dio_client.dart            ← Configured Dio instance
│   │   ├── api_endpoints.dart         ← All API endpoint constants
│   │   └── interceptors/
│   │       ├── auth_interceptor.dart  ← Auto-inject JWT header
│   │       └── error_interceptor.dart ← Handle 401/500 responses globally
│   ├── storage/
│   │   ├── secure_storage.dart        ← JWT token read/write
│   │   └── local_cache.dart           ← Hive box management
│   └── utils/
│       ├── validators.dart            ← Form field validators
│       ├── formatters.dart            ← Price, date, string formatters
│       └── extensions.dart            ← Dart extension methods
│
├── features/                          ← One folder per feature
│   ├── splash/                        ← Splash screen
│   ├── onboarding/                    ← 3-page onboarding slides
│   ├── auth/                          ← Login, Register, OTP, Reset Password
│   ├── home/                          ← Home screen with category toggle
│   ├── food/                          ← Food listing, restaurant, food detail
│   ├── clothing/                      ← Clothing listing, filters, clothing detail
│   ├── search/                        ← Search screen with autocomplete
│   ├── cart/                          ← Cart items, price summary
│   ├── wishlist/                      ← Saved items
│   ├── checkout/                      ← Address selection, coupon, order summary
│   ├── payment/                       ← Payment initiation and result screens
│   ├── orders/                        ← Order history, order detail, tracking
│   ├── reviews/                       ← Review list and submission
│   ├── recommendations/               ← Recommendation widgets
│   ├── notifications/                 ← Notification list and settings
│   └── profile/                       ← Profile, addresses, settings
│
└── shared/                            ← Reusable widgets and helpers
    ├── widgets/
    │   ├── custom_button.dart
    │   ├── product_card.dart
    │   ├── loading_skeleton.dart
    │   ├── error_state_widget.dart
    │   └── empty_state_widget.dart
    └── animations/
        ├── fade_slide_transition.dart
        ├── staggered_list_animation.dart
        └── bounce_tap_animation.dart
```

---

## 4. Dual App Identity — Food & Clothing

The app has two visually distinct sections that share the same shell (navigation, auth, cart). Switching between Food and Clothing changes the active theme, colour palette, typography feel, and certain UI patterns.

### Identity Comparison

| Aspect | Food Section | Clothing Section |
|--------|-------------|-----------------|
| Primary Colour | Vibrant Orange `#FF6B35` | Deep Navy `#1A1A2E` |
| Secondary Colour | Warm Amber `#FF9F1C` | Fashion Pink-Red `#E94560` |
| Background | Warm Cream `#FFF8F0` | Clean White-Blue `#F8F9FF` |
| Typography Feel | Rounded, friendly, warm | Clean, sharp, editorial |
| Card Style | Rounded corners, warm shadows | Sharp cards, minimal shadows |
| Icons & Emojis | Food-themed (🍕🍜🍣🥗) | Fashion-themed (👗👟👜👒) |
| Filter Style | Horizontal chips (diet, cuisine) | Sidebar filters (size, gender, brand) |
| Product Grid | 2-column with large food images | 2-column with tall fashion images |
| Banner Style | Warm gradient banners | Dark editorial banners |
| CTA Buttons | Orange rounded buttons | Navy or red outlined buttons |
| Empty States | Friendly food emoji animations | Minimal fashion illustration |

### Category Switcher Behaviour

- A **pill-style toggle** in the home screen header switches between Food and Clothing
- Switching category re-renders the home content with the appropriate theme
- The bottom navigation icons subtly recolour to match the active theme
- Cart and wishlist persist across both categories — mixed carts are supported
- The app remembers the last active category on re-launch

---

## 5. Theme System

### Structure

The app maintains two full `ThemeData` configurations — one for Food and one for Clothing — and switches between them reactively using a Riverpod provider that stores the current active category.

### Light Mode vs Dark Mode

- Both the Food and Clothing themes support light and dark variants
- The user can toggle dark mode from Profile > Settings
- Dark mode respects the active category's colour palette (dark food vs dark clothing)
- System dark mode preference is respected by default

### Food Theme Colour Palette

| Token | Hex | Usage |
|-------|-----|-------|
| Primary | `#FF6B35` | Buttons, active states, highlights |
| Secondary | `#FF9F1C` | Secondary actions, accents |
| Accent | `#2EC4B6` | Badge colours, chips |
| Background | `#FFF8F0` | Scaffold background |
| Surface | `#FFEFE0` | Card backgrounds |
| Text Primary | `#2D1B0E` | Body text |
| Success | `#4CAF50` | Veg badge, in-stock |
| Error | `#E53935` | Non-veg badge, out-of-stock |

### Clothing Theme Colour Palette

| Token | Hex | Usage |
|-------|-----|-------|
| Primary | `#1A1A2E` | App bar, buttons |
| Secondary | `#16213E` | Cards, surfaces |
| Accent | `#E94560` | Discount badges, wish icons, highlights |
| Background | `#F8F9FF` | Scaffold background |
| Surface | `#EEF0FF` | Card backgrounds |
| Text Primary | `#1A1A2E` | Body text |
| Gold | `#FFD700` | Premium product badges |
| White | `#FFFFFF` | App bar text, icons on dark |

---

## 6. Animation System

### Animation Philosophy

Animations in this app serve a functional purpose — they guide user attention, confirm actions, and make transitions feel smooth and natural. Animations are never decorative-only. Every animation has a clear reason: feedback, orientation, or delight.

### Animation Types Used

| Type | Library | Description | Examples |
|------|---------|-------------|---------|
| Entrance Animations | flutter_animate | Elements fade + slide in when a screen loads | Product cards, order items, section headers |
| Stagger Animations | flutter_staggered_animations | List or grid items appear one after another with a delay | Product grid, search results, notifications |
| Page Transitions | flutter_animate + GoRouter | Screens slide in/out or fade between routes | All screen navigations |
| Micro-interactions | flutter_animate | Small responsive animations on tap or state change | Wishlist heart toggle, add-to-cart button, like button |
| Lottie Animations | lottie | Pre-designed JSON animation files for emotional moments | Splash, onboarding, success, empty states |
| Rive Animations | rive | Stateful interactive animations | App logo, bottom nav icons |
| Shimmer Loading | shimmer + skeletonizer | Skeleton placeholders while data loads | Product cards, order list, profile |
| Confetti Burst | confetti | Particle explosion for celebration moments | Order placed success screen |
| Parallax Scroll | Custom with CustomScrollView | Header image scrolls slower than content | Product detail, restaurant header |
| Hero Transition | Flutter Hero widget | Product image expands from card to detail screen | Product card → Detail screen |
| Haptic Feedback | HapticFeedback API | Tactile response paired with visual animations | Add to cart, wishlist toggle, payment success |

---

## 7. Splash Screen

The splash screen is the first thing a user sees. It plays a short animated sequence before navigating to the onboarding (first launch) or home screen (returning user).

### Splash Screen Elements

| Element | Description | Animation |
|---------|-------------|-----------|
| Background | Deep navy-to-midnight gradient matching the app's premium feel | Static |
| Floating Particles | 12 small coloured dots floating at random positions around the screen | Pulse scale loop using `flutter_animate` |
| App Logo | A Lottie animation that morphs between a food fork and a clothing hanger — representing the dual identity | Play-once Lottie on a 180×180 canvas, scales in with elastic bounce |
| App Name — "ShopVerse" | Large bold white text below the logo | Fade in + slide up with 400ms delay |
| Tagline | Gradient text — "Food & Fashion — All in One" | Fade in + slide up with 600ms delay |
| Category Icons Row | Two circular icons — 🍕 Food and 👗 Fashion — with their labels below | Scale in from 50% size, staggered 200ms apart |
| Loading Bar | A thin white progress bar at the bottom of the screen | Animates from 0% to 100% over 2.5 seconds |

### Splash Navigation Logic

| Condition | Destination |
|-----------|-------------|
| First time launch (no token) | Onboarding screen |
| Returning user with valid token | Home screen |
| Returning user with expired token | Login screen |

### Total Splash Duration

The splash screen plays for approximately **3 seconds** before navigating. The navigation check (auth token validation) runs concurrently in the background.

---

## 8. Onboarding Screen

The onboarding is shown only on first-time launch. It has 3 full-screen swipeable pages.

### Onboarding Pages

| Page | Lottie Animation | Title | Subtitle |
|------|-----------------|-------|---------|
| Page 1 — Food | Food delivery rider animation on warm orange gradient | "Fresh Food, At Your Door" | "Order from hundreds of restaurants and get fresh meals delivered in minutes." |
| Page 2 — Fashion | Shopping bags and clothing animation on navy gradient | "Fashion That Fits You" | "Discover thousands of styles across top brands with easy size guides." |
| Page 3 — Tracking | Package delivery and map animation on teal-navy gradient | "Track Every Order Live" | "Real-time updates from confirmation to delivery at your doorstep." |

### Onboarding UI Elements

| Element | Description |
|---------|-------------|
| Skip Button | Top-right corner, skips to login screen at any point |
| Page Indicator | Worm-style animated dot indicator from `smooth_page_indicator` |
| Back Button | Circular outlined button on the left (hidden on page 1) |
| Next / Get Started Button | Rounded filled button on the right; label changes to "Get Started" on last page |
| Page Transition | Smooth horizontal slide with Lottie animation cross-fade |

### Onboarding Navigation

- Swiping through all 3 pages and tapping "Get Started" navigates to Register screen
- Tapping "Skip" at any point navigates directly to Login screen
- Onboarding is shown only once; on subsequent launches, it is skipped

---

## 9. App Navigation

### Navigation Structure

The app uses **GoRouter** for declarative, type-safe navigation with deep link support.

```
/splash                           Splash screen
/onboarding                       First-launch onboarding
/auth/login                       Login screen
/auth/register                    Register screen
/auth/verify-otp                  Email OTP verification
/auth/forgot-password             Forgot password
/auth/reset-password              Reset password

Main Shell (Bottom Navigation)
  ├── /home                       Dual-category home screen
  ├── /search                     Search screen
  ├── /cart                       Cart screen
  └── /profile                    Profile screen

/food/:id                         Food product detail
/clothing/:id                     Clothing product detail
/category/:slug                   Category listing
/restaurant/:id                   Restaurant / vendor page
/checkout                         Checkout flow
/checkout/address                 Address selection step
/checkout/summary                 Order summary step
/payment                          Payment screen
/payment/success/:orderId         Order success screen
/payment/failure                  Payment failure screen
/orders                           Order history
/orders/:id                       Order detail
/orders/:id/track                 Order tracking timeline
/wishlist                         Wishlist screen
/reviews/:productId               Product reviews
/notifications                    Notification centre
/profile/addresses                Manage addresses
/profile/settings                 App settings
```

### Bottom Navigation Tabs

| Tab | Icon | Label | Badge |
|-----|------|-------|-------|
| Home | House / fork-hanger icon (Rive, changes per category) | Home | None |
| Search | Magnifying glass | Search | None |
| Cart | Shopping bag | Cart | Item count badge (animated pop-in) |
| Profile | Person avatar | Profile | Unread notification dot |

### Navigation Animations

| Transition | Animation |
|-----------|-----------|
| Screen push (forward) | Slide in from right with fade |
| Screen pop (back) | Slide out to right with fade |
| Bottom tab switch | Cross-fade with subtle scale |
| Modal bottom sheets | Slide up with spring curve |
| Dialogs | Scale in from centre with fade |

---

## 10. Authentication Screens

### Login Screen

| Element | Description | Animation |
|---------|-------------|-----------|
| Background | Gradient from Food orange to Clothing navy, split diagonally | Static |
| Logo | Compact app logo at top | Fade in on load |
| Welcome Text | "Welcome Back 👋" | Slide up on load |
| Email Field | Outlined text field with email icon | Slide up, staggered 100ms after title |
| Password Field | Outlined text field with show/hide toggle | Slide up, staggered 200ms |
| Login Button | Full-width filled button | Slide up, staggered 300ms |
| Forgot Password Link | Underlined text link | Fade in |
| Social Login (Google / Apple) | Icon buttons with divider | Fade in |
| Register Link | "Don't have an account? Register" at bottom | Fade in |

### Register Screen

| Element | Description |
|---------|-------------|
| Full Name Field | Text input |
| Email Field | Text input with live validation |
| Phone Field | Optional, with country code picker |
| Password Field | With strength indicator bar (weak / medium / strong) |
| Confirm Password Field | With match validation |
| Register Button | Full-width, disabled until all fields valid |
| Terms & Conditions | Checkbox with link |

### OTP Verification Screen

- 6-digit OTP input using `pinput` library
- Each digit box animates with a subtle border colour change on focus
- Resend OTP button with 60-second countdown timer
- Auto-submit when the 6th digit is entered
- Error state shakes the entire OTP row with `flutter_animate`

### Password Reset Flow

| Step | Screen | Description |
|------|--------|-------------|
| 1 | Forgot Password | Enter email address |
| 2 | OTP Verification | Verify 6-digit OTP |
| 3 | New Password | Enter and confirm new password |
| 4 | Success | Lottie success animation + redirect to login |

---

## 11. Home Screen

### Home Screen Layout

```
┌─────────────────────────────────┐
│  App Bar — Logo + Cart + Bell   │
├─────────────────────────────────┤
│  Greeting — "Good morning, Raj" │
├─────────────────────────────────┤
│  [ 🍕 Food ]  [ 👗 Fashion ]   │  ← Animated Toggle
├─────────────────────────────────┤
│  Search Bar (shortcut to search)│
├─────────────────────────────────┤
│  Banner Carousel — Promotions   │  ← Auto-scroll carousel
├─────────────────────────────────┤
│  Category Chips — Scrollable    │
├─────────────────────────────────┤
│  🔥 Today's Specials            │  ← Horizontal scroll
├─────────────────────────────────┤
│  Recommended for You            │  ← Horizontal scroll
├─────────────────────────────────┤
│  Product Grid — Lazy Loaded     │  ← Stagger enter animation
└─────────────────────────────────┘
```

### Home Screen Animations

| Element | Animation | Trigger |
|---------|-----------|---------|
| Category Toggle | Animated container with colour + shadow transition | On tap |
| Banner Carousel | Auto-scroll every 4 seconds + swipe gesture | Automatic |
| Category Chips | Slide in from left, staggered | On screen load |
| Section Headers | Fade + slide up | On screen load |
| Product Cards | Stagger fade + slide up (each card 80ms apart) | On section scroll into view |
| Cart Badge Count | Pop-in scale animation when count changes | On cart add |
| Refresh (Pull-to-refresh) | Custom food/fashion emoji loading indicator | On pull |

---

## 12. Food Section — Screens & UI

### Food Home Screen

| Section | Description |
|---------|-------------|
| Header | "What are you craving?" with location and delivery time |
| Diet Filter Chips | All, Veg 🟢, Non-Veg 🔴, Vegan 🌿 — horizontally scrollable |
| Cuisine Filter | Indian, Chinese, Italian, Mexican, etc. — icon chips |
| Featured Restaurants | Horizontal carousel of restaurant cards with rating and delivery time |
| Today's Specials | Horizontal scroll of discounted food items |
| Near You | Grid of nearby restaurant cards |
| Free Delivery | Products qualifying for free delivery |

### Food Card Design

| Element | Description |
|---------|-------------|
| Image | Full-bleed food photo (tall card) |
| Diet Badge | Top-left green dot (veg) or red dot (non-veg) |
| Restaurant Name | Below image |
| Cuisine Tag | Small chip |
| Rating | Star + number |
| Delivery Time | Clock icon + minutes |
| Price | Bold price with MRP crossed out |
| Add Button | Circular `+` button at bottom right |

### Restaurant / Vendor Page

| Section | Description |
|---------|-------------|
| Header | Parallax restaurant banner image with name overlay |
| Info Bar | Rating, delivery time, minimum order, delivery fee |
| Menu Categories | Sticky horizontal tab bar (Starters, Main, Desserts, Drinks) |
| Menu Items | List view with image, name, description, price, add button |
| Reviews Section | Star distribution + top 3 reviews |

### Food-Specific Filter Sheet

Filters available in the bottom sheet for food products:

- Diet Type: Veg / Non-Veg / Vegan
- Cuisine: Multi-select chips
- Maximum Calories slider
- Halal Certified toggle
- Gluten Free toggle
- Maximum Prep Time slider
- Minimum Rating: 1★ to 5★
- Sort By: Relevance, Price Low-High, Price High-Low, Rating, Popularity

---

## 13. Clothing Section — Screens & UI

### Clothing Home Screen

| Section | Description |
|---------|-------------|
| Header | Editorial banner with "New Season Arrivals" CTA |
| Gender Filter | Men / Women / Kids / Unisex tab row |
| Trending Now | Horizontal scroll of trending clothing items |
| Top Brands | Brand logo row — horizontal scroll |
| New Arrivals | Grid of newest clothing products |
| Flash Sale | Countdown timer + horizontal product scroll |

### Clothing Card Design

| Element | Description |
|---------|-------------|
| Image | Tall portrait fashion image (4:5 ratio) |
| Wishlist Heart | Top-right heart button with animated toggle |
| Brand Name | Below image, smaller text |
| Product Name | Bold, below brand |
| Size Availability | Small dots/chips showing available sizes |
| Price | Bold price with MRP and discount percentage badge |

### Clothing Detail — Size & Colour Selector

| Element | Description |
|---------|-------------|
| Colour Swatches | Circular colour chips; selected colour has animated ring |
| Size Grid | Grid of size labels (XS, S, M, L, XL); selected has filled background |
| Size Guide Button | Opens a bottom sheet with a measurement chart |
| Stock Indicator | Shows "Only 3 left" if stock < 5 |

### Clothing-Specific Filter Sheet

Filters available in the bottom sheet for clothing:

- Gender: Men / Women / Unisex / Kids
- Size: Multi-select grid (XS, S, M, L, XL, XXL)
- Colour: Colour swatch multi-select
- Brand: Multi-select searchable list
- Fabric: Multi-select chips
- Fit: Slim / Regular / Relaxed / Oversized
- Price Range: Dual-handle slider
- Minimum Rating: Star selector
- Sort By: Relevance, Price, Newest, Popularity, Rating

---

## 14. Product Detail Screen

### Screen Layout

```
┌─────────────────────────────────┐
│  Back Arrow    Wishlist Heart   │  ← App bar overlay on image
├─────────────────────────────────┤
│  Product Image Carousel         │  ← Hero transition from card
│  (Swipeable, dot indicator)     │
├─────────────────────────────────┤
│  Product Name                   │
│  Brand Name  /  Rating          │
│  Price  MRP crossed  Discount % │
├─────────────────────────────────┤
│  Colour Selector (clothing)     │
│  Size Selector (clothing/food)  │
│  Quantity Selector (food)       │
├─────────────────────────────────┤
│  Description (expandable)       │
├─────────────────────────────────┤
│  Nutrition Info (food only)     │
│  Diet / Allergen Badges         │
├─────────────────────────────────┤
│  Care Instructions (clothing)   │
├─────────────────────────────────┤
│  You May Also Like              │  ← Horizontal scroll
├─────────────────────────────────┤
│  Reviews Section                │
└─────────────────────────────────┘
│  [Add to Cart]    [Buy Now]     │  ← Sticky bottom bar
```

### Product Detail Animations

| Element | Animation |
|---------|-----------|
| Screen entry | Hero transition — product image expands from grid card |
| Wishlist heart | Toggle between outlined and filled with scale bounce |
| Add to Cart | Button shows spinner → tick → resets; triggers cart badge pop |
| Image Carousel | Swipe with inertia; dot indicator animates with smooth page indicator |
| Size Selection | Selected item slides background colour in with AnimatedContainer |
| Colour Selection | Selected swatch gets animated ring border |
| Description expand | Smooth height animation on "Read More" tap |
| Sticky bar | Slides up from bottom when page loads with spring animation |

---

## 15. Search Screen

### Search Screen Layout

| State | Description |
|-------|-------------|
| Empty / Default | Recent searches list + trending searches chips |
| Typing | Real-time autocomplete suggestions dropdown (min 2 characters) |
| Results | Grid of matching products with active filters |
| No Results | Lottie "no results" animation with suggested alternatives |

### Search Animations

| Element | Animation |
|---------|-----------|
| Search bar focus | Expands slightly + border brightens |
| Autocomplete dropdown | Slides down from search bar |
| Results | Stagger fade-in as each result appears |
| Filter sheet open | Slides up from bottom with spring curve |
| Applied filter chips | Slide in with scale entrance |

---

## 16. Cart Screen

### Cart Screen Layout

```
┌─────────────────────────────────┐
│  Cart  (3 items)    Clear All   │
├─────────────────────────────────┤
│  Cart Item Card                 │  ← Swipe left to remove (Dismissible)
│   Image | Name | Variant        │
│   Qty [ - ] [ 2 ] [ + ]  Price  │
├─────────────────────────────────┤
│  Cart Item Card                 │
├─────────────────────────────────┤
│  Coupon Code Input              │  ← With "Apply" button
├─────────────────────────────────┤
│  Price Breakdown                │
│   Subtotal        ₹1,200        │
│   Delivery            ₹40       │
│   Tax                ₹108       │
│   Coupon Discount   -₹120       │
│   ─────────────────────────     │
│   Total           ₹1,228        │
├─────────────────────────────────┤
│  [ Proceed to Checkout ]        │
└─────────────────────────────────┘
```

### Cart Animations

| Element | Animation |
|---------|-----------|
| Cart items entry | Stagger fade + slide from right |
| Quantity change | Number animates with a tick (count-up/count-down) |
| Remove item (swipe) | Swipe-to-dismiss with red background reveal |
| Price breakdown update | Numbers animate when quantity or coupon changes |
| Coupon applied | Green checkmark animates in + discount row slides in |
| Empty cart state | Lottie empty cart animation with "Start Shopping" CTA |

---

## 17. Wishlist Screen

### Wishlist Screen Layout

- Grid of wishlisted products (2-column)
- Each card shows product name, price, and stock status
- Heart icon on each card (filled) — tap to remove from wishlist with animation
- "Move to Cart" button per item
- Empty state: Lottie animation of an empty heart with CTA

### Wishlist Animations

| Element | Animation |
|---------|-----------|
| Heart remove | Heart animates to unfilled + card slides up and collapses |
| Move to Cart | Cart icon bounces + confirmation snackbar slides up |
| Grid items | Stagger entrance on screen load |

---

## 18. Checkout Flow

The checkout is a multi-step linear flow (not a single screen).

### Step 1 — Address Selection

- List of saved addresses with radio selection
- "Add New Address" button opens address form
- Google Places autocomplete for address search
- GPS "Use Current Location" button
- Selected address highlights with animated colour change

### Step 2 — Order Summary

| Section | Description |
|---------|-------------|
| Items List | Compact list of all cart items with quantities |
| Delivery Details | Selected address and estimated delivery date |
| Coupon | Input field with validation feedback |
| Price Breakdown | Full breakdown matching the cart screen |
| Category Split | Separate Food and Clothing item groups if mixed order |

### Step 3 — Payment Selection

| Payment Method | Icon | Description |
|----------------|------|-------------|
| UPI | UPI logo | Enter UPI ID or scan QR |
| Net Banking | Bank icon | Opens Razorpay bank selection |
| Debit / Credit Card | Card icon | Enter card details |
| Wallets | Wallet icon | Paytm, PhonePe, etc. |
| Cash on Delivery | Hand icon | Available for eligible orders |

### Checkout Progress Indicator

A 3-step top progress bar (Address → Summary → Payment) animates forward as the user progresses through each step.

---

## 19. Payment Screens

### Payment Processing Screen

- Full-screen modal while Razorpay / Stripe SDK is active
- Do-not-close instruction text
- Spinner animation while awaiting gateway response

### Payment Success Screen

See [Order Success Screen — Section 21](#21-order-success-screen)

### Payment Failure Screen

| Element | Description |
|---------|-------------|
| Lottie Animation | Red sad animation or failure icon animation |
| Error Message | Human-readable reason (card declined, timeout, etc.) |
| Retry Button | Re-opens payment sheet for the same order |
| Change Payment Method | Returns to payment selection step |
| Contact Support | Opens in-app support chat or email |

---

## 20. Order Tracking Screen

### Tracking Timeline Layout

The order tracking screen shows a vertical animated timeline with each status as a node.

| Node | State | Visual |
|------|-------|--------|
| Order Placed | ✅ Done | Filled circle with checkmark (animated tick-in) |
| Order Confirmed | ✅ Done | Filled circle with checkmark |
| Being Prepared | ✅ Done / ⏳ Active | Filled or pulsing active dot |
| Shipped / Dispatched | ✅ Done / ⏳ Active | Filled or pulsing |
| Out for Delivery | ✅ Done / ⏳ Active | Delivery truck icon |
| Delivered | ✅ Done | Green filled circle with checkmark |

### Tracking Animations

| Element | Animation |
|---------|-----------|
| Timeline nodes | Each completed node animates in with a checkmark scale |
| Active node | Pulsing dot (scale in/out loop) to indicate current status |
| Connector lines | Animate to fill with the primary colour as status progresses |
| Timeline entries | Stagger slide-in from the right (100ms per item) |
| ETA chip | Countdown or date badge at the top |

### Tracking Map (Food Orders)

For food delivery orders, a live Google Maps view shows the delivery partner's location pin moving towards the delivery address.

---

## 21. Order Success Screen

### Screen Layout

| Element | Description | Animation |
|---------|-------------|-----------|
| Background | Clean white / soft gradient | Static |
| Confetti Burst | Colourful confetti particles in Food orange and Clothing pink-red | Burst from top-centre using `confetti` package for 3 seconds |
| Success Lottie | Animated green checkmark expanding from a circle | Play-once Lottie, 200×200 |
| "Order Placed! 🎉" | Large bold heading | Fade in + scale up (delay 600ms) |
| Order Number | Grey subtitle with order reference number | Fade in (delay 800ms) |
| Confirmation Message | "We'll notify you when it ships" | Fade in (delay 900ms) |
| Track Order Button | Primary filled button | Slide up (delay 1000ms) |
| Continue Shopping | Text button | Fade in (delay 1100ms) |

### Haptic Feedback on Success

A strong haptic vibration (`HapticFeedback.heavyImpact`) is triggered at the moment the success animation plays to reinforce the positive action.

---

## 22. Reviews & Ratings Screen

### Product Reviews Screen

| Section | Description |
|---------|-------------|
| Rating Summary | Large average rating number + 5-star bar chart breakdown |
| Filter Chips | All / 5★ / 4★ / 3★ and below / With Photos / Verified Purchase |
| Sort Options | Most Recent / Most Helpful / Highest Rating / Lowest Rating |
| Review Cards | Reviewer name, rating stars, date, review body, review photos, Helpful count |
| Verified Badge | "Verified Purchase ✓" badge on eligible reviews |
| Vendor Response | Indented reply box below vendor-responded reviews |

### Write a Review Screen

| Element | Description |
|---------|-------------|
| Star Selector | Interactive 5-star rating with tap and slide support |
| Review Title | Short text field |
| Review Body | Multi-line text area |
| Add Photos | Grid of up to 5 photo upload slots |
| Submit Button | Disabled until rating and body are filled |

### Review Animations

| Element | Animation |
|---------|-----------|
| Star rating tap | Each star scales up and fills with yellow in sequence |
| Review cards | Stagger fade-in on list load |
| Helpful button tap | Thumb icon bounces + count increments with tick |

---

## 23. Notifications Screen

### Notification Types & Presentation

| Type | Icon | Example Content |
|------|------|----------------|
| Order Confirmed | ✅ Green bag | "Your order #12345 has been confirmed!" |
| Order Shipped | 🚚 Truck | "Your order is on the way!" |
| Out for Delivery | 📍 Pin | "Arriving in 10–15 minutes" |
| Order Delivered | 📦 Box | "Your order has been delivered. Rate us!" |
| Promo / Offer | 🏷️ Tag | "50% off on all food items today!" |
| Back in Stock | ⚡ Lightning | "Nike Air Max is back in stock — grab it now!" |

### Notification List Behaviour

- Unread notifications have a coloured left border indicator
- Tapping a notification marks it as read and navigates to the relevant screen
- "Mark All as Read" button at the top
- Notifications grouped by date (Today, Yesterday, This Week, Earlier)

---

## 24. Profile & Settings Screen

### Profile Screen Sections

| Section | Items |
|---------|-------|
| User Info | Avatar (editable), Name, Email, Phone |
| My Orders | Shortcut to order history |
| My Addresses | Manage saved addresses |
| Wishlist | Shortcut to wishlist |
| Notification Settings | Toggle each notification type |
| App Settings | Dark Mode toggle, Language, Default Category |
| Payment Methods | Saved cards and UPI IDs (if applicable) |
| Help & Support | FAQ, Chat support, Email us |
| About App | Version info, Privacy Policy, Terms of Service |
| Logout | With confirmation dialog |

### Settings Animations

| Element | Animation |
|---------|-----------|
| Dark mode toggle | Immediate theme switch with cross-fade transition |
| Category preference toggle | Pill switches between Food and Clothing |
| Logout confirmation | Dialog scales in from centre |

---

## 25. Shared UI Components

### Custom Button

| Variant | Usage |
|---------|-------|
| Primary Filled | Main CTAs (Add to Cart, Checkout, Login) |
| Secondary Outlined | Secondary CTAs (View Details, Skip) |
| Icon + Text | Actions with icon (Add Address, Upload Photo) |
| Loading State | Shows spinner inside the button while API call is in progress |
| Disabled State | Greyed out with reduced opacity |

### Product Card (Shared)

Both Food and Clothing share a base `ProductCard` widget. The variant is passed as a parameter to render the appropriate badge, fields, and colour scheme.

### Loading States

| State | Widget |
|-------|--------|
| Product list loading | `ProductCardSkeleton` using `Skeletonizer` |
| Order list loading | `OrderCardSkeleton` |
| Profile loading | `ProfileSkeleton` |
| General API loading | Circular progress indicator (themed per category) |

### Empty States

| Screen | Lottie / Illustration | Message |
|--------|----------------------|---------|
| Empty Cart | Shopping bag Lottie | "Your cart is empty. Start adding items!" |
| Empty Wishlist | Empty heart Lottie | "Nothing saved yet. Tap the heart on products you love." |
| Empty Orders | Box Lottie | "No orders yet. Place your first order!" |
| No Search Results | Search Lottie | "No results for '...'. Try different keywords." |
| No Notifications | Bell Lottie | "You're all caught up!" |

### Error States

| Error Type | Message | Action |
|-----------|---------|--------|
| No Internet | "You're offline. Check your connection." | Retry button |
| API Error (500) | "Something went wrong. Please try again." | Retry button |
| Not Found (404) | "This page doesn't exist." | Go Home button |
| Auth Expired | "Session expired. Please log in again." | Login redirect |

---

## 26. State Management Strategy

The app uses **Riverpod** for all state management. Every feature has its own set of providers.

### Provider Types Used

| Provider Type | Usage |
|---------------|-------|
| `StateProvider` | Simple values — active category, dark mode toggle |
| `FutureProvider` | Async data — product lists, order history |
| `StreamProvider` | Real-time data — notification count, cart badge |
| `StateNotifierProvider` | Complex state — cart, auth, checkout flow |
| `Provider` | Read-only derived state — formatted prices, filtered lists |

### Key Providers

| Provider | Description |
|----------|-------------|
| `authProvider` | Stores auth state (logged in, user data, tokens) |
| `activeCategoryProvider` | Current category — Food or Clothing |
| `themeProvider` | Current theme (light/dark + category) |
| `cartProvider` | Cart state with all items and totals |
| `wishlistProvider` | Wishlist state |
| `notificationCountProvider` | Unread notification count (used for badge) |
| `checkoutProvider` | Multi-step checkout state (address, coupon, order) |

---

## 27. API Integration Layer

### Dio Client Configuration

| Setting | Value |
|---------|-------|
| Base URL | Loaded from `.env` file per environment |
| Connection Timeout | 30 seconds |
| Receive Timeout | 30 seconds |
| Logging | Enabled in debug mode only |
| Retry on Failure | Up to 2 retries for network errors |

### Interceptors

| Interceptor | Description |
|------------|-------------|
| Auth Interceptor | Reads JWT from secure storage and attaches as `Authorization: Bearer` header on every request |
| Token Refresh Interceptor | On 401 response, auto-refreshes token and retries the failed request once |
| Error Interceptor | Converts error responses into typed `AppException` objects |
| Logging Interceptor | Logs request URL, method, status code in debug mode |

### Error Handling Strategy

| HTTP Status | App Behaviour |
|-------------|--------------|
| 400 (Bad Request) | Show field-level validation errors from API response |
| 401 (Unauthorized) | Auto-refresh token or redirect to login |
| 403 (Forbidden) | Show access denied message |
| 404 (Not Found) | Show not found screen |
| 422 (Validation Error) | Show per-field error messages in forms |
| 500 (Server Error) | Show generic retry screen |
| Network Error | Show offline banner with retry option |

---

## 28. Local Storage Strategy

| Data | Storage | Reason |
|------|---------|--------|
| JWT Access Token | Flutter Secure Storage | Encrypted, platform keystore |
| JWT Refresh Token | Flutter Secure Storage | Encrypted, platform keystore |
| User Profile (basic) | Hive | Fast access without API call |
| Active Category | Shared Preferences | Simple key-value, persists across restarts |
| Search History | Hive | List of recent queries |
| Dark Mode Preference | Shared Preferences | Simple boolean |
| Onboarding Completed | Shared Preferences | Boolean flag |
| Cached Product Lists | Hive | Offline browsing fallback (30 min TTL) |

---

## 29. Push Notification Handling

### Permission Request Strategy

- Push notification permission is requested after the user places their first order (not at app launch)
- If declined, a soft prompt is shown on the next order with an explanation of benefits
- Notification settings can be managed at any time from Profile > Notification Settings

### FCM Token Lifecycle

| Event | Action |
|-------|--------|
| App first launch | Generate FCM token and send to backend |
| App opens after token refresh | Send updated token to backend |
| User logs out | Disassociate token from user on backend |
| User logs in on new device | New token registered, old device token becomes orphaned |

### Notification Tap Behaviour

| Notification Type | Navigation Destination |
|------------------|----------------------|
| Order status update | Order detail screen for that order |
| Promo / Offer | Category home or product detail |
| Back in stock | Product detail for the restocked item |
| General | Notification list screen |

---

## 30. Security Measures

| Measure | Implementation |
|---------|----------------|
| Token Storage | JWT tokens stored in Flutter Secure Storage (AES encrypted, uses Keychain on iOS / Keystore on Android) |
| Biometric Auth | Optional fingerprint / Face ID lock for app re-entry (Profile setting) |
| Certificate Pinning | Backend SSL certificate pinned to prevent man-in-the-middle attacks |
| Payment Screen Protection | Screenshot and screen recording blocked on payment screens |
| Session Timeout | Auto-logout after 30 minutes of inactivity |
| Root / Jailbreak Detection | Warning shown if device is detected as rooted/jailbroken |
| Obfuscation | App code obfuscated in release builds via `--obfuscate` flag |

---

## 31. Performance Optimisation

| Optimisation | Method |
|-------------|--------|
| Image Loading | `cached_network_image` with memory and disk cache |
| Image Compression | S3 images served via CloudFront in WebP format |
| Lazy Loading | Products load in pages of 20 using infinite scroll |
| Widget Rebuild Minimisation | Riverpod's `select` used to only rebuild on relevant state changes |
| Large List Optimisation | `ListView.builder` and `SliverList` used for all lists |
| App Bundle Size | Unused libraries removed; tree-shaking enabled; split debug info |
| Build Cache | GitHub Actions caches Flutter SDK and pub packages |
| Startup Time | Minimise work in `main()` before runApp; defer non-critical init |

---

## 32. App Store Release Checklist

### Pre-Release Tasks

| Task | Platform |
|------|---------|
| Generate app icon (1024×1024 + all sizes) | Android + iOS |
| Configure native splash screen | Android + iOS |
| Set bundle ID / application ID | Android + iOS |
| Configure app signing keystore | Android |
| Configure provisioning profile and certificates | iOS |
| Set correct version name and version code | Both |
| Disable debug logs and debug banners | Both |
| Enable code obfuscation | Both |
| Test on physical device (Android + iPhone) | Both |
| Test all payment flows in production mode | Both |

### App Store Submissions

| Step | Google Play | Apple App Store |
|------|------------|----------------|
| Listing | Title, description, screenshots, feature graphic | Title, description, screenshots, preview video |
| Categories | Shopping | Shopping |
| Content Rating | Everyone / 4+ | 4+ |
| Privacy Policy URL | Required | Required |
| Review | 3–7 days | 1–3 days typically |

---

## 33. Testing Strategy

### Frontend Test Types

| Type | Tool | What Is Tested |
|------|------|----------------|
| Unit Tests | flutter_test | Providers, formatters, validators, utility functions |
| Widget Tests | flutter_test | Individual widget rendering and interaction |
| Integration Tests | integration_test | Full user flows — login, add to cart, checkout |
| Golden Tests | golden_toolkit | Visual screenshot regression testing |
| Accessibility Tests | flutter_test semantics | Screen reader labels, tap target sizes |
| Performance Tests | Flutter DevTools | Frame rendering time, jank detection |

### Critical Test Flows

| Flow | Test Scenarios |
|------|----------------|
| Authentication | Register → OTP → Login → Token refresh → Logout |
| Product Browsing | Browse food, browse clothing, filter, search |
| Cart Flow | Add item, change quantity, remove item, apply coupon |
| Checkout | Select address, review summary, proceed to payment |
| Order Tracking | View order history, open order detail, view tracking timeline |
| Reviews | View reviews, submit review, mark helpful |

### Coverage Targets

| Area | Target |
|------|--------|
| Business Logic (Providers) | 90% |
| Widget Tests | 80% |
| Integration Tests (critical flows) | 100% of critical paths |

---

## 34. Phase-wise Roadmap

| Phase | Weeks | Frontend Tasks |
|-------|-------|----------------|
| Phase 1 — Foundation | 1–2 | Flutter project setup, folder structure, Riverpod, Dio client, JWT storage, GoRouter, theme system, auth screens (Login/Register) |
| Phase 2 — Products | 3–4 | Home screen with category toggle, product grid with lazy loading, product detail with image carousel, filter bottom sheet, search with autocomplete, skeleton loading states |
| Phase 3 — Cart & Wishlist | 5 | Cart screen with swipe-to-remove, quantity controls, price breakdown, cart badge, wishlist screen, move-to-cart, empty states |
| Phase 4 — Checkout | 6–7 | Address management screens, multi-step checkout, order summary, coupon input, form validation, Google Places address search |
| Phase 5 — Payments | 7–8 | Razorpay/Stripe SDK integration, payment screen, success screen, failure screen with retry, transaction history |
| Phase 6 — Orders | 8–9 | Order history, order detail, animated tracking timeline, pull-to-refresh, reorder button, cancel order, invoice download |
| Phase 7 — Reviews | 9 | Reviews list, star rating widget, review submission form with photo upload, helpful button, review filters |
| Phase 8 — Recommendations | 10 | "For You" section on home, "You May Also Like" on product detail, "Frequently Bought Together" on cart, horizontal scroll widgets |
| Phase 9 — Notifications | 10–11 | FCM integration, permission request strategy, notification list screen, notification badge, tap-to-navigate handling, notification settings |
| Phase 10 — Admin/Vendor Mobile | 11–13 | Vendor dashboard, vendor product listing, vendor order management, inventory update screen, sales analytics |
| Phase 11 — Search & Performance | 13–14 | Advanced search UI, autocomplete, search history, image optimisation, infinite scroll tuning, app bundle size reduction |
| Phase 12 — Security | 14 | Certificate pinning, biometric auth, secure storage hardening, payment screen protection, session timeout |
| Phase 13 — Testing & QA | 15 | Widget tests, integration tests, golden tests, accessibility tests, UAT with real users |
| Phase 14 — Release | 15–16 | App icon and splash screen finalisation, signing configuration, release builds, Play Store and App Store submissions, Crashlytics, Firebase Analytics |
| Phase 15 — Post Launch | 16+ | User feedback collection, crash fixing, feature iterations, A/B testing, performance monitoring |

---

## 🎯 Frontend Success Metrics

| Metric | Target |
|--------|--------|
| App Launch Time | < 3 seconds on mid-range device |
| Screen Transition Time | < 300ms |
| Image Load Time | < 1 second (cached), < 2 seconds (fresh) |
| Animation Frame Rate | Consistent 60fps on modern devices |
| Crash-Free Session Rate | > 99% |
| App Size — Android APK | < 30 MB |
| App Size — iOS IPA | < 40 MB |
| Accessibility Score | WCAG AA compliant |

---

*Frontend Guide Version 1.0.0 | Last Updated: February 2026 | Status: Production Ready*
