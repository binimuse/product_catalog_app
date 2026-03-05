# Product Catalog App

A Flutter application that displays a product catalog from the DummyJSON API, with a custom design system, responsive master-detail layout, and GetX state management.

## Setup & Run Instructions

**Requirements:**
- Flutter 3.x (stable) — tested with Flutter 3.24+
- Dart 3.11+

**Steps:**
```bash
# Clone and navigate to project
cd product_catalog_app

# Install dependencies
flutter pub get

# Run (choose your target)
flutter run          # default device
flutter run -d chrome
flutter run -d android
```

## Architecture Overview

### Folder Structure
```
lib/
├── app/
│   └── router/
│       └── app_pages.dart      # Centralized GetX routing
├── core/
│   └── constants/
│       └── breakpoints.dart    # Responsive breakpoints (768px)
├── data/
│   ├── api/
│   │   ├── products_api.dart   # Retrofit API interface
│   │   └── products_api.g.dart
│   ├── models/
│   │   ├── product.dart
│   │   ├── products_response.dart
│   │   └── *.g.dart
│   └── repository/
│       └── products_repository.dart
├── design_system/
│   ├── components/
│   │   ├── app_search_bar.dart
│   │   ├── category_chip.dart
│   │   ├── empty_state.dart
│   │   ├── error_state.dart
│   │   ├── product_card.dart
│   │   └── product_card_skeleton.dart
│   └── theme/
│       ├── app_colors.dart
│       └── app_theme.dart
├── features/
│   └── products/
│       ├── controllers/        # GetX controllers
│       ├── screens/
│       └── showcase/           # Component showcase (optional)
└── main.dart
```

### State Management
- **GetX** with reactive `.obs` for products, categories, loading, and error states
- Controllers (`ProductListController`, `ProductDetailController`) separate business logic from UI
- Predictable states: initial, loading, loaded, error, empty

### Key Decisions
- **Retrofit + Dio** for type-safe API calls
- **GetX** chosen over Bloc per team preference; GetX routing for simplicity
- **Master-detail** on tablet (≥768px) via `_ProductsWrapper` that switches layout
- **Categories API** parses new DummyJSON format `[{slug, name, url}]` to slug strings

## Design System Rationale

- **Colors**: Indigo primary, cyan accent; separate light/dark palettes in `AppColors`
- **Components**: Themed via `Theme.of(context)` so light/dark mode works automatically
- **AppSearchBar**: Debounced (400ms) to reduce API calls
- **ProductCard**: Compact list layout with thumbnail, price, rating
- **Placeholders**: Shimmer for loading; generic icon for missing images

## Enhancements

- **Component Showcase** (Enhancement A): Tap the palette icon in the product list header to open `/showcase` — displays all design system components with light/dark theme toggle
- **Pull-to-refresh** on product list
- **Unit tests**: Product model (parsing, validation)
- **Widget tests**: CategoryChip, ErrorState

## Limitations

- **Navigation**: Uses GetX routing instead of GoRouter (per team preference)
- **Categories**: DummyJSON now returns objects; we parse `slug` for filter chips
- **Search + Category**: When both are set, search runs server-side and results are filtered client-side (API has no combined endpoint)
- **Tests**: Basic coverage; more integration tests would improve confidence
- **Offline**: Not implemented; would use Hive or Drift for local cache

## AI Tools Usage

- Used AI for initial scaffold, Retrofit setup, and design system structure
- Refined: baseUrl handling (Dio was using relative paths), categories API parsing for new format
- Manual: error handling, responsive layout logic, component APIs
