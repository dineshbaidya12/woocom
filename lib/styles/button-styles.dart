// ignore_for_file: unused_import, file_names

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
