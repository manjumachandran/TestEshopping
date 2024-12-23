import 'package:flutter/material.dart';
import 'package:test_eshopping/Models/product_response_model.dart';
import 'package:test_eshopping/apiservice/productapiservice.dart';
import 'package:test_eshopping/screens/custom_menu_page.dart';
import 'package:test_eshopping/utilsils/utilsils.dart';

class Products extends StatefulWidget {
  const Products({super.key});

  @override
  State<Products> createState() => _ProductsState();
}

class _ProductsState extends State<Products> {
  final TextEditingController _productNameController = TextEditingController();
  final TextEditingController _mrpController = TextEditingController();
  final TextEditingController _stockController = TextEditingController();

  Future<void> addProduct() async {
    final newProduct = ProductResponseModel(
      productId: 1,
      stock: int.tryParse(_stockController.text.trim()) ?? 0,
      productName: _productNameController.text.trim(),
      mrp: _mrpController.text.trim(),
    );

    try {
      final response = await ProductService.addProduct(newProduct);

      if (response.statusCode == 200 || response.statusCode == 201) {
        _productNameController.clear();
        _mrpController.clear();
        _stockController.clear();

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Product added successfully!')),
        );
      } else {
        throw Exception(
            'Failed to add product. Status code: ${response.statusCode}');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final double padding = screenWidth(context, dividedBy: 30);
    final double textFieldHeight = screenHeight(context, dividedBy: 15);
    final double buttonWidth = ResponsiveUtils.getButtonWidth(context);
    final double buttonHeight = ResponsiveUtils.getButtonHeight(context);
    final double fontSize = screenHeight(context, dividedBy: 40);

    return Scaffold(
      appBar: AppBar(
        title:
            const Text('Add Products', style: TextStyle(color: Colors.white)),
        backgroundColor: Color(0xff00838F),
        leading: Builder(
          builder: (context) {
            return IconButton(
              icon: const Icon(Icons.menu, color: Colors.white),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            );
          },
        ),
      ),
      drawer: const CustomMenuWidget(),
      body: Padding(
        padding: EdgeInsets.all(padding),
        child: Column(
          children: [
            SizedBox(height: padding * 3),
            SizedBox(
              height: textFieldHeight,
              child: TextField(
                controller: _productNameController,
                decoration: const InputDecoration(
                  labelText: 'Product Name',
                  border: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: Color(0xff00838F), width: 2.0),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: Color(0xff00838F), width: 1.0),
                  ),
                ),
              ),
            ),
            SizedBox(height: padding),
            SizedBox(
              height: textFieldHeight,
              child: TextField(
                controller: _mrpController,
                decoration: const InputDecoration(
                  labelText: 'MRP',
                  border: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: Color(0xff00838F), width: 2.0),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: Color(0xff00838F), width: 1.0),
                  ),
                ),
                keyboardType: TextInputType.number,
              ),
            ),
            SizedBox(height: padding),
            SizedBox(
              height: textFieldHeight,
              child: TextField(
                controller: _stockController,
                decoration: const InputDecoration(
                  labelText: 'Stock',
                  border: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: Color(0xff00838F), width: 2.0),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: Color(0xff00838F), width: 1.0),
                  ),
                ),
                keyboardType: TextInputType.number,
              ),
            ),
            SizedBox(height: padding * 2),
            SizedBox(
              width: buttonWidth > screenWidth(context, dividedBy: 2.5)
                  ? screenWidth(context, dividedBy: 2.5)
                  : buttonWidth,
              height: buttonHeight * 0.8 > screenHeight(context, dividedBy: 11)
                  ? screenHeight(context, dividedBy: 11)
                  : buttonHeight * 0.8,
              child: ElevatedButton(
                onPressed: addProduct,
                style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xff00838F),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(buttonHeight * 0.3))),
                child: Text(
                  'Add Product',
                  style: TextStyle(
                    fontSize: fontSize * 1.2,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
