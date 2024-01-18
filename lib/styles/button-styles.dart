// ignore_for_file: unused_import, file_names, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:woocommerce/pages/homepage.dart';

final ButtonStyle moreDetails = ElevatedButton.styleFrom(
  minimumSize: const Size(120, 40),
  backgroundColor: const Color.fromARGB(255, 219, 159, 29),
  elevation: 0,
  foregroundColor: Colors.black,
  shape: const RoundedRectangleBorder(
    borderRadius: BorderRadius.all(
      Radius.circular(5),
    ),
  ),
);

final ButtonStyle addToCart = ElevatedButton.styleFrom(
  minimumSize: const Size(140, 50),
  backgroundColor: Color.fromARGB(255, 7, 165, 126),
  elevation: 0,
  foregroundColor: Colors.white,
  shape: const RoundedRectangleBorder(
    borderRadius: BorderRadius.all(
      Radius.circular(2),
    ),
  ),
);
final ButtonStyle outOfStock = ElevatedButton.styleFrom(
  minimumSize: const Size(140, 50),
  backgroundColor: Colors.grey,
  elevation: 0,
  foregroundColor: Colors.white,
  shape: const RoundedRectangleBorder(
    borderRadius: BorderRadius.all(
      Radius.circular(2),
    ),
  ),
);
final ButtonStyle seeAllProduct = ElevatedButton.styleFrom(
  minimumSize: const Size(120, 30),
  backgroundColor: const Color.fromARGB(255, 7, 111, 172),
  elevation: 0,
  foregroundColor: Colors.black,
  shape: const RoundedRectangleBorder(
    borderRadius: BorderRadius.all(
      Radius.circular(5),
    ),
  ),
);
