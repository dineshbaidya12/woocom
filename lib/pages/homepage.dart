// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, avoid_unnecessary_containers, sized_box_for_whitespace, use_key_in_widget_constructors, prefer_interpolation_to_compose_strings, unused_import, unused_local_variable, prefer_const_declarations, unnecessary_string_interpolations, unnecessary_cast, unnecessary_null_comparison, prefer_if_null_operators, empty_catches, avoid_print, unnecessary_brace_in_string_interps, void_checks, unused_element, unrelated_type_equality_checks, prefer_const_constructors_in_immutables

import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
// import 'package:woocommerce/api_service.dart';
import 'package:dio/dio.dart';
import 'package:woocommerce/helper/APIwork.dart';
import 'package:woocommerce/pages/productpage.dart';
import 'package:woocommerce/styles/button-styles.dart';
import 'package:woocommerce_api/woocommerce_api.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var _currentIndex = 0;
  late List<Widget> _pages;
  @override
  void initState() {
    super.initState();
    _pages = [
      HomeScreen(),
      SearchScreen(updateCurrentIndex: updateCurrentIndex),
      CartScreen(),
      ProfileScreen(),
    ];
  }

  void updateCurrentIndex(int newIndex) {
    setState(() {
      _currentIndex = newIndex;
    });
  }

  @override
  Widget build(BuildContext context) {
    var scaffold = Scaffold(
      appBar: screenAppBar(12),
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.yellow[50],
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        selectedItemColor: Colors.black,
        items: [
          BottomNavigationBarItem(
            backgroundColor: Colors.green.shade400,
            icon: Icon(
              Icons.home,
              color: Colors.black,
            ),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            backgroundColor: Colors.green.shade400,
            icon: Icon(
              Icons.search,
              color: Colors.black,
            ),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            backgroundColor: Colors.green.shade400,
            icon: Icon(
              Icons.shopping_cart,
              color: Colors.black,
            ),
            label: 'Cart',
          ),
          BottomNavigationBarItem(
            backgroundColor: Colors.green.shade400,
            icon: Icon(
              Icons.person,
              color: Colors.black,
            ),
            label: 'Profile',
          ),
        ],
      ),
    );
    return scaffold;
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    super.key,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final scrollController = ScrollController();
  final APIWorks apiWorks = APIWorks();
  late final PageController pageController;
  late Future<List<Product>> allProducts;
  late Future<List<Product>> newProducts;
  // late Future<List<WooProduct>> allProducts;
  late Future<List<FeaturedProduct>> featuredProducts;
  late Future<List<Category>> categories;

  late Future<List<dynamic>> thenewProducts;

  int currentPage = 1;
  int perPage = 5;
  String isLoading = 'false';

  // --------------- new Method ------------------//
  List newMethodProducts = [];
  List newFeaturedProducts = [];
  bool fetchComplete = false;

  @override
  void initState() {
    pageController = PageController();
    super.initState();
    allProducts = apiWorks.fetchProducts(page: currentPage, perPage: perPage);
    categories = apiWorks.fetchCategory();
    featuredProducts = apiWorks.fetchFeaturedProducts();

    // --------------- new Method ------------------//
    scrollController.addListener(_scrollListner);
    _fetchAndStoreProductsJson();
    _fetchFeaturedProducts();
  }

  // --------------- new Method start ------------------//
  Future<void> _fetchAndStoreProductsJson() async {
    final json = await apiWorks.fetchProductsJson(currentPage, perPage) as List;
    setState(() {
      newMethodProducts = json;
    });
  }

  Future<void> _fetchFeaturedProducts() async {
    final myFeaturedProducts = await apiWorks.getFeaturedProducts() as List;
    setState(() {
      newFeaturedProducts = myFeaturedProducts;
    });
  }

  Future<List> _loadMore() async {
    final currentPageIncrease = ++currentPage;
    final json =
        await apiWorks.fetchProductsJson(currentPageIncrease, perPage) as List;

    // print(json[0]);
    return json;
  }

  void _scrollListner() {
    if (scrollController.position.pixels >
        scrollController.position.maxScrollExtent - 450) {
      // print('scroll');
      if (isLoading == 'false') {
        setState(() {
          isLoading = 'true';
        });

        _loadMore().then((newjson) {
          setState(() {
            if (newjson.isNotEmpty) {
              newMethodProducts.addAll(newjson);
              isLoading = 'false';
            } else {
              isLoading = 'noMore';
            }
          });
        }).catchError((error) {
          print('Error loading more products: $error');
          setState(() {
            isLoading = 'stop';
            fetchComplete = true;
          });
        });
      } else if (isLoading == 'noMore') {
        setState(() {
          isLoading = 'noMore';
        });
      }
    }
  }

  // --------------- new Method end------------------//

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.green.shade100,
      child: SafeArea(
        child: SingleChildScrollView(
          controller: scrollController,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                height: 200,
                width: double.infinity,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/banner.jpg'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Text(
                  "Categories",
                  style: TextStyle(
                    fontFamily: 'Kanit',
                    fontSize: 20,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              Container(
                child: Column(
                  children: [
                    SizedBox(
                      height: 102,
                      width: double.infinity,
                      child: FutureBuilder<List<Category>>(
                        future: categories,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Center(child: CircularProgressIndicator());
                          } else if (snapshot.hasError) {
                            return Center(
                              child: Center(
                                child: Text(
                                    'Unable To Fetch Category, Please Try Again'),
                              ),
                            );
                          } else if (!snapshot.hasData ||
                              snapshot.data!.isEmpty) {
                            return Center(
                                child: Text('No categories available.'));
                          } else {
                            List<Category> categoryList = snapshot.data!;

                            return PageView.builder(
                              itemCount: categoryList.length,
                              padEnds: false,
                              pageSnapping: false,
                              controller: PageController(
                                viewportFraction: 0.7,
                              ),
                              itemBuilder: (context, index) {
                                Category category = categoryList[index];

                                return Column(
                                  children: [
                                    Container(
                                      height: 100,
                                      width: double.infinity,
                                      margin: EdgeInsets.only(
                                        left: 5.0,
                                        right: 5.0,
                                        top: 2.0,
                                      ),
                                      child: Stack(
                                        children: [
                                          Container(
                                            height: 100,
                                            decoration: BoxDecoration(
                                              image: DecorationImage(
                                                image: category.imageUrl != null
                                                    ? NetworkImage(
                                                            category.imageUrl!)
                                                        as ImageProvider<Object>
                                                    : AssetImage(
                                                            'assets/images/dummy-img.png')
                                                        as ImageProvider<
                                                            Object>,
                                                fit: BoxFit.cover,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(18),
                                            ),
                                          ),
                                          Positioned(
                                            left: 0,
                                            right: 0,
                                            top: 0,
                                            child: Container(
                                              height: 100,
                                              width: double.infinity,
                                              padding: EdgeInsets.all(10),
                                              decoration: BoxDecoration(
                                                color: Color.fromARGB(
                                                    162, 37, 114, 41),
                                                borderRadius: BorderRadius.all(
                                                  Radius.circular(18),
                                                ),
                                              ),
                                              child: Center(
                                                child: Text(
                                                  category.name!,
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 16,
                                                    color: Color.fromARGB(
                                                        255, 39, 39, 39),
                                                    decoration:
                                                        TextDecoration.none,
                                                    decorationStyle:
                                                        TextDecorationStyle
                                                            .solid,
                                                    shadows: [
                                                      Shadow(
                                                        color: Colors
                                                            .green.shade300,
                                                        offset: Offset(2, 2),
                                                        blurRadius: 3,
                                                      ),
                                                    ],
                                                  ),
                                                  textAlign: TextAlign.center,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                );
                              },
                            );
                          }
                        },
                      ),
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Text(
                  "Trending Products",
                  style: TextStyle(
                    fontFamily: 'Kanit',
                    fontSize: 20,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              //
              newFeaturedProducts.isEmpty
                  ? fetchComplete
                      ? Center(
                          child: Text(
                            'No Products Available or Something went wrong, please try again',
                            textAlign: TextAlign.center,
                          ),
                        )
                      : Center(
                          child: CircularProgressIndicator(),
                        )
                  : Padding(
                      padding: const EdgeInsets.only(left: 10, right: 10),
                      child: Column(
                        children: [
                          SizedBox(
                            height: 320,
                            // width: double.infinity,
                            child: PageView.builder(
                              padEnds: false,
                              pageSnapping: false,
                              controller: PageController(
                                viewportFraction: 0.8,
                              ),
                              itemCount: newFeaturedProducts.length,
                              itemBuilder: (context, index) {
                                final name = newFeaturedProducts[index]['name'];
                                final regilarPrice =
                                    newFeaturedProducts[index]['regular_price'];
                                final salePrice =
                                    newFeaturedProducts[index]['sale_price'];
                                final price =
                                    newFeaturedProducts[index]['price'];
                                final image = newFeaturedProducts[index]
                                    ['images'][0]['src'];
                                final stock = newFeaturedProducts[index]
                                        ['in_stock']
                                    .toString();
                                return GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => ProductScreen(
                                          productId: newFeaturedProducts[index]
                                              ['id'],
                                        ),
                                      ),
                                    );
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(1),
                                    child: Container(
                                      margin: EdgeInsets.only(right: 15),
                                      // color: Colors.green.shade200,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(12),
                                        color: Colors.green.shade200,
                                      ),
                                      child: Column(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                top: 20.0, right: 20, left: 20),
                                            child: Container(
                                              height: 150,
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.7,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                image: DecorationImage(
                                                  image: image != null
                                                      ? NetworkImage(image)
                                                          as ImageProvider<
                                                              Object>
                                                      : AssetImage(
                                                              'assets/images/dummy-img.png')
                                                          as ImageProvider<
                                                              Object>,
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                              child: image != null
                                                  ? Image.network(
                                                      image,
                                                      fit: BoxFit.cover,
                                                      errorBuilder: (context,
                                                          error, stackTrace) {
                                                        return Center(
                                                          child: Icon(
                                                            Icons.error_outline,
                                                            color: Colors.red,
                                                            size: 40.0,
                                                          ),
                                                        );
                                                      },
                                                    )
                                                  : null,
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                right: 10, left: 10, top: 20),
                                            child: Container(
                                              child: Text(
                                                name,
                                                style: TextStyle(
                                                  fontFamily: 'kanit',
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                                textAlign: TextAlign.center,
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                bottom: 5,
                                                right: 10,
                                                left: 10,
                                                top: 5),
                                            child: Container(
                                              child: (salePrice == "")
                                                  ? Text(
                                                      '₹${price}',
                                                      style: TextStyle(
                                                        fontFamily: 'Kanit',
                                                        fontSize: 12,
                                                      ),
                                                      maxLines: 1,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    )
                                                  : RichText(
                                                      maxLines: 1,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      text: TextSpan(
                                                        children: [
                                                          TextSpan(
                                                            text:
                                                                '₹${regilarPrice}',
                                                            style: TextStyle(
                                                              fontFamily:
                                                                  'kanit',
                                                              fontSize: 10,
                                                              decoration:
                                                                  TextDecoration
                                                                      .lineThrough,
                                                              color: Colors.red,
                                                            ),
                                                          ),
                                                          TextSpan(
                                                            text: '  ₹$price',
                                                            style: TextStyle(
                                                              fontFamily:
                                                                  'kanit',
                                                              fontSize: 12,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                            ),
                                          ),
                                          Container(
                                            child: stock == 'true'
                                                ? Text("")
                                                : Text(
                                                    'Out of Stock',
                                                    style: TextStyle(
                                                      color: Colors.red,
                                                      fontFamily: 'Kanit',
                                                      fontSize: 12,
                                                    ),
                                                  ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                bottom: 5),
                                            child: ElevatedButton(
                                              style: moreDetails,
                                              onPressed: () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        ProductScreen(
                                                      productId:
                                                          newFeaturedProducts[
                                                              index]['id'],
                                                    ),
                                                  ),
                                                );
                                              },
                                              child: Text('See Details'),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),

              //
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Text(
                  "All Products",
                  style: TextStyle(
                    fontFamily: 'Kanit',
                    fontSize: 20,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: newMethodProducts.length,
                itemBuilder: (context, index) {
                  final name = newMethodProducts[index]['name'];
                  final regilarPrice =
                      newMethodProducts[index]['regular_price'];
                  final salePrice = newMethodProducts[index]['sale_price'];
                  final price = newMethodProducts[index]['price'];
                  final image = newMethodProducts[index]['images'][0]['src'];
                  final stock = newMethodProducts[index]['in_stock'].toString();
                  // print(image);
                  return Padding(
                    padding: const EdgeInsets.only(left: 25, right: 25),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ProductScreen(
                              productId: newMethodProducts[index]['id'],
                            ),
                          ),
                        );
                      },
                      child: Container(
                        margin: EdgeInsets.only(bottom: 20),
                        // color: Colors.green.shade200,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: Colors.green.shade200,
                        ),
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                top: 20.0,
                              ),
                              child: Container(
                                height: 150,
                                width: MediaQuery.of(context).size.width * 0.7,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  image: DecorationImage(
                                    image: image != null
                                        ? NetworkImage(image)
                                            as ImageProvider<Object>
                                        : AssetImage(
                                                'assets/images/dummy-img.png')
                                            as ImageProvider<Object>,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                child: image != null
                                    ? Image.network(
                                        image,
                                        fit: BoxFit.cover,
                                        errorBuilder:
                                            (context, error, stackTrace) {
                                          return Center(
                                            child: Icon(
                                              Icons.error_outline,
                                              color: Colors.red,
                                              size: 40.0,
                                            ),
                                          );
                                        },
                                      )
                                    : null,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  right: 10, left: 10, top: 20),
                              child: Container(
                                child: Text(
                                  name,
                                  style: TextStyle(
                                    fontFamily: 'kanit',
                                    fontSize: 16,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  bottom: 5, right: 10, left: 10, top: 5),
                              child: Container(
                                child: (salePrice == "")
                                    ? Text('₹${price}')
                                    : RichText(
                                        text: TextSpan(
                                          children: [
                                            TextSpan(
                                              text: '₹${regilarPrice}',
                                              style: TextStyle(
                                                decoration:
                                                    TextDecoration.lineThrough,
                                                color: Colors.red,
                                              ),
                                            ),
                                            TextSpan(text: '  ₹$price'),
                                          ],
                                        ),
                                      ),
                              ),
                            ),
                            Container(
                              child: stock == 'true'
                                  ? Text("")
                                  : Text(
                                      'Out of Stock',
                                      style: TextStyle(
                                        color: Colors.red,
                                        fontFamily: 'Kanit',
                                        fontSize: 12,
                                      ),
                                    ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 25),
                              child: ElevatedButton(
                                style: moreDetails,
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ProductScreen(
                                        productId: newMethodProducts[index]
                                            ['id'],
                                      ),
                                    ),
                                  );
                                },
                                child: Text('See Details'),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
              Container(
                child: Center(
                  child: isLoading == 'true'
                      ? Container(
                          width: 30,
                          height: 30,
                          child: CircularProgressIndicator(),
                        )
                      : isLoading == 'false'
                          ? Text('')
                          : Text(
                              'No More Products',
                              style:
                                  TextStyle(fontFamily: 'Kanit', fontSize: 12),
                              textAlign: TextAlign.center,
                            ),
                ),
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

class SearchScreen extends StatefulWidget {
  final Function(int) updateCurrentIndex;

  SearchScreen({required this.updateCurrentIndex});
  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final APIWorks apiWorks = APIWorks();
  List searchedProducts = [];

  @override
  void initState() {
    super.initState();
    _fetchAndStoreProductsJson();
  }

  Future<void> _fetchAndStoreProductsJson() async {
    final json = await apiWorks.fetchProductsJson(1, 20) as List;
    setState(() {
      searchedProducts = json;
    });
  }

  bool isSearching = false;

  Future<void> filterProduct(String value) async {
    setState(() {
      isSearching = true;
    });

    try {
      final json = await apiWorks.searchProductJson(value) as List;

      setState(() {
        searchedProducts = json;
      });
    } finally {
      setState(() {
        isSearching = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.green.shade100,
      child: ListView(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding:
                    const EdgeInsets.only(left: 20.0, top: 15.0, bottom: 10.0),
                child: Text(
                  'Search for Products',
                  style: TextStyle(
                    fontFamily: 'Kanit',
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 20),
                width: MediaQuery.of(context).size.width * .85,
                height: 35,
                child: TextField(
                  style: TextStyle(
                    fontFamily: 'Kanit',
                    fontSize: 12,
                  ),
                  onChanged: (value) {
                    filterProduct(value);
                  },
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.green.shade200,
                    hintText: "eg: Apple iPhone 12",
                    hintStyle: TextStyle(
                      fontFamily: 'Kanit',
                      fontSize: 14,
                    ),
                    contentPadding: EdgeInsets.symmetric(
                      vertical: 8,
                      horizontal: 10,
                    ),
                    border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    prefixIcon: Icon(
                      Icons.search,
                      size: 12,
                    ),
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.only(top: 15.0),
            child: isSearching
                ? Center(
                    child: Container(
                      margin: EdgeInsets.only(
                        top: 150,
                      ),
                      height: 50,
                      width: 50,
                      child: CircularProgressIndicator(),
                    ),
                  )
                : ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: searchedProducts.length,
                    itemBuilder: (context, index) {
                      final name = searchedProducts[index]['name'];
                      final regilarPrice =
                          searchedProducts[index]['regular_price'];
                      final salePrice = searchedProducts[index]['sale_price'];
                      final price = searchedProducts[index]['price'];
                      final image = searchedProducts[index]['images'][0]['src'];
                      final stock =
                          searchedProducts[index]['in_stock'].toString();
                      return Container(
                        child: ListTile(
                          title: Text(
                            name,
                            maxLines: 2,
                            style: TextStyle(
                              fontFamily: 'Kanit',
                              fontSize: 14,
                            ),
                          ),
                          subtitle: (salePrice == "")
                              ? Text(
                                  '₹${price}',
                                  style: TextStyle(
                                    fontFamily: 'Kanit',
                                    fontSize: 12,
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
                                        text: '₹${regilarPrice}',
                                        style: TextStyle(
                                          fontFamily: 'kanit',
                                          fontSize: 10,
                                          decoration:
                                              TextDecoration.lineThrough,
                                          color: Colors.red,
                                        ),
                                      ),
                                      TextSpan(
                                        text: '  ₹$price',
                                        style: TextStyle(
                                          fontFamily: 'kanit',
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                          leading: Container(
                            height: 150,
                            width: 60,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: image != null
                                    ? NetworkImage(image)
                                        as ImageProvider<Object>
                                    : AssetImage('assets/images/dummy-img.png'),
                                fit: BoxFit.fitHeight,
                              ),
                            ),
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ProductScreen(
                                  productId: searchedProducts[index]['id'],
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
          ),
          !isSearching
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 10, bottom: 10),
                    child: Container(
                      height: 30,
                      width: 120,
                      child: ElevatedButton(
                        style: seeAllProduct,
                        onPressed: () {
                          widget.updateCurrentIndex(0);
                        },
                        child: Text(
                          'All Products',
                          style: TextStyle(fontSize: 12),
                        ),
                      ),
                    ),
                  ),
                )
              : Text(''),
        ],
      ),
    );
  }
}

// ------------------ Experimental -----------------//

class CartScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Cart Screen'),
    );
  }
}

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Profile Screen'),
    );
  }
}

// --------------- Models -----------------//
class Product {
  final int id;
  final String? name;
  final String? price;
  final String? imageUrl;
  final String? regularPrice;
  final String? originalPrice;
  final String stock;

  Product({
    required this.id,
    this.name,
    this.price = "0.0",
    this.imageUrl,
    this.regularPrice,
    this.originalPrice,
    required this.stock,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      name: json['name'] == null ? 'N/A' : json['name'],
      price: json['price'],
      imageUrl: json['images'][0]['src'],
      regularPrice:
          json['regular_price'] == null ? null : json['regular_price'],
      stock: json['in_stock'].toString(),
    );
  }
}

class Category {
  final int? id;
  final String? name;
  final int? parent;
  final String? imageUrl;

  Category({
    this.id,
    this.name,
    this.parent,
    this.imageUrl,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    final int? parentId = json['parent'];

    if (parentId == 0) {
      return Category(
        id: json['id'] == null ? 0 : json['id'],
        name: json['name'] == null ? 'N/A' : json['name'],
        imageUrl: json['image'] == null ? null : json['image']['src'],
        parent: parentId,
      );
    }
    return Category();
  }
}

class FeaturedProduct {
  final int? id;
  final String? name;
  final String? imageUrl;
  final String? regularPrice;
  final String? originalPrice;
  final String stock;
  final bool? featured;

  FeaturedProduct({
    this.id,
    this.name,
    this.imageUrl,
    this.regularPrice,
    this.originalPrice,
    required this.stock,
    this.featured,
  });

  factory FeaturedProduct.fromJson(Map<String, dynamic> json) {
    // print(json);
    return FeaturedProduct(
      id: json['id'] == null ? 0 : json['id'],
      name: json['name'] == null ? 'N/A' : json['name'],
      imageUrl: json['images'] == null ? null : json['images'][0]['src'],
      regularPrice:
          json['regular_price'] == null ? null : json['regular_price'],
      originalPrice: json['price'] == null ? null : json['price'],
      stock: json['in_stock'].toString(),
    );
  }
}

// --------------- Models -----------------//
AppBar screenAppBar(int cartItemCount) {
  return AppBar(
    automaticallyImplyLeading: false,
    backgroundColor: Colors.green.shade400,
    title: Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "Woocom",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 25,
              fontFamily: 'Kanit',
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
