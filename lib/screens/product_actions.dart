import 'package:flutter/material.dart';

class ProductActoions extends StatefulWidget {
  const ProductActoions({super.key});

  @override
  State<ProductActoions> createState() => _ProductActoionsState();
}

class _ProductActoionsState extends State<ProductActoions> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:Container(
        child:Image.asset("assets/images/background.jpg")
      ),
    );
  }
}