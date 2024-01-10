// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, avoid_unnecessary_containers, sized_box_for_whitespace, use_key_in_widget_constructors, prefer_interpolation_to_compose_strings, unused_import, unused_local_variable, prefer_const_declarations, unnecessary_string_interpolations, unnecessary_cast, unnecessary_null_comparison, prefer_if_null_operators, empty_catches, avoid_print, unnecessary_brace_in_string_interps, void_checks, unused_element

import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
// import 'package:woocommerce/api_service.dart';
import 'package:dio/dio.dart';
import 'package:woocommerce/helper/APIwork.dart';
import 'package:woocommerce_api/woocommerce_api.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var _currentIndex = 0;
  final List<Widget> _pages = [
    HomeScreen(),
    SearchScreen(),
    CartScreen(),
    ProfileScreen(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green.shade400,
        title: Container(
          // color: Colors.green.shade400,
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
              Row(
                children: [
                  // TextButton(
                  //   onPressed: () {},
                  //   child: Icon(
                  //     Icons.search,
                  //     color: Colors.black,
                  //   ),
                  // ),
                  TextButton(
                    onPressed: () {},
                    child: Icon(
                      Icons.shopping_cart_outlined,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
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

  late Future<List<dynamic>> theProducts;
  late Future<List<dynamic>> thenewProducts;

  int currentPage = 1;
  int perPage = 2;
  bool loadingMore = false;

  @override
  void initState() {
    pageController = PageController();
    super.initState();
    // allProducts = apiWorks.fetchProducts(page: 1, perPage: 10);
    allProducts = apiWorks.fetchProducts(page: currentPage, perPage: perPage);
    categories = apiWorks.fetchCategory();
    featuredProducts = apiWorks.fetchFeaturedProducts();
    scrollController.addListener(_scrollListner);
    _fetchAndStoreProductsJson();
  }

  Future<void> _fetchAndStoreProductsJson() async {
    try {
      var productsJson = await apiWorks.fetchProductsJson(
        page: currentPage,
        perPage: perPage,
      );

      setState(() {
        theProducts = Future.value(productsJson);
      });
      print((await theProducts).length);
    } catch (e) {
      print('Failed to load products: $e');
    }
  }

  void _loadMore() async {
    currentPage++;
    var newProductsJson = await apiWorks.fetchProductsJson(
      page: currentPage,
      perPage: perPage,
    );
    setState(() {
      thenewProducts = Future.value(newProductsJson);
      theProducts = Future.value(theProducts)
          .then((value) => value..addAll(newProductsJson));
    });
    print(theProducts);
  }

  void _scrollListner() {
    if (scrollController.position.pixels ==
        scrollController.position.maxScrollExtent) {
      print('scroll');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
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
              child: Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Categories",
                      style: TextStyle(
                        fontFamily: 'Kanit',
                        fontSize: 20,
                        // fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              child: Column(
                children: [
                  SizedBox(
                    height: 150,
                    width: double.infinity,
                    child: FutureBuilder<List<Category>>(
                      future: categories,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(child: CircularProgressIndicator());
                        } else if (snapshot.hasError) {
                          return Center(
                              child: Text('Error: ${snapshot.error}'));
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
                                      bottom: 5.0,
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
                                                      as ImageProvider<Object>,
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
                                                      TextDecorationStyle.solid,
                                                  shadows: [
                                                    Shadow(
                                                      color:
                                                          Colors.green.shade300,
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
            Container(
              child: Column(
                children: [
                  Container(
                    child: Text(
                      'Tranding Products',
                      style: TextStyle(
                        fontFamily: 'Kanit',
                        fontSize: 20,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  )
                ],
              ),
            ),
            Container(
              child: Column(
                children: [
                  SizedBox(
                    height: 270,
                    width: double.infinity,
                    child: FutureBuilder<List<FeaturedProduct>>(
                      future: featuredProducts,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(child: CircularProgressIndicator());
                        } else if (snapshot.hasError) {
                          return Center(
                              child: Text('Error: ${snapshot.error}'));
                        } else if (!snapshot.hasData ||
                            snapshot.data!.isEmpty) {
                          return Center(
                            child: Text('No Featured Product available.'),
                          );
                        } else {
                          List<FeaturedProduct> featuredProductsList =
                              snapshot.data!;

                          return PageView.builder(
                            itemCount: featuredProductsList.length,
                            padEnds: false,
                            pageSnapping: false,
                            controller: PageController(viewportFraction: 0.7),
                            itemBuilder: (context, index) {
                              FeaturedProduct product =
                                  featuredProductsList[index];
                              return Column(
                                children: [
                                  Container(
                                    // color: Colors.grey.shade100,
                                    width: double.infinity,
                                    margin: EdgeInsets.all(8.0),
                                    child: Column(
                                      children: [
                                        Container(
                                          height: 150,
                                          decoration: BoxDecoration(
                                            image: DecorationImage(
                                              image: product.imageUrl != null
                                                  ? NetworkImage(
                                                          product.imageUrl!)
                                                      as ImageProvider<Object>
                                                  : AssetImage(
                                                          'assets/images/dummy-img.png')
                                                      as ImageProvider<Object>,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                          child: product.imageUrl != null
                                              ? Image.network(
                                                  product.imageUrl!,
                                                  fit: BoxFit.cover,
                                                  errorBuilder: (context, error,
                                                      stackTrace) {
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
                                        Column(
                                          children: [
                                            Container(
                                              height: 50,
                                              child: Center(
                                                child: Text(
                                                  product.name!.length > 32
                                                      ? '${product.name!.substring(0, 32)}...'
                                                      : product.name!,
                                                  style: TextStyle(
                                                    fontFamily: 'Kanit',
                                                    fontSize: 15,
                                                  ),
                                                  textAlign: TextAlign.center,
                                                ),
                                              ),
                                            ),
                                            Container(
                                              height: 30,
                                              width: double.infinity,
                                              child: product.regularPrice == ""
                                                  ? Center(
                                                      child: Text(
                                                          '₹${product.originalPrice}'),
                                                    )
                                                  : Center(
                                                      child: Container(
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            Text(
                                                              '₹${product.regularPrice}',
                                                              style: TextStyle(
                                                                decoration:
                                                                    TextDecoration
                                                                        .lineThrough,
                                                              ),
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                            ),
                                                            SizedBox(width: 8),
                                                            Text(
                                                              '₹${product.originalPrice}',
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                            ),
                                            Container(
                                              height: 20,
                                              child: Text(
                                                product.stock == 'true'
                                                    ? ''
                                                    : 'Out Of Stock',
                                                style: TextStyle(
                                                  color: Colors.red,
                                                  fontSize: 12,
                                                ),
                                                textAlign: TextAlign.center,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              );
                            },
                          );
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
            Container(
              child: Column(
                children: [
                  Container(
                    child: Text(
                      'All Products',
                      style: TextStyle(
                        fontFamily: 'Kanit',
                        fontSize: 20,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  FutureBuilder<List<dynamic>>(
                    future: theProducts,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}'));
                      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return Center(child: Text('No products available.'));
                      } else {
                        List<dynamic> productList = snapshot.data!;

                        return Expanded(
                          child: ListView.builder(
                            itemCount: productList.length,
                            itemBuilder: (context, index) {
                              var product = productList[index];

                              var productName = product['name'];

                              return ListTile(
                                title: Text(productName),
                              );
                            },
                          ),
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ------------------ Experimental -----------------//

class SearchScreen extends StatefulWidget {
  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  late Future<List<Product>> products;
  List<Product> displayedProducts = [];
  final APIWorks apiWorks = APIWorks();

  @override
  void initState() {
    super.initState();
    products = fetchData();
  }

  Future<List<Product>> fetchData() async {
    try {
      List<Product> allProducts = await apiWorks.fetchProducts();

      setState(() {
        displayedProducts = List.from(allProducts);
      });

      return allProducts; // Return the fetched products
    } catch (e) {
      // Handle error as needed
      return []; // Return an empty list if there's an error
    }
  }

  void filterProducts(String query) async {
    setState(() {
      displayedProducts = [];
    });

    try {
      List<Product> allProducts = await products;

      setState(() {
        if (query.isEmpty) {
          displayedProducts = List.from(allProducts);
        } else {
          displayedProducts = allProducts
              .where((product) =>
                  product.name!.toLowerCase().contains(query.toLowerCase()))
              .toList();
        }
      });
    } catch (e) {
      // Handle error as needed
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.all(8.0),
            child: TextField(
              onChanged: filterProducts,
              decoration: InputDecoration(
                labelText: 'Search Products',
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),
          Expanded(
            child: displayedProducts.isEmpty
                ? Center(
                    child: products == null
                        ? CircularProgressIndicator()
                        : Text('No products match your search'),
                  )
                : ListView.builder(
                    itemCount: displayedProducts.length,
                    itemBuilder: (context, index) {
                      Product product = displayedProducts[index];
                      return ListTile(
                        title: Text(product.name!),
                        subtitle: Text('₹' + product.price!),
                      );
                    },
                  ),
          ),
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
