import 'package:flutter/material.dart';
import 'package:woocommerce/pages/homepage.dart';
import 'package:woocommerce/pages/productpage.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Woocom',
      theme: ThemeData(
        fontFamily: 'Kanit',
        primaryColor: Colors.red,
      ),
      home: const HomePage(),
    );
  }
}
