// ignore_for_file: prefer_const_constructors, avoid_unnecessary_containers, prefer_const_literals_to_create_immutables, prefer_final_fields, use_key_in_widget_constructors, prefer_const_constructors_in_immutables, unused_local_variable, await_only_futures, unused_field, sized_box_for_whitespace, avoid_print

import 'package:flutter/material.dart';
import 'package:woocommerce/helper/APIwork.dart';
import 'package:woocommerce/manage_cart.dart';
import 'package:woocommerce/manage_customers.dart';
import 'package:woocommerce/pages/homepage.dart';
import 'package:woocommerce/styles/button-styles.dart';

class PlaceOrder extends StatefulWidget {
  final int currentPage;
  PlaceOrder({required this.currentPage});

  @override
  State<PlaceOrder> createState() => _PlaceOrderState();
}

class _PlaceOrderState extends State<PlaceOrder> {
  List _pages = [
    ChooseAddress(),
    ChooseShippingAddress(),
    ChoosePayment(),
  ];

  int get currentPage => widget.currentPage;
  late int cartItems = 0;
  ManageCart cart = ManageCart();

  @override
  void initState() {
    super.initState();
    _getCartItemCount();
  }

  _getCartItemCount() async {
    final int cratItemCount = await cart.countCartProduct();
    setState(() {
      cartItems = cratItemCount;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: screenAppBar(cartItems, context),
      body: _pages[currentPage],
    );
  }
}

// -------- Choose Address ----------//

class ChooseAddress extends StatefulWidget {
  const ChooseAddress({super.key});

  @override
  State<ChooseAddress> createState() => _ChooseAddressState();
}

class _ChooseAddressState extends State<ChooseAddress> {
  ManageCustomer customer = ManageCustomer();
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _streetAddress = TextEditingController();
  final _city = TextEditingController();
  final _stateController = TextEditingController();
  final _pincodeController = TextEditingController();
  final _emailController = TextEditingController();
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _getUserInfo();
  }

  void _getUserInfo() async {
    try {
      ManageCustomer customer = ManageCustomer();
      final userInfoList = await customer.getUserInfoAsList();

      if (userInfoList.isNotEmpty) {
        _firstNameController.text = userInfoList[0].toString();
        _lastNameController.text = userInfoList[1].toString();
        _city.text = userInfoList[2].toString();
        _stateController.text = userInfoList[3].toString();
        _pincodeController.text = userInfoList[4].toString();
        _emailController.text = userInfoList[5].toString();
        _streetAddress.text = userInfoList[6].toString();
      }

      setState(() {
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }

  saveDataToSharedPref() {
    ManageCustomer customer = ManageCustomer();

    String firstName = _firstNameController.text;
    String lastName = _lastNameController.text;
    String city = _city.text;
    String state = _stateController.text;
    String pincode = _pincodeController.text;
    String email = _emailController.text;
    String streetAddress = _streetAddress.text;

    customer.saveOrderInfo({
      'billing_firstname': firstName,
      'billing_lastname': lastName,
      'billing_city': city,
      'billing_state': state,
      'billing_pincode': pincode,
      'billing_email': email,
      'billing_streetaddress': streetAddress,
    });

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => PlaceOrder(currentPage: 1)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: isLoading
          ? Padding(
              padding: const EdgeInsets.only(top: 25.0),
              child: Center(
                child: Container(
                  height: 30,
                  width: 30,
                  child: CircularProgressIndicator(),
                ),
              ),
            )
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    Text(
                      "Billing Address",
                      style: TextStyle(
                        fontFamily: 'kanit',
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Divider(
                      thickness: 1.0,
                      height: 10.0,
                      color: Colors.white,
                    ),
                    TextFormField(
                      controller: _firstNameController,
                      decoration: InputDecoration(
                        labelText: 'First Name',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your first name';
                        }
                        return null;
                      },
                    ),
                    Divider(
                      thickness: 1.0,
                      height: 10.0,
                      color: Colors.white,
                    ),
                    TextFormField(
                      controller: _lastNameController,
                      decoration: InputDecoration(
                        labelText: 'Last Name',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your last name';
                        }
                        return null;
                      },
                    ),
                    Divider(
                      thickness: 1.0,
                      height: 10.0,
                      color: Colors.white,
                    ),
                    TextFormField(
                      controller: _city,
                      decoration: InputDecoration(
                        labelText: 'City',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your city';
                        }
                        return null;
                      },
                    ),
                    Divider(
                      thickness: 1.0,
                      height: 10.0,
                      color: Colors.white,
                    ),
                    TextFormField(
                      controller: _stateController,
                      decoration: InputDecoration(
                        labelText: 'State',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your state';
                        }
                        return null;
                      },
                    ),
                    Divider(
                      thickness: 1.0,
                      height: 10.0,
                      color: Colors.white,
                    ),
                    TextFormField(
                      controller: _pincodeController,
                      decoration: InputDecoration(
                        labelText: 'Pincode',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your Pincode';
                        }
                        return null;
                      },
                    ),
                    Divider(
                      thickness: 1.0,
                      height: 10.0,
                      color: Colors.white,
                    ),
                    TextFormField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        labelText: 'Email',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your email';
                        }
                        final emailRegex = RegExp(
                          r'^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+$',
                        );
                        if (!emailRegex.hasMatch(value)) {
                          return 'Please enter a valid email address';
                        }
                        return null;
                      },
                    ),
                    Divider(
                      thickness: 1.0,
                      height: 10.0,
                      color: Colors.white,
                    ),
                    TextFormField(
                      controller: _streetAddress,
                      maxLines: 3,
                      decoration: InputDecoration(
                        labelText: 'Street Address',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your street address';
                        }
                        return null;
                      },
                    ),
                    Divider(
                      thickness: 1.0,
                      height: 10.0,
                      color: Colors.white,
                    ),
                    ElevatedButton(
                      style: moreDetails,
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          saveDataToSharedPref();
                        }
                      },
                      child: Text('Next'),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}

