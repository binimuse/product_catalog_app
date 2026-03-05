import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../data/models/product.dart';
import '../../../data/repository/products_repository.dart';
import '../../../design_system/components/error_state.dart';
import '../../../design_system/theme/app_colors.dart';
import '../controllers/product_detail_controller.dart';

class ProductDetailScreen extends StatelessWidget {
  const ProductDetailScreen({
    super.key,
    required this.productId,
  });

  final int productId;

  @override
  Widget build(BuildContext context) {
    Get.put(
      ProductDetailController(Get.find<ProductsRepository>(), productId),
      tag: 'detail_$productId',
    );
    return _ProductDetailView(productId: productId);
  }
}

class _ProductDetailView extends StatelessWidget {
  const _ProductDetailView({required this.productId});
  final int productId;

  ProductDetailController get _controller =>
      Get.find<ProductDetailController>(tag: 'detail_$productId');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() {
        if (_controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        if (_controller.errorMessage.value != null) {
          return ErrorState(
            message: 'Failed to load product.',
            onRetry: _controller.retry,
          );
        }
        final p = _controller.product.value;
        if (p == null) return const SizedBox.shrink();

        return CustomScrollView(
          slivers: [
            SliverAppBar(
              expandedHeight: 300,
              pinned: true,
              flexibleSpace: FlexibleSpaceBar(
                background: _ImageGallery(product: p),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      p.displayBrand,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      p.title,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 16),
                    _PriceSection(product: p),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        _RatingChip(rating: p.rating),
                        const SizedBox(width: 12),
                        _StockChip(stock: p.stock),
                        const SizedBox(width: 12),
                        _CategoryChip(category: p.displayCategory),
                      ],
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'Description',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      p.description,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      }),
    );
  }
}

class _ImageGallery extends StatelessWidget {
  const _ImageGallery({required this.product});

  final Product product;

  @override
  Widget build(BuildContext context) {
    final images = [
      if (product.thumbnail != null && product.thumbnail!.isNotEmpty)
        product.thumbnail!,
      ...?product.images,
    ].where((u) => u.isNotEmpty).toList();
    if (images.isEmpty) {
      return Container(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        child: Icon(
          Icons.image_not_supported_outlined,
          size: 64,
          color: Theme.of(context).colorScheme.onSurfaceVariant,
        ),
      );
    }
    return PageView.builder(
      itemCount: images.length,
      itemBuilder: (context, index) {
        final url = images[index];
        if (url.isEmpty) return _placeholder(context);
        return CachedNetworkImage(
          imageUrl: url,
          fit: BoxFit.cover,
          placeholder: (_, __) => _placeholder(context),
          errorWidget: (_, __, ___) => _placeholder(context),
        );
      },
    );
  }

  Widget _placeholder(BuildContext context) => Container(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        child: Icon(
          Icons.image_not_supported_outlined,
          size: 48,
          color: Theme.of(context).colorScheme.onSurfaceVariant,
        ),
      );
}

class _PriceSection extends StatelessWidget {
  const _PriceSection({required this.product});

  final Product product;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          product.displayPrice,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.bold,
              ),
        ),
        if (product.discountedPrice != null) ...[
          const SizedBox(width: 12),
          Text(
            '\$${product.discountedPrice!.toStringAsFixed(2)}',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  decoration: TextDecoration.lineThrough,
                ),
          ),
          if (product.discountPercentage > 0) ...[
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.success.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                '-${product.discountPercentage.toStringAsFixed(0)}%',
                style: const TextStyle(
                  color: AppColors.success,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ],
      ],
    );
  }
}

class _RatingChip extends StatelessWidget {
  const _RatingChip({required this.rating});
  final double rating;

  @override
  Widget build(BuildContext context) {
    return Chip(
      avatar: Icon(Icons.star_rounded, size: 18, color: AppColors.warning),
      label: Text(rating.toStringAsFixed(1)),
    );
  }
}

class _StockChip extends StatelessWidget {
  const _StockChip({required this.stock});
  final int stock;

  @override
  Widget build(BuildContext context) {
    return Chip(
      avatar: Icon(
        stock > 0 ? Icons.check_circle : Icons.cancel,
        size: 18,
        color: stock > 0 ? AppColors.success : AppColors.error,
      ),
      label: Text(stock > 0 ? 'In stock ($stock)' : 'Out of stock'),
    );
  }
}

class _CategoryChip extends StatelessWidget {
  const _CategoryChip({required this.category});
  final String category;

  @override
  Widget build(BuildContext context) {
    return Chip(label: Text(category));
  }
}
