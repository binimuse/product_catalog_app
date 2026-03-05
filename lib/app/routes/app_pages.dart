import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../core/constants/breakpoints.dart';
import '../features/products/screens/product_detail_screen.dart';
import '../features/products/screens/product_list_screen.dart';
import '../features/products/showcase/showcase_screen.dart';

abstract class AppPages {
  AppPages._();

  static const products = '/products';
  static const productDetail = '/products/:id';
  static const showcase = '/showcase';

  static final routes = [
    GetPage(
      name: products,
      page: () => const _ProductsWrapper(),
    ),
    GetPage(
      name: productDetail,
      page: () {
        final id = int.tryParse(Get.parameters['id'] ?? '0') ?? 0;
        final isTablet = MediaQuery.of(Get.context!).size.width >= Breakpoints.tablet;
        if (isTablet) {
          return _ProductsWrapper(selectedId: id);
        }
        return ProductDetailScreen(productId: id);
      },
    ),
    GetPage(
      name: showcase,
      page: () => const ShowcaseScreen(),
    ),
  ];
}

class _ProductsWrapper extends StatelessWidget {
  const _ProductsWrapper({this.selectedId});
  final int? selectedId;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final isTablet = width >= Breakpoints.tablet;

    if (isTablet) {
      final id = selectedId ?? (Get.parameters['id'] != null ? int.tryParse(Get.parameters['id']!) : null);

      return Row(
        children: [
          SizedBox(
            width: 380,
            child: ProductListScreen(
              onProductTap: (id) => Get.offNamed('/products/$id'),
              selectedProductId: id,
            ),
          ),
          Expanded(
            child: id != null
                ? ProductDetailScreen(productId: id)
                : const _DetailPlaceholder(),
          ),
        ],
      );
    }

    return const ProductListScreen();
  }
}

class _DetailPlaceholder extends StatelessWidget {
  const _DetailPlaceholder();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.touch_app_rounded,
            size: 80,
            color: Theme.of(context).colorScheme.onSurfaceVariant.withValues(alpha: 0.4),
          ),
          const SizedBox(height: 24),
          Text(
            'Select a product',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            'Choose a product from the list to view details',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant.withValues(alpha: 0.7),
                ),
          ),
        ],
      ),
    );
  }
}
