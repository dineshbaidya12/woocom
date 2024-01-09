// ignore_for_file: unused_local_variable, prefer_interpolation_to_compose_strings

import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:woocommerce/config/config.dart';

class Product {
  final String name;
  final String price;
  final String imageUrl;

  Product({
    required this.name,
    required this.price,
    required this.imageUrl,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      name: json['name'],
      price: json['price'],
      imageUrl: json['imageUrl'],
    );
  }
}

class APIService {
  Future<List<Product>> fetchProducts() async {
    var authToken = base64.encode(
      utf8.encode(config.key + ":" + config.secret),
    );

    List<Product> products = [];

    try {
      // var response = await Dio().get(
      //   'http://dinesh/woocom/wp-json/wc/v3/products?consumer_key=ck_b229750febd5bad94432f2773ec8e0dc60285f6b&customer_secret=cs_4aced33b522f24dbdceed7adeeab9232c8668631',
      //   options: Options(
      //     headers: {
      //       'Authorization': 'Basic $authToken',
      //     },
      //   ),
      // );

      // var response = await Dio().get(
      //     'http://dinesh/woocom/wp-json/wc/v3/products?consumer_key=ck_b229750febd5bad94432f2773ec8e0dc60285f6b&consumer_secret=cs_4aced33b522f24dbdceed7adeeab9232c8668631');

      var response = await Dio().get(
        'http://dinesh/woocom/wp-json/wc/v3/products',
        options: Options(
          headers: {
            'Authorization': 'Bearer  ' +
                base64Encode(utf8.encode(
                    'ck_b229750febd5bad94432f2773ec8e0dc60285f6b:cs_4aced33b522f24dbdceed7adeeab9232c8668631')),
            'content-Type': 'application/json'
          },
        ),
      );

      if (response.statusCode == 200) {
        List<dynamic> data = response.data;
        products = data.map((json) => Product.fromJson(json)).toList();
      } else {
        throw Exception('Failed to fetch products: ${response.statusCode}');
      }
    } on DioException catch (e) {
      // Handle Dio errors
      print('DioError: $e');
    }

    return products;
  }
}
