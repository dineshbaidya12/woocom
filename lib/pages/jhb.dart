// ignore_for_file: use_key_in_widget_constructors, library_private_types_in_public_api, use_super_parameters, prefer_const_constructors_in_immutables, avoid_print

import 'package:flutter/material.dart';

class MyWidget extends StatefulWidget {
  MyWidget({Key? key}) : super(key: key);

  @override
  _MyWidgetState createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }

  void updateCurrentIndex() {
    print('updateCurrentIndex called');
  }
}

class AnotherClass extends StatefulWidget {
  @override
  State<AnotherClass> createState() => _AnotherClassState();
}

class _AnotherClassState extends State<AnotherClass> {
  @override
  Widget build(BuildContext context) {
    GlobalKey<_MyWidgetState> myWidgetKey = GlobalKey<_MyWidgetState>();

    return Column(
      children: [
        MyWidget(
          key: myWidgetKey,
        ),
        ElevatedButton(
          onPressed: () {
            myWidgetKey.currentState?.updateCurrentIndex();
          },
          child: const Text('Call updateCurrentIndex'),
        ),
      ],
    );
  }
}
