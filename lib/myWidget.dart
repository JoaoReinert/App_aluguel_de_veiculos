import 'package:flutter/material.dart';
import 'pages/HomePage/homePage.dart';
import 'theme.dart';

class MyWidget extends StatelessWidget {
  const MyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: theme,
        initialRoute: '/homePage',
        routes: {
          '/homePage' : (context) => const HomePage(),
        },
    );
  }
}