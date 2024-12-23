import 'package:flutter/material.dart';
import 'package:test_eshopping/screens/home_page.dart'; // Import HomePage
import 'package:test_eshopping/screens/customer_actions.dart'; // Import CustomerActionPage
import 'package:test_eshopping/screens/order_page.dart'; // Import OrderPage
import 'package:test_eshopping/screens/products_page.dart'; // Import ProductsPage
import 'package:test_eshopping/screens/splash_screen.dart'; // Import SplashScreen

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'E-Shopping',
      debugShowCheckedModeBanner: false,
      initialRoute: '/', 
      routes: {
        '/': (context) => const SplashScreen(), 
        '/home': (context) => const HomePage(), 
        '/customers': (context) => const CustomerActionPage(),
        '/products': (context) => const Products(),
        '/orders': (context) => const OrderPage(),
      },
    );
  }
}
