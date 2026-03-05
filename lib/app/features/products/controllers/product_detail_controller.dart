import 'package:get/get.dart';
import 'package:product_catalog_test_app/app/data/models/product.dart';
import 'package:product_catalog_test_app/app/data/repository/products_repository.dart';


class ProductDetailController extends GetxController {
  ProductDetailController(this._repository, this.productId);

  final ProductsRepository _repository;
  final int productId;

  final product = Rxn<Product>();
  final isLoading = true.obs;
  final errorMessage = Rxn<String>();

  @override
  void onInit() {
    super.onInit();
    loadProduct();
  }

  Future<void> loadProduct() async {
    isLoading.value = true;
    errorMessage.value = null;
    try {
      product.value = await _repository.getProductById(productId);
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  void retry() => loadProduct();
}
