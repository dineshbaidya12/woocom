import 'package:woocommerce/pages/homepage.dart';
import 'package:woocommerce_api/woocommerce_api.dart';

class APIWorks {
  final String baseUrl = 'http://dinesh/woocom';
  final String consumerKey = 'ck_b19054371ef70980d1e72c916270533e8d85e267';
  final String consumerSecret = 'cs_ffd3db8003cc760c9025c5da768659342d1c1f09';

  late WooCommerceAPI wooCommerce;

  APIWorks() {
    wooCommerce = WooCommerceAPI(
      url: baseUrl,
      consumerKey: consumerKey,
      consumerSecret: consumerSecret,
    );
  }
  fetchProductsJson({int? page, int? perPage}) async {
    try {
      dynamic productsJson;

      if (page != null && perPage != null) {
        productsJson =
            await wooCommerce.getAsync('products?page=$page&per_page=$perPage');
      } else {
        productsJson = await wooCommerce.getAsync('products');
      }

      return productsJson;
    } catch (e) {
      throw Exception('Failed to load products: $e');
    }
  }

  Future<List<Product>> fetchProducts({int? page, int? perPage}) async {
    try {
      dynamic productsJson;

      if (page != null && perPage != null) {
        productsJson =
            await wooCommerce.getAsync('products?page=$page&per_page=$perPage');
      } else {
        productsJson = await wooCommerce.getAsync('products');
      }

      List<Product> productList = (productsJson as List<dynamic>)
          .map((json) => Product.fromJson(json as Map<String, dynamic>))
          .toList();

      print('${productList.length} products loaded.');
      return productList;
    } catch (e) {
      throw Exception('Failed to load products: $e');
    }
  }

  Future<List<FeaturedProduct>> fetchFeaturedProducts() async {
    try {
      final productsJson = await wooCommerce.getAsync('products');
      List<FeaturedProduct> productList = (productsJson as List<dynamic>)
          .where((product) => product['featured'] == true)
          .map((json) => FeaturedProduct.fromJson(json as Map<String, dynamic>))
          .toList();
      return productList;
    } catch (e) {
      throw Exception('Failed to load products: $e');
    }
  }

  Future<List<Category>> fetchCategory() async {
    try {
      final categoryJson = await wooCommerce.getAsync('products/categories');
      List<Category> categoryList = (categoryJson as List<dynamic>)
          .map((json) => Category.fromJson(json as Map<String, dynamic>))
          .where((category) => category.parent == 0)
          .where((category) => category.name != "Uncategorized")
          .toList();
      return categoryList;
    } catch (e) {
      throw Exception('Failed to load Category: $e');
    }
  }
}
