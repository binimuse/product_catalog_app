import 'package:dio/dio.dart';

import '../api/products_api.dart';
import '../models/product.dart';
import '../models/products_response.dart';

class ProductsRepository {
  static const String _baseUrl = 'https://dummyjson.com';

  ProductsRepository({Dio? dio}) {
    _dio = dio ?? Dio()
      ..options.baseUrl = _baseUrl
      ..options.connectTimeout = const Duration(seconds: 15);
    _api = ProductsApi(_dio, baseUrl: _baseUrl);
  }

  late final Dio _dio;
  late final ProductsApi _api;

  Future<ProductsResponse> getProducts({int limit = 20, int skip = 0}) =>
      _api.getProducts({'limit': limit, 'skip': skip});

  Future<ProductsResponse> searchProducts(String query, {int limit = 20, int skip = 0}) =>
      _api.searchProducts({'q': query, 'limit': limit, 'skip': skip});

  /// DummyJSON categories API returns [{slug, name, url}]. Parse slug for filter.
  Future<List<String>> getCategories() async {
    final response = await _dio.get<List<dynamic>>('$_baseUrl/products/categories');
    final list = response.data ?? [];
    return list.map((e) {
      if (e is Map && e.containsKey('slug')) return (e['slug'] as String?) ?? '';
      if (e is Map && e.containsKey('name')) return (e['name'] as String?) ?? '';
      return e?.toString() ?? '';
    }).where((s) => s.isNotEmpty).toList();
  }

  Future<ProductsResponse> getProductsByCategory(
    String category, {
    int limit = 20,
    int skip = 0,
  }) =>
      _api.getProductsByCategory(category, {'limit': limit, 'skip': skip});

  Future<Product> getProductById(int id) => _api.getProductById(id);

  /// Combined fetch: search within category or fetch by category or fetch all
  Future<ProductsResponse> fetchProducts({
    String? searchQuery,
    String? category,
    int limit = 20,
    int skip = 0,
  }) async {
    if (searchQuery != null && searchQuery.isNotEmpty) {
      final response = await _api.searchProducts({
        'q': searchQuery,
        'limit': limit,
        'skip': skip,
      });
      var products = response.products;
      if (category != null && category.isNotEmpty) {
        products = products.where((p) => p.category == category).toList();
      }
      return ProductsResponse(
        products: products,
        total: products.length,
        skip: skip,
        limit: limit,
      );
    }
    if (category != null && category.isNotEmpty) {
      return _api.getProductsByCategory(category, {'limit': limit, 'skip': skip});
    }
    return _api.getProducts({'limit': limit, 'skip': skip});
  }
}
