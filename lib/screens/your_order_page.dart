import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:intl/intl.dart';
import '../apiservice/orderApiservice.dart';

class YourOrdersPage extends StatefulWidget {
  final String custId;

  const YourOrdersPage({super.key, required this.custId});

  @override
  State<YourOrdersPage> createState() => _YourOrdersPageState();
}

class _YourOrdersPageState extends State<YourOrdersPage> {
  bool _isLoading = false;
  List<dynamic> _orders = [];

  Future<void> _fetchOrders() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final response = await OrderService.getAllOrders(widget.custId);

      if (response.statusCode == 200) {
        final List<dynamic> orders = jsonDecode(response.body);
        setState(() {
          _orders = orders;
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to fetch orders: ${response.body}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to fetch orders')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchOrders(); 
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Orders',
        style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xff00838F),
         iconTheme: const IconThemeData(
          color: Colors.white,
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _orders.isEmpty
              ? const Center(child: Text('No orders found.'))
              : ListView.builder(
  itemCount: _orders.length,
  itemBuilder: (context, index) {
    final order = _orders[index];
    final orderDate = DateTime.parse(order['orderDate']);
    final formattedDate = DateFormat('yyyy-MM-dd').format(orderDate);

  
    final orderDetailsList = order['orderDetailsList'] as List<dynamic>;

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: ExpansionTile(
        title: Text('Order ID: ${order['orderID']}'),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Net Amount: \$${order['netAmount']}'),
            Text('Order Date: $formattedDate'),
          ],
        ),
        children: orderDetailsList.map((details) {
          return ListTile(
            title: Text('Product ID: ${details['product_Id']}'),
            subtitle: Text('Quantity: ${details['quantity']}'),
            trailing: Text('Total Amount: \$${details['totalAmount']}'),
          );
        }).toList(),
      ),
    );
  },
),

    );
  }
}
