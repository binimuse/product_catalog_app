import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../data/repository/products_repository.dart';
import '../../../design_system/components/app_search_bar.dart';
import '../../../design_system/components/category_chip.dart';
import '../../../design_system/components/empty_state.dart';
import '../../../design_system/components/error_state.dart';
import '../../../design_system/components/product_card.dart';
import '../../../design_system/components/product_card_skeleton.dart';
import '../controllers/product_list_controller.dart';

class ProductListScreen extends StatefulWidget {
  const ProductListScreen({
    super.key,
    this.onProductTap,
    this.selectedProductId,
  });

  final void Function(int id)? onProductTap;
  final int? selectedProductId;

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  final _scrollController = ScrollController();
  final _searchController = TextEditingController();
  late final ProductListController _controller;

  @override
  void initState() {
    super.initState();
    _controller = Get.put(
      ProductListController(Get.find<ProductsRepository>()),
      permanent: true,
    );
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      _controller.loadMore();
    }
  }

  void _navigateToProduct(int id) {
    if (widget.onProductTap != null) {
      widget.onProductTap!(id);
    } else {
      Get.toNamed('/products/$id');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          controller: _scrollController,
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Product Catalog',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 16),
                    AppSearchBar(
                      controller: _searchController,
                      onChanged: _controller.search,
                    ),
                  ],
                ),
              ),
            ),
            Obx(() {
              if (_controller.errorMessage.value != null) {
                return SliverFillRemaining(
                  child: ErrorState(
                    message: _controller.errorMessage.value ?? 'Failed to load products.',
                    onRetry: _controller.loadProducts,
                  ),
                );
              }
              if (_controller.isLoading.value) {
                return _buildSkeletonList();
              }
              if (_controller.products.isEmpty) {
                return const SliverFillRemaining(
                  child: EmptyState(
                    title: 'No products found',
                    message: 'Try adjusting your search or filters.',
                  ),
                );
              }
              return SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      if (index == 0) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (_controller.categories.isNotEmpty) ...[
                              SizedBox(
                                height: 44,
                                child: ListView(
                                  scrollDirection: Axis.horizontal,
                                  children: [
                                    CategoryChip(
                                      label: 'All',
                                      selected: _controller.selectedCategory.value == null,
                                      onTap: () => _controller.selectCategory(null),
                                    ),
                                    ..._controller.categories
                                        .map(
                                          (c) => CategoryChip(
                                            label: c,
                                            selected: _controller.selectedCategory.value == c,
                                            onTap: () => _controller.selectCategory(c),
                                          ),
                                        ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 12),
                            ],
                            ProductCard(
                              product: _controller.products[0],
                              onTap: () => _navigateToProduct(_controller.products[0].id),
                            ),
                          ],
                        );
                      }
                      if (index < _controller.products.length) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: ProductCard(
                            product: _controller.products[index],
                            onTap: () =>
                                _navigateToProduct(_controller.products[index].id),
                          ),
                        );
                      }
                      if (_controller.isLoadingMore.value) {
                        return const Padding(
                          padding: EdgeInsets.all(24),
                          child: Center(child: CircularProgressIndicator()),
                        );
                      }
                      return null;
                    },
                    childCount: _controller.products.length +
                        (_controller.isLoadingMore.value ? 1 : 0),
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildSkeletonList() {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) => const Padding(
            padding: EdgeInsets.only(bottom: 8),
            child: ProductCardSkeleton(),
          ),
          childCount: 8,
        ),
      ),
    );
  }
}
