import 'package:flutter/material.dart';
import 'package:test_eshopping/Models/customer_response_model.dart';
import 'package:test_eshopping/apiservice/customerapiservice.dart';
import 'package:test_eshopping/screens/custom_menu_page.dart';
import 'package:test_eshopping/screens/customers_page.dart';
import 'package:test_eshopping/screens/your_order_page.dart';
import 'package:test_eshopping/utilsils/utilsils.dart';

class CustomersList extends StatefulWidget {
  const CustomersList({super.key});

  @override
  State<CustomersList> createState() => _CustomersListState();
}

class _CustomersListState extends State<CustomersList> {
  bool _isLoading = true;
  List<ResponseModel> _customers = [];

  @override
  void initState() {
    super.initState();
    _fetchCustomers();
  }

  Future<void> _fetchCustomers() async {
    setState(() {
      _isLoading = true;
    });

    try {
      List<ResponseModel> customers = await CustomerService.getAllCustomers();
      setState(() {
        _customers = customers;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to fetch customers')),
      );
    }
  }

  void _navigateToEditPage(BuildContext context, ResponseModel customer) async {
    final updatedCustomer = await Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => Customers(existingCustomer: customer),
      ),
    );

    if (updatedCustomer != null) {
      _fetchCustomers();
    }
  }

  void _deleteCustomer(int custID) async {
    bool confirmDelete = await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Confirm Deletion'),
          content: const Text('Are you sure you want to delete this customer?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text(
                'Cancel',
                style: TextStyle(color: Color(0xff00838F)),
              ),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text(
                'Delete',
                style: TextStyle(
                  color: Colors.red,
                ),
              ),
            ),
          ],
        );
      },
    );

    if (!confirmDelete) return;

    try {
      final response =
          await CustomerService.deleteCustomer(ResponseModel(custID: custID));
      if (response.statusCode == 200) {
        setState(() {
          _customers.removeWhere((customer) => customer.custID == custID);
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Customer deleted successfully')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('Failed to delete customer: ${response.body}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
     final double padding = screenWidth(context, dividedBy: 20);
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Customers List',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xff00838F),
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
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(color:Color(0xff00838F)),
            )
          : _customers.isEmpty
              ? const Center(
                  child: Text('No customers found.'),
                )
              : ListView.builder(
                  itemCount: _customers.length,
                  itemBuilder: (context, index) {
                    final customer = _customers[index];
                    return Card(
                      margin:  EdgeInsets.symmetric(
                          horizontal: padding/2, vertical: padding/4),
                      child: ListTile(
                        contentPadding:  EdgeInsets.all(padding/2),
                        leading: CircleAvatar(
                          radius: screenHeight(context, dividedBy: 20),
                          backgroundColor: const Color(0xff00838F),
                          child: Text(
                            customer.name![0].toUpperCase(),
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                        title: Text(
                          customer.name ?? 'Unknown',
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Customer ID: ${customer.custID}'),
                            Text('Phone: ${customer.phoneNumber}'),
                            Text('Address: ${customer.address}'),
                          ],
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit,
                                  color: Color(0xff00838F)),
                              onPressed: () =>
                                  _navigateToEditPage(context, customer),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () {
                                _deleteCustomer(customer.custID!);
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.shopping_cart,
                                  color: Color(0xff00838F)),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => YourOrdersPage(
                                        custId: customer.custID.toString()),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
