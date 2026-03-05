import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../models/product.dart';
import '../models/products_response.dart';

part 'products_api.g.dart';

@RestApi(baseUrl: 'https://dummyjson.com')
abstract class ProductsApi {
  factory ProductsApi(Dio dio, {String baseUrl}) = _ProductsApi;

  @GET('/products')
  Future<ProductsResponse> getProducts(
    @Queries() Map<String, dynamic> queries,
  );

  @GET('/products/search')
  Future<ProductsResponse> searchProducts(
    @Queries() Map<String, dynamic> queries,
  );

  @GET('/products/categories')
  Future<List<String>> getCategories();

  @GET('/products/category/{category}')
  Future<ProductsResponse> getProductsByCategory(
    @Path('category') String category,
    @Queries() Map<String, dynamic>? queries,
  );

  @GET('/products/{id}')
  Future<Product> getProductById(@Path('id') int id);
}
