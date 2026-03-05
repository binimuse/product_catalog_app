import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../design_system/components/app_search_bar.dart';
import '../../../design_system/components/category_chip.dart';
import '../../../design_system/components/empty_state.dart';
import '../../../design_system/components/error_state.dart';
import '../../../design_system/components/product_card.dart';
import '../../../design_system/components/product_card_skeleton.dart';
import '../../../design_system/theme/app_colors.dart';
import '../../../data/models/product.dart';

/// Component showcase - displays all design system components (Enhancement A)
class ShowcaseScreen extends StatefulWidget {
  const ShowcaseScreen({super.key});

  @override
  State<ShowcaseScreen> createState() => _ShowcaseScreenState();
}

class _ShowcaseScreenState extends State<ShowcaseScreen> {
  static Product get _sampleProduct => Product(
        id: 1,
        title: 'Sample Product',
        description: 'A sample product for showcase.',
        price: 99.99,
        discountPercentage: 15,
        rating: 4.5,
        stock: 10,
        brand: 'SampleBrand',
        category: 'electronics',
        thumbnail: 'https://cdn.dummyjson.com/product-images/1/thumbnail.jpg',
        images: const [],
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Component Showcase'),
          actions: [
            IconButton(
              icon: Icon(Get.isDarkMode ? Icons.light_mode : Icons.dark_mode),
              onPressed: () {
                Get.changeThemeMode(Get.isDarkMode ? ThemeMode.light : ThemeMode.dark);
                setState(() {});
              },
            ),
          ],
        ),
        body: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            _Section(
              title: 'Theme Toggle',
              child: Row(
                children: [
                  ChoiceChip(
                    label: const Text('Light'),
                    selected: !Get.isDarkMode,
                    onSelected: (_) {
                      Get.changeThemeMode(ThemeMode.light);
                      setState(() {});
                    },
                  ),
                  const SizedBox(width: 8),
                  ChoiceChip(
                    label: const Text('Dark'),
                    selected: Get.isDarkMode,
                    onSelected: (_) {
                      Get.changeThemeMode(ThemeMode.dark);
                      setState(() {});
                    },
                  ),
                ],
              ),
            ),
            _Section(
              title: 'AppSearchBar',
              child: const AppSearchBar(hint: 'Search...', onChanged: null),
            ),
            _Section(
              title: 'CategoryChip',
              child: Wrap(
                spacing: 8,
                children: [
                  CategoryChip(label: 'All', selected: true, onTap: () {}),
                  CategoryChip(label: 'Electronics', selected: false, onTap: () {}),
                  CategoryChip(label: 'Fashion', selected: false, onTap: () {}),
                ],
              ),
            ),
            _Section(
              title: 'ProductCard',
              child: ProductCard(product: _sampleProduct, onTap: () {}),
            ),
            _Section(
              title: 'ProductCardSkeleton',
              child: const ProductCardSkeleton(),
            ),
            _Section(
              title: 'ErrorState',
              child: SizedBox(
                height: 200,
                child: ErrorState(
                  message: 'Something went wrong.',
                  onRetry: () {},
                ),
              ),
            ),
            _Section(
              title: 'EmptyState',
              child: SizedBox(
                height: 200,
                child: EmptyState(
                  title: 'No results',
                  message: 'Try different filters.',
                ),
              ),
            ),
          ],
        ),
    );
  }
}

class _Section extends StatelessWidget {
  const _Section({required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
          ),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }
}
