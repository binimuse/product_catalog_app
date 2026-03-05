import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:product_catalog_test_app/app/data/models/product.dart';
import 'package:product_catalog_test_app/app/data/repository/products_repository.dart';

 

class ProductListController extends GetxController {
  ProductListController(this._repository);

  final ProductsRepository _repository;
  static const int _pageSize = 20;

  final products = <Product>[].obs;
  final categories = <String>[].obs;
  final isLoading = true.obs;
  final isLoadingMore = false.obs;
  final hasMore = false.obs;
  final searchQuery = ''.obs;
  final selectedCategory = Rxn<String>();
  final errorMessage = Rxn<String>();

  @override
  void onInit() {
    super.onInit();
    loadProducts();
  }

  Future<void> loadProducts() async {
    isLoading.value = true;
    errorMessage.value = null;
    try {
      final cats = await _repository.getCategories();
      final response = await _repository.fetchProducts(
        searchQuery: null,
        category: null,
        limit: _pageSize,
        skip: 0,
      );
      categories.value = cats;
      products.value = response.products;
      hasMore.value = response.hasMore;
      searchQuery.value = '';
      selectedCategory.value = null;
    } catch (e, stackTrace) {
      errorMessage.value = e.toString();
      debugPrint('ProductListController.loadProducts error: $e');
      debugPrint(stackTrace.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loadMore() async {
    if (isLoadingMore.value || !hasMore.value) return;

    isLoadingMore.value = true;
    try {
      final response = await _repository.fetchProducts(
        searchQuery: searchQuery.value.isEmpty ? null : searchQuery.value,
        category: selectedCategory.value,
        limit: _pageSize,
        skip: products.length,
      );
      products.addAll(response.products);
      hasMore.value = response.hasMore;
    } catch (e, stackTrace) {
      errorMessage.value = e.toString();
      debugPrint('ProductListController.loadProducts error: $e');
      debugPrint(stackTrace.toString());
    } finally {
      isLoadingMore.value = false;
    }
  }

  Future<void> search(String query) async {
    searchQuery.value = query;
    isLoading.value = true;
    errorMessage.value = null;
    try {
      final response = await _repository.fetchProducts(
        searchQuery: query.isEmpty ? null : query,
        category: selectedCategory.value,
        limit: _pageSize,
        skip: 0,
      );
      products.value = response.products;
      hasMore.value = response.hasMore;
    } catch (e, stackTrace) {
      errorMessage.value = e.toString();
      debugPrint('ProductListController.loadProducts error: $e');
      debugPrint(stackTrace.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> selectCategory(String? category) async {
    if (category == selectedCategory.value) {
      selectedCategory.value = null;
    } else {
      selectedCategory.value = category;
    }
    isLoading.value = true;
    errorMessage.value = null;
    try {
      final response = await _repository.fetchProducts(
        searchQuery: searchQuery.value.isEmpty ? null : searchQuery.value,
        category: selectedCategory.value,
        limit: _pageSize,
        skip: 0,
      );
      products.value = response.products;
      hasMore.value = response.hasMore;
    } catch (e, stackTrace) {
      errorMessage.value = e.toString();
      debugPrint('ProductListController.loadProducts error: $e');
      debugPrint(stackTrace.toString());
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void refresh() => loadProducts();
}
