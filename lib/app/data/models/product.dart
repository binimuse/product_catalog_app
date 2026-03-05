import 'dart:developer' as developer;

import 'package:json_annotation/json_annotation.dart';

part 'product.g.dart';

@JsonSerializable()
class Product {
  final int id;
  final String title;
  final String description;
  final double price;
  @JsonKey(name: 'discountPercentage')
  final double discountPercentage;
  final double rating;
  final int stock;
  final String brand;
  final String category;
  final String? thumbnail;
  @JsonKey(name: 'images')
  final List<String>? images;

  const Product({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.discountPercentage,
    required this.rating,
    required this.stock,
    required this.brand,
    required this.category,
    this.thumbnail,
    this.images,
  });

  factory Product.fromJson(Map<String, dynamic> json) => _$ProductFromJson(json);
  Map<String, dynamic> toJson() => _$ProductToJson(this);

  /// Safe display price - handles missing/negative values
  String get displayPrice {
    if (price < 0 || price.isNaN) {
      developer.log('Invalid price for product $id: $price', name: 'Product');
      return 'Price unavailable';
    }
    return '\$${price.toStringAsFixed(2)}';
  }

  /// Original price formatted
  double? get discountedPrice {
    if (price < 0 || discountPercentage < 0 || discountPercentage > 100) return null;
    return price - (price * discountPercentage / 100);
  }

  /// Primary image URL - validates before use
  String? get primaryImageUrl {
    final url = thumbnail ?? (images != null && images!.isNotEmpty ? images!.first : null);
    if (url == null || url.isEmpty) {
      developer.log('Missing image URL for product $id', name: 'Product');
      return null;
    }
    return url;
  }

  /// Safe brand display
  String get displayBrand => brand.isEmpty ? 'Unknown brand' : brand;

  /// Safe category display
  String get displayCategory => category.isEmpty ? 'Uncategorized' : category;
}
