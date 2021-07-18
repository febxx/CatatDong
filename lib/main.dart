import 'package:flutter/material.dart';
import 'package:CatatDong/views/home_view.dart';
void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Catat Dong',
      home: MyHomePage(),
    );
  }
}