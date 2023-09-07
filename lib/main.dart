import 'package:flutter/material.dart';
import 'package:mask_detection/home.dart';

void main()=> runApp(new MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(brightness: Brightness.dark,
      primaryColor: Colors.tealAccent),
      debugShowCheckedModeBanner: false,
      home: const Home(),
    );

  }
}
