// ignore_for_file: prefer_const_constructors, use_key_in_widget_constructors, avoid_print, avoid_unnecessary_containers, prefer_const_literals_to_create_immutables, unused_local_variable, unnecessary_cast, unnecessary_null_comparison

import 'package:flutter/material.dart';
import 'package:woocommerce/pages/homepage.dart';
import 'package:woocommerce/helper/APIwork.dart';

class ProductScreen extends StatefulWidget {
  final int productId;
  const ProductScreen({required this.productId});

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  List product = [];
  void productList;
  final APIWorks apiWorks = APIWorks();
  bool isLoaded = false;

  @override
  void initState() {
    super.initState();
    _fetchProductDetails(widget.productId);
  }

  Future<void> _fetchProductDetails(productId) async {
    final json =
        await apiWorks.fetchProductDetails(productId) as Map<String, dynamic>;
    final productDetails = json;
    setState(() {
      product = [productDetails];
      // print(product);
      isLoaded = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final int productId = widget.productId;
    return Scaffold(
      appBar: screenAppBar(12, context),
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
          : SafeArea(
              child: Column(
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
                                    color: Colors.green.shade100,
                                    image: DecorationImage(
                                      image: NetworkImage(imageUrl),
                                      fit: BoxFit.cover,
                                    )),
                              );
                            },
                          ),
                        ),
                ],
              ),
            ),
    );
  }
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
