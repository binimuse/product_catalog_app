import 'package:flutter_test/flutter_test.dart';
import 'package:product_catalog_test_app/app/data/models/product.dart';

void main() {
  group('Product model', () {
    test('parses valid JSON correctly', () {
      final json = {
        'id': 1,
        'title': 'Test Product',
        'description': 'A test product',
        'price': 99.99,
        'discountPercentage': 10,
        'rating': 4.5,
        'stock': 50,
        'brand': 'TestBrand',
        'category': 'electronics',
        'thumbnail': 'https://example.com/thumb.jpg',
        'images': ['https://example.com/1.jpg'],
      };
      final product = Product.fromJson(json);
      expect(product.id, 1);
      expect(product.title, 'Test Product');
      expect(product.price, 99.99);
      expect(product.displayPrice, '\$99.99');
      expect(product.displayBrand, 'TestBrand');
      expect(product.primaryImageUrl, 'https://example.com/thumb.jpg');
    });

    test('handles missing brand with default', () {
      final json = {
        'id': 1,
        'title': 'Product',
        'description': '',
        'price': 10,
        'discountPercentage': 0,
        'rating': 0,
        'stock': 0,
        'brand': '',
        'category': '',
      };
      final product = Product.fromJson(json);
      expect(product.displayBrand, 'Unknown brand');
    });

    test('displays price unavailable for invalid price', () {
      final json = {
        'id': 1,
        'title': 'Product',
        'description': '',
        'price': -5,
        'discountPercentage': 0,
        'rating': 0,
        'stock': 0,
        'brand': 'Brand',
        'category': 'cat',
      };
      final product = Product.fromJson(json);
      expect(product.displayPrice, 'Price unavailable');
    });

    test('returns null for primaryImageUrl when missing', () {
      final json = {
        'id': 1,
        'title': 'Product',
        'description': '',
        'price': 10,
        'discountPercentage': 0,
        'rating': 0,
        'stock': 0,
        'brand': 'B',
        'category': 'c',
        'thumbnail': null,
        'images': null,
      };
      final product = Product.fromJson(json);
      expect(product.primaryImageUrl, isNull);
    });
  });
}