// -------- Choose Address ----------//

// -------- Choose Shipping Address ----------//

class ChooseShippingAddress extends StatefulWidget {
  const ChooseShippingAddress({super.key});

  @override
  State<ChooseShippingAddress> createState() => _ChooseShippingAddressState();
}

class _ChooseShippingAddressState extends State<ChooseShippingAddress> {
  ManageCustomer customer = ManageCustomer();
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _streetAddress = TextEditingController();
  final _city = TextEditingController();
  final _stateController = TextEditingController();
  final _pincodeController = TextEditingController();
  final _emailController = TextEditingController();
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _getUserInfo();
  }

  void _getUserInfo() async {
    try {
      ManageCustomer customer = ManageCustomer();
      final userInfoList = await customer.getUserInfoAsList();

      if (userInfoList.isNotEmpty) {
        _firstNameController.text = userInfoList[0].toString();
        _lastNameController.text = userInfoList[1].toString();
        _city.text = userInfoList[2].toString();
        _stateController.text = userInfoList[3].toString();
        _pincodeController.text = userInfoList[4].toString();
        _emailController.text = userInfoList[5].toString();
        _streetAddress.text = userInfoList[6].toString();
      }

      setState(() {
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }

  saveDataToSharedPref() {
    ManageCustomer customer = ManageCustomer();

    String firstName = _firstNameController.text;
    String lastName = _lastNameController.text;
    String city = _city.text;
    String state = _stateController.text;
    String pincode = _pincodeController.text;
    String email = _emailController.text;
    String streetAddress = _streetAddress.text;

    customer.saveOrderInfoShipping({
      'shipping_firstname': firstName,
      'shipping_lastname': lastName,
      'shipping_city': city,
      'shipping_state': state,
      'shipping_pincode': pincode,
      'shipping_email': email,
      'shipping_streetaddress': streetAddress,
    });

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => PlaceOrder(currentPage: 2)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: isLoading
          ? Padding(
              padding: const EdgeInsets.only(top: 25.0),
              child: Center(
                child: Container(
                  height: 30,
                  width: 30,
                  child: CircularProgressIndicator(),
                ),
              ),
            )
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    Text(
                      "Shipping Address",
                      style: TextStyle(
                        fontFamily: 'kanit',
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Divider(
                      thickness: 1.0,
                      height: 10.0,
                      color: Colors.white,
                    ),
                    TextFormField(
                      controller: _firstNameController,
                      decoration: InputDecoration(
                        labelText: 'First Name',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your first name';
                        }
                        return null;
                      },
                    ),
                    Divider(
                      thickness: 1.0,
                      height: 10.0,
                      color: Colors.white,
                    ),
                    TextFormField(
                      controller: _lastNameController,
                      decoration: InputDecoration(
                        labelText: 'Last Name',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your last name';
                        }
                        return null;
                      },
                    ),
                    Divider(
                      thickness: 1.0,
                      height: 10.0,
                      color: Colors.white,
                    ),
                    TextFormField(
                      controller: _city,
                      decoration: InputDecoration(
                        labelText: 'City',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your city';
                        }
                        return null;
                      },
                    ),
                    Divider(
                      thickness: 1.0,
                      height: 10.0,
                      color: Colors.white,
                    ),
                    TextFormField(
                      controller: _stateController,
                      decoration: InputDecoration(
                        labelText: 'State',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your state';
                        }
                        return null;
                      },
                    ),
                    Divider(
                      thickness: 1.0,
                      height: 10.0,
                      color: Colors.white,
                    ),
                    TextFormField(
                      controller: _pincodeController,
                      decoration: InputDecoration(
                        labelText: 'Pincode',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your Pincode';
                        }
                        return null;
                      },
                    ),
                    Divider(
                      thickness: 1.0,
                      height: 10.0,
                      color: Colors.white,
                    ),
                    TextFormField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        labelText: 'Email',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your email';
                        }
                        final emailRegex = RegExp(
                          r'^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+$',
                        );
                        if (!emailRegex.hasMatch(value)) {
                          return 'Please enter a valid email address';
                        }
                        return null;
                      },
                    ),
                    Divider(
                      thickness: 1.0,
                      height: 10.0,
                      color: Colors.white,
                    ),
                    TextFormField(
                      controller: _streetAddress,
                      maxLines: 3,
                      decoration: InputDecoration(
                        labelText: 'Street Address',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your street address';
                        }
                        return null;
                      },
                    ),
                    Divider(
                      thickness: 1.0,
                      height: 10.0,
                      color: Colors.white,
                    ),
                    ElevatedButton(
                      style: moreDetails,
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          saveDataToSharedPref();
                        }
                      },
                      child: Text('Next'),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}

