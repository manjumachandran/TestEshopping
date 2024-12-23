import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:test_eshopping/Models/customer_response_model.dart';
import 'package:test_eshopping/apiservice/customerapiservice.dart';
import 'package:test_eshopping/screens/custom_menu_page.dart';
import 'package:test_eshopping/utilsils/utilsils.dart';

class Customers extends StatefulWidget {
  final ResponseModel? existingCustomer;
  const Customers({super.key, this.existingCustomer});

  @override
  State<Customers> createState() => _CustomersState();
}

class _CustomersState extends State<Customers> {
  late TextEditingController _nameController;
  late TextEditingController _addressController;
  late TextEditingController _phoneController;

  @override
  void initState() {
    super.initState();
    _nameController =
        TextEditingController(text: widget.existingCustomer?.name ?? '');
    _phoneController =
        TextEditingController(text: widget.existingCustomer?.phoneNumber ?? '');
    _addressController =
        TextEditingController(text: widget.existingCustomer?.address ?? '');
  }

  Future<void> saveCustomer() async {
    final newCustomer = ResponseModel(
      custID: widget.existingCustomer?.custID ?? 1,
      name: _nameController.text.trim(),
      phoneNumber: _phoneController.text.trim(),
      address: _addressController.text.trim(),
    );

    try {
      http.Response response;
      if (widget.existingCustomer == null) {
        response = await CustomerService.postCustomer(newCustomer);
      } else {
        response = await CustomerService.updateCustomer(newCustomer);
      }

      if (response.statusCode == 200 || response.statusCode == 201) {
        _nameController.clear();
        _addressController.clear();
        _phoneController.clear();

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(widget.existingCustomer == null
                ? 'Customer added successfully!'
                : 'Customer updated successfully!'),
          ),
        );
      } else if (response.statusCode == 409) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content:
                  Text('A customer with this phone number already exists.')),
        );
      } else {
        throw Exception(
            'Failed to save customer. Status code: ${response.statusCode}');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    final double padding = screenWidth(context, dividedBy: 20);
    final double textFieldHeight = screenHeight(context, dividedBy: 15);
    final double buttonWidth = ResponsiveUtils.getButtonWidth(context);
    final double buttonHeight = ResponsiveUtils.getButtonHeight(context);
    final double fontSize = screenHeight(context, dividedBy: 40);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xff00838F),
        title: Text(
          widget.existingCustomer == null ? 'Add Customer' : 'Edit Customer',
          style: TextStyle(
            fontSize: fontSize * 1.3,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
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
            SizedBox(height: padding),
            SizedBox(
              height: textFieldHeight,
              child: TextField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Name',
                  labelStyle: TextStyle(fontSize: fontSize),
                  border: const OutlineInputBorder(),
                  focusedBorder: const OutlineInputBorder(
                    borderSide:
                        BorderSide(color: Color(0xff00838F), width: 2.0),
                  ),
                  enabledBorder: const OutlineInputBorder(
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
                controller: _addressController,
                decoration: InputDecoration(
                  labelText: 'Address',
                  labelStyle: TextStyle(fontSize: fontSize),
                  border: const OutlineInputBorder(),
                  focusedBorder: const OutlineInputBorder(
                    borderSide:
                        BorderSide(color: Color(0xff00838F), width: 2.0),
                  ),
                  enabledBorder: const OutlineInputBorder(
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
                controller: _phoneController,
                decoration: InputDecoration(
                  labelText: 'Phone Number',
                  labelStyle: TextStyle(fontSize: fontSize),
                  border: const OutlineInputBorder(),
                  focusedBorder: const OutlineInputBorder(
                    borderSide:
                        BorderSide(color: Color(0xff00838F), width: 2.0),
                  ),
                  enabledBorder: const OutlineInputBorder(
                    borderSide:
                        BorderSide(color: Color(0xff00838F), width: 1.0),
                  ),
                ),
                keyboardType: TextInputType.phone,
              ),
            ),
            SizedBox(height: padding * 0.9),
            SizedBox(
              width: buttonWidth > screenWidth(context, dividedBy: 2.5)
                  ? screenWidth(context, dividedBy: 2.5)
                  : buttonWidth,
              height: buttonHeight * 0.8 > screenHeight(context, dividedBy: 11)
                  ? screenHeight(context, dividedBy: 11)
                  : buttonHeight * 0.8,
              child: ElevatedButton(
                onPressed: saveCustomer,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xff00838F),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(buttonHeight * 0.3),
                  ),
                ),
                child: FittedBox(
                  child: Text(
                    widget.existingCustomer == null
                        ? 'Add Customer'
                        : 'Update Customer',
                    style: TextStyle(
                      fontSize: fontSize * 1.2,
                      fontWeight: FontWeight.bold,
                    ),
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
