import 'package:flutter/material.dart';
import 'package:easy_splash_screen/easy_splash_screen.dart';
import 'home_page.dart';

class MySplashScreen extends StatefulWidget {
  const MySplashScreen({Key? key}) : super(key: key);

  @override
  State<MySplashScreen> createState() => _MySplashScreenState();
}

class _MySplashScreenState extends State<MySplashScreen> {
  @override
  Widget build(BuildContext context) {
    return EasySplashScreen(
      logo: Image.asset('assets/books.png'),
      durationInSeconds: 3,
      navigator: const HomePage(),
      showLoader: true,
      loaderColor: Colors.pink,
      loadingText: const Text('Loading.....\nPlease wait'),

    );
  }
}
