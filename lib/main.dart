import 'package:books_app/cart_provider.dart';
import 'package:books_app/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => CartProvider(),
      child: Builder(builder: (BuildContext context) {
        return const MaterialApp(
          debugShowCheckedModeBanner: false,
          home: MySplashScreen(),
        );
      }),
    );
  }
}
