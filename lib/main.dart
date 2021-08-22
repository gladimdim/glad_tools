import 'package:flutter/material.dart';
import 'package:glad_tools/views/main_view.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Super tools',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MainView(),
    debugShowCheckedModeBanner: false,
    );
  }
}
