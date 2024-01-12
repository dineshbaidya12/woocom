// ------- Product Page ------------//
//
//
//
// ignore_for_file: prefer_const_constructors, use_key_in_widget_constructors

import 'package:flutter/material.dart';

class ProductScreen extends StatefulWidget {
  final int productId;
  const ProductScreen({required this.productId});

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(widget.productId.toString()),
    );
  }
}

//
//
//
// ------- Product Page ------------//