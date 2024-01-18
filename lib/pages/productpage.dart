// ignore_for_file: prefer_const_constructors, use_key_in_widget_constructors, avoid_print, avoid_unnecessary_containers, prefer_const_literals_to_create_immutables, unused_local_variable, unnecessary_cast, unnecessary_null_comparison, sized_box_for_whitespace, unused_element

import 'package:flutter/material.dart';
import 'package:woocommerce/manage_cart.dart';
import 'package:woocommerce/pages/homepage.dart';
import 'package:woocommerce/helper/APIwork.dart';
import 'package:woocommerce/styles/button-styles.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';

class ProductScreen extends StatefulWidget {
  final int productId;
  final Function(int)? updateCartCountCallback;
  const ProductScreen({required this.productId, this.updateCartCountCallback});

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  List product = [];
  void productList;
  final APIWorks apiWorks = APIWorks();
  bool isLoaded = false;
  int cartItemsCount = 0;
  ManageCart cart = ManageCart();

  @override
  void initState() {
    super.initState();
    __getCartProducts();
    _fetchProductDetails(widget.productId);
  }

  Future<void> _fetchProductDetails(productId) async {
    final json =
        await apiWorks.fetchProductDetails(productId) as Map<String, dynamic>;
    final productDetails = json;
    setState(() {
      product = [productDetails];
      isLoaded = true;
    });
  }

  __getCartProducts() async {
    int cartItems = await cart.countCartProduct();
    setState(() {
      cartItemsCount = cartItems;
    });
  }

  updateCartCount(count) async {
    setState(() {
      cartItemsCount = count;
    });
    widget.updateCartCountCallback!(count);
  }

  Future<void> __addTheProductToCart(context, int productId) async {
    ManageCart cart = ManageCart();
    ProductScreen productScreen = ProductScreen(productId: productId);
    final add = await cart.addProductToCart(productId);
    if (add == 'Product already exists in the cart') {
      _showAlertDialog(context, 'Warning', add);
    } else {
      _showAlertDialog(context, 'Success', 'Product added to the cart');
    }
    final productCount = await cart.countCartProduct();
    setState(() {
      cartItemsCount = productCount;
    });
  }

