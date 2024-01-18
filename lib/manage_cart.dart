import 'package:shared_preferences/shared_preferences.dart';

class ManageCart {
  final String cartKey = 'cartProducts';

  Future<String> addProductToCart(int productId) async {
    List<int> cartProducts = await _getCartProducts();
    if (cartProducts.contains(productId)) {
      return 'Product already exists in the cart';
    }
    cartProducts.add(productId);
    await _saveCartProducts(cartProducts);
    return 'Product added to the cart successfully';
  }

  Future<String> removeProductFromCart(int productId) async {
    List<int> cartProducts = await _getCartProducts();
    if (cartProducts.contains(productId)) {
      cartProducts.remove(productId);
      await _saveCartProducts(cartProducts);
      return 'Product Deleted Successfully.';
    } else {
      return 'Product is not exist';
    }
  }

  Future<int> countCartProduct() async {
    List<int> cartProducts = await _getCartProducts();
    return cartProducts.length;
  }

  Future<List<int>> getCartList() async {
    List<int> cartProducts = await _getCartProducts();
    return cartProducts;
  }

  Future<List<int>> _getCartProducts() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? cartProductsString = prefs.getStringList(cartKey);
    List<int> cartProducts =
        cartProductsString?.map((id) => int.parse(id)).toList() ?? [];
    return cartProducts;
  }

  Future<void> _saveCartProducts(List<int> cartProducts) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> cartProductsString =
        cartProducts.map((id) => id.toString()).toList();
    prefs.setStringList(cartKey, cartProductsString);
  }
}
