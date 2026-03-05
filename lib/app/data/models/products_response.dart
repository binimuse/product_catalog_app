import 'package:json_annotation/json_annotation.dart';

import 'product.dart';

part 'products_response.g.dart';

@JsonSerializable()
class ProductsResponse {
  final List<Product> products;
  final int total;
  final int skip;
  final int limit;

  const ProductsResponse({
    required this.products,
    required this.total,
    required this.skip,
    required this.limit,
  });

  factory ProductsResponse.fromJson(Map<String, dynamic> json) =>
      _$ProductsResponseFromJson(json);
  Map<String, dynamic> toJson() => _$ProductsResponseToJson(this);

  bool get hasMore => skip + products.length < total;
  int get nextSkip => skip + products.length;
}