// -------- Choose Shipping Address ----------//

// ------------ Choose Payment ---------- //

class ChoosePayment extends StatefulWidget {
  const ChoosePayment({super.key});

  @override
  State<ChoosePayment> createState() => _ChoosePaymentState();
}

class _ChoosePaymentState extends State<ChoosePayment> {
  ManageCustomer customer = ManageCustomer();
  List<String> orderDetails = [];
  String resultsDyn = "No Data";

  @override
  void initState() {
    super.initState();
    _printOrderDetails();
  }

  _printOrderDetails() async {
    final orderList = await customer.getOrderInfoAsMap();
    setState(() {
      orderDetails = orderList.values.toList();
    });
  }

  __placeOrder() async {
    APIWorks apiWorks = APIWorks();
    ManageCart cart = ManageCart();

    List<int> products = await cart.getCartList();
    print(products);

    Map<String, dynamic> orderData = {
      'payment_method': 'cod',
      'payment_method_title': 'Cash On Devliery',
      'set_paid': true,
      'billing': {
        'first_name': 'John',
        'last_name': 'Doe',
        'address_1': '969 Market',
        'address_2': '',
        'city': 'San Francisco',
        'state': 'CA',
        'postcode': '94103',
        'country': 'US',
        'email': 'john.doe@example.com',
        'phone': '(555) 555-5555',
      },
      'shipping': {
        'first_name': 'John',
        'last_name': 'Doe',
        'address_1': '969 Market',
        'address_2': '',
        'city': 'San Francisco',
        'state': 'CA',
        'postcode': '94103',
        'country': 'US',
      },
      'line_items': [
        {'product_id': 589, 'quantity': 1},
        {'product_id': 587, 'quantity': 1},
      ],
      'shipping_lines': [
        {
          'method_id': 'flat_rate',
          'method_title': 'Flat Rate',
          'total': '10.00',
        },
      ],
    };

    dynamic result = await apiWorks.placeOrder(orderData);

    setState(() {
      resultsDyn = result;
    });

    if (result != 'error') {
      print('Order placed successfully! Order ID: $result');
    } else {
      print(result);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          child: Text(orderDetails.toString()),
        ),
        ElevatedButton(
          onPressed: () {
            __placeOrder();
          },
          child: Text('Place Order'),
        ),
        Text(resultsDyn)
      ],
    );
  }
}

// ------------ Choose Payment ---------- //

// appBar

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
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => HomePage(index: 2),
                    ),
                  );
                },
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
