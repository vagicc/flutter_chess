import 'package:flutter/material.dart';
import 'routes/main_menu.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  static const StatusBarHeight = 28.0;

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.brown,
        fontFamily: 'Chess', //主题颜色
      ),
      home: const MainMenu(),
      debugShowCheckedModeBanner: false, //去掉右上角的“debug"
    );
  }
}