  @override
  Widget build(BuildContext context) {
    final int productId = widget.productId;
    return Scaffold(
      appBar: screenAppBar(cartItemsCount, context),
      body: !isLoaded
          ? SafeArea(
              child: Center(
                child: SizedBox(
                  height: 50,
                  width: 50,
                  child: CircularProgressIndicator(),
                ),
              ),
            )
          : SingleChildScrollView(
              child: SafeArea(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    product[0]['images'].length == 0
                        ? SizedBox(
                            height: 200,
                            width: double.infinity,
                            child: Container(
                              padding: EdgeInsets.all(8.0),
                              decoration: BoxDecoration(
                                color: Colors.green.shade100,
                                image: DecorationImage(
                                  image:
                                      AssetImage('assets/images/dummy-img.png'),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          )
                        : SizedBox(
                            height: 200,
                            width: double.infinity,
                            child: PageView.builder(
                              itemCount: product[0]['images'].length,
                              itemBuilder: (context, index) {
                                String imageUrl =
                                    product[0]['images'][index]['src'];
                                print(imageUrl);
                                return Container(
                                  padding: EdgeInsets.all(8.0),
                                  decoration: BoxDecoration(
                                      color: Colors.green.shade50,
                                      image: DecorationImage(
                                        image: NetworkImage(imageUrl),
                                        fit: BoxFit.fitHeight,
                                      )),
                                );
                              },
                            ),
                          ),
                    Padding(
                      padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                      child: Container(
                        margin: EdgeInsets.only(
                          top: 20,
                        ),
                        // height: 100,
                        width: double.infinity,
                        // color: Colors.red.shade100,
                        child: Text(
                          product[0]['name'],
                          style: TextStyle(
                            fontFamily: 'Kanit',
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 20.0, right: 20.0, top: 5.0),
                      child: Container(
                        width: double.infinity,
                        // color: Colors.red.shade100,
                        child: product[0]['sale_price'] == ""
                            ? Text(
                                '₹${product[0]['price']}',
                                style: TextStyle(
                                  fontFamily: 'Kanit',
                                  fontSize: 14,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              )
                            : RichText(
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                text: TextSpan(
                                  children: [
                                    TextSpan(
                                      text: '₹${product[0]['regular_price']}',
                                      style: TextStyle(
                                        fontFamily: 'kanit',
                                        fontSize: 12,
                                        decoration: TextDecoration.lineThrough,
                                        color: Colors.red,
                                      ),
                                    ),
                                    TextSpan(
                                      text: '  ₹${product[0]['price']}',
                                      style: TextStyle(
                                        fontFamily: 'kanit',
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                      ),
                    ),
                    product[0]['in_stock']
                        ? Container(
                            height: 0,
                            width: 0,
                          )
                        : Padding(
                            padding: const EdgeInsets.only(left: 20.0),
                            child: Text(
                              'Out Of Stock',
                              style: TextStyle(
                                color: const Color.fromARGB(255, 255, 17, 0),
                                fontFamily: 'kanit',
                                fontSize: 15,
                              ),
                            ),
                          ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Container(
                        margin: EdgeInsets.only(top: 10, bottom: 10, left: 20),
                        child: ElevatedButton(
                          style:
                              product[0]['in_stock'] ? addToCart : outOfStock,
                          onPressed: () async {
                            product[0]['in_stock']
                                ? __addTheProductToCart(context, productId)
                                : "";
                          },
                          child: Text('Add to cart'),
                        ),
                      ),
                    ),
                    product[0]['description'] == ""
                        ? Container(
                            height: 0,
                            width: 0,
                          )
                        : Padding(
                            padding:
                                const EdgeInsets.only(left: 20.0, right: 20.0),
                            child: Container(
                              child: Text(
                                'Description',
                                style: TextStyle(
                                  fontFamily: 'kanit',
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.start,
                              ),
                            ),
                          ),
                    product[0]['description'] == ""
                        ? Container(
                            height: 0,
                            width: 0,
                          )
                        : Padding(
                            padding: const EdgeInsets.only(
                                left: 20.0,
                                right: 20.0,
                                top: 10.0,
                                bottom: 20.0),
                            child: Container(
                              child: HtmlWidget(
                                product[0]['description'],
                                textStyle: TextStyle(
                                  fontSize: 14,
                                  fontFamily: 'kanit',
                                ),
                              ),
                            ),
                          ),
                    Padding(
                      padding: EdgeInsets.only(left: 20.0, right: 20.0),
                      child: Text(
                        "Releted Products",
                        style: TextStyle(
                          fontFamily: 'kanit',
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}

void _showAlertDialog(BuildContext context, String type, String message) {
  IconData iconData;
  Color iconColor;
  String title;

  switch (type.toLowerCase()) {
    case 'warning':
      iconData = Icons.warning;
      iconColor = Colors.orange;
      title = 'Warning';
      break;
    case 'success':
      iconData = Icons.check_circle;
      iconColor = Colors.green;
      title = 'Success';
      break;
    default:
      iconData = Icons.info;
      iconColor = Colors.blue;
      title = 'Info';
  }

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        title: Row(
          children: [
            Icon(iconData, color: iconColor),
            SizedBox(width: 10),
            Text(
              title,
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        content: Text(
          message,
          style: TextStyle(fontSize: 14.0),
        ),
        actions: [
          Container(
            width: double.infinity,
            padding:
                EdgeInsets.only(left: 10.0, right: 10.0, top: 5.0, bottom: 5.0),
            color: Colors.blue,
            child: TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                'OK',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      );
    },
  );
}

AppBar screenAppBar(int cartItemCount, context) {
  return AppBar(
    backgroundColor: Colors.green.shade400,
    title: Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => HomePage()),
              );
            },
            child: Text(
              "Woocom",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 25,
                fontFamily: 'Kanit',
              ),
            ),
          ),
          Stack(
            alignment: Alignment.topRight,
            children: [
              IconButton(
                onPressed: () {},
                icon: Icon(
                  Icons.shopping_cart_outlined,
                  color: Colors.black,
                ),
              ),
              if (cartItemCount > 0)
                Positioned(
                  right: 0,
                  top: 0,
                  child: Container(
                    padding: EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color.fromARGB(255, 255, 255, 255),
                    ),
                    child: Padding(
                      padding: cartItemCount > 9
                          ? EdgeInsets.all(1.0)
                          : EdgeInsets.all(3.0),
                      child: Text(
                        cartItemCount > 99 ? '99+' : '$cartItemCount',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: cartItemCount > 99 ? 10 : 12,
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    ),
  );
}
