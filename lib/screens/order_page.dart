import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:test_eshopping/Models/customer_response_model.dart';
import 'package:test_eshopping/Models/order_response_model.dart';
import 'package:test_eshopping/Models/product_response_model.dart';
import 'package:test_eshopping/apiservice/customerapiservice.dart';
import 'package:test_eshopping/apiservice/orderApiservice.dart';

import 'package:test_eshopping/apiservice/productapiservice.dart';
import 'package:test_eshopping/screens/custom_menu_page.dart';
import 'package:test_eshopping/utilsils/utilsils.dart';

class OrderPage extends StatefulWidget {
  const OrderPage({super.key});

  @override
  State<OrderPage> createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _searchController = TextEditingController();
  String? _selectedCustomerId;
  List<ResponseModel> _customers = [];
  List<ProductResponseModel> _products = [];
  List<ProductResponseModel> _filteredProducts = [];
  bool _showSearchField = false;
  List<ProductResponseModel> _selectedProducts = [];
  bool _isLoading = true;
  bool _showProducts = false;
  bool _showOrderSummary = false;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _fetchCustomers();
    _filteredProducts = _products;
    _searchController.addListener(_filterProducts);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterProducts() {
    setState(() {
      _filteredProducts = _products.where((product) {
        return product.productName
                ?.toLowerCase()
                .contains(_searchController.text.toLowerCase()) ??
            false;
      }).toList();
    });
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
        const SnackBar(content: Text('Failed to fetchmers')),
      );
    }
  }

  Future<void> _fetchProducts() async {
    setState(() {
      _isLoading = true;
      _showProducts = false;
    });

    try {
      List<ProductResponseModel> fetchedProducts =
          await ProductService.getAllProducts();
      setState(() {
        _products = fetchedProducts;
        _filteredProducts = _products;
        _showProducts = true;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to fetch products')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _incrementCounter(int index) {
    final product = _filteredProducts[index];
    final originalIndex =
        _products.indexWhere((p) => p.productId == product.productId);

    if (originalIndex != -1) {
      setState(() {
        if (_products[originalIndex].quantity == null) {
          _products[originalIndex].quantity = 0;
        }
        if ((_products[originalIndex].stock ?? 0) > 0) {
          _products[originalIndex].quantity =
              (_products[originalIndex].quantity ?? 0) + 1;
          _products[originalIndex].stock =
              (_products[originalIndex].stock ?? 0) - 1;
          _products[originalIndex].selected = true;

          _filterProducts();
        }
      });
    }
  }

  void _decrementCounter(int index) {
    final product = _filteredProducts[index];

    final originalIndex =
        _products.indexWhere((p) => p.productId == product.productId);

    if (originalIndex != -1) {
      setState(() {
        if (_products[originalIndex].quantity != null &&
            (_products[originalIndex].quantity ?? 0) > 0) {
          _products[originalIndex].quantity =
              (_products[originalIndex].quantity ?? 0) - 1;
          _products[originalIndex].stock =
              (_products[originalIndex].stock ?? 0) + 1;
          if (_products[originalIndex].quantity == 0) {
            _products[originalIndex].selected = false;
          }
          _filterProducts();
        }
      });
    }
  }

  Future<void> _pickDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (pickedDate != null) {
      setState(() {
        _dateController.text =
            "${pickedDate.day}/${pickedDate.month}/${pickedDate.year}";
      });
    }
  }

  void setOrderDetailsOrderDate(
      List<OrderResponseModel> orderDetailsList, DateTime orderDate) {
    for (var orderDetails in orderDetailsList) {
      orderDetails.orderDate ??= orderDate;
    }
  }

  void _placeOrder() {
    if (_selectedCustomerId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a customer')),
      );
      return;
    }
    setState(() {
      _selectedProducts =
          _products.where((product) => (product.quantity ?? 0) > 0).toList();
      _showOrderSummary = _selectedProducts.isNotEmpty;
    });

    if (_selectedProducts.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No products selected')),
      );
    } else {
      DateTime parsedDate =
          DateFormat('dd/MM/yyyy').parse(_dateController.text);
      setOrderDetailsOrderDate(
        _selectedProducts
            .map((product) {
              return OrderDetailsList(
                productId: product.productId!,
                quantity: product.quantity ?? 0,
                totalAmount: product.mrp! * (product.quantity ?? 0),
              );
            })
            .cast<OrderResponseModel>()
            .toList(),
        parsedDate,
      );
    }
  }

  double _calculateNetAmount() {
    return _selectedProducts.fold(0.0, (double sum, product) {
      final int quantity =
          int.tryParse(product.quantity?.toString() ?? '0') ?? 0;
      final double mrp =
          double.tryParse(product.mrp?.toString() ?? '0.0') ?? 0.0;
      return sum + (quantity * mrp);
    });
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
        title: const Text('Order Page', style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold)),
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
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(
              color: Color(0xff00838F),
            ))
          : SingleChildScrollView(
              controller: _scrollController,
              child: Padding(
                padding: EdgeInsets.all(padding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: padding),
                    Text(
                      'Select Details',
                      style: TextStyle(
                          fontSize: fontSize, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: padding),
                    SizedBox(
                      height: textFieldHeight,
                      child: DropdownButtonFormField<String>(
                        decoration: const InputDecoration(
                          labelText: 'Select Customer',
                          border: OutlineInputBorder(),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Color(0xff00838F), width: 2.0),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Color(0xff00838F), width: 1.0),
                          ),
                        ),
                        value: _selectedCustomerId,
                        items: _customers.map((customer) {
                          return DropdownMenuItem<String>(
                            value: customer.custID.toString(),
                            child: Text(customer.name ?? 'Unknown'),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            _selectedCustomerId = value;
                            // print('Selected Customer ID: $_selectedCustomerId');
                          });
                        },
                      ),
                    ),
                    SizedBox(height: padding),
                    SizedBox(
                      height: textFieldHeight,
                      child: TextField(
                        controller: _dateController,
                        readOnly: true,
                        decoration: InputDecoration(
                          labelText: 'Select Date',
                          border: const OutlineInputBorder(),
                          focusedBorder: const OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Color(0xff00838F), width: 2.0),
                          ),
                          enabledBorder: const OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Color(0xff00838F), width: 1.0),
                          ),
                          suffixIcon: IconButton(
                            icon: const Icon(
                              Icons.calendar_today,
                              color: Color(0xff00838F),
                            ),
                            onPressed: () => _pickDate(context),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: padding),
                    Center(
                      child: SizedBox(
                         width: buttonWidth > screenWidth(context, dividedBy: 2.5)
                  ? screenWidth(context, dividedBy: 2.5)
                  : buttonWidth,
              height: buttonHeight * 0.8 > screenHeight(context, dividedBy: 11)
                  ? screenHeight(context, dividedBy: 11)
                  : buttonHeight * 0.8,
                        child: ElevatedButton(
                          onPressed: () {
                            _fetchProducts();
                            setState(() {
                              _showSearchField = true;
                            });
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xff00838F),
                            foregroundColor: Colors.white,
                          ),
                          child: Text('Show Products',
                          style: TextStyle( fontSize: fontSize * 1.1,
                      fontWeight: FontWeight.bold,),),
                        ),
                      ),
                    ),
                    SizedBox(height: padding),
                    if (_showSearchField)
                      SizedBox(
                        height: textFieldHeight,
                        child: TextField(
                          controller: _searchController,
                          decoration: const InputDecoration(
                            labelText: 'Search Products',
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.search),
                          ),
                        ),
                      ),
                      SizedBox(height: padding/2,),
                    if (_showProducts) ...[
                      Text(
                        "Available Products",
                        style: TextStyle(
                            fontSize: fontSize, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: padding),
                      GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: screenWidth(context) > 800
                              ? 4
                              : screenWidth(context) > 500
                                  ? 3
                                  : 2,
                          crossAxisSpacing: screenWidth(context) * 0.02,
                          mainAxisSpacing: screenWidth(context) * 0.02,
                          childAspectRatio:
                              screenWidth(context) > 800 ? 1.3 : 0.8,
                        ),
                        itemCount: _filteredProducts.length,
                        itemBuilder: (context, index) {
                          ProductResponseModel product =
                              _filteredProducts[index];
                          return Card(
                            elevation: 4,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                  screenHeight(context) * 0.02),
                            ),
                            child: Padding(
                              padding:
                                  EdgeInsets.all(screenWidth(context) * 0.02),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    product.productName ?? 'No Name',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: fontSize,
                                    ),
                                  ),
                                  // Text(
                                  //   product.productId.toString(),
                                  //   style: TextStyle(
                                  //     fontWeight: FontWeight.bold,
                                  //     fontSize: MediaQuery.of(context).size.width * 0.03,
                                  //   ),
                                  // ),
                                  SizedBox(
                                      height: screenHeight(context) * 0.01),
                                  Text(
                                    'MRP: ₹${product.mrp ?? 'N/A'}',
                                    style: TextStyle(
                                      fontSize: fontSize,
                                    ),
                                  ),
                                  Text(
                                    product.stock == 0
                                        ? 'Out of Stock'
                                        : 'Stock: ${product.stock.toString()}',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: product.stock == 0
                                          ? Colors.red
                                          : Colors.black,
                                      fontSize: fontSize,
                                    ),
                                  ),
                                  const Spacer(),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      IconButton(
                                        icon: const Icon(Icons.remove),
                                        onPressed: () {
                                          _decrementCounter(index);
                                        },
                                      ),
                                      Text(
                                        '${product.quantity ?? 0}',
                                        style: TextStyle(
                                          fontSize: fontSize,
                                        ),
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.add),
                                        onPressed: () {
                                          _incrementCounter(index);
                                        },
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                    if (_showOrderSummary) _buildOrderSummary(),
                  ],
                ),
              ),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _placeOrder();
          _scrollController.animateTo(
            _scrollController.position.maxScrollExtent,
            duration: const Duration(seconds: 1),
            curve: Curves.easeInOut,
          );
        },
        backgroundColor: const Color(0xff00838F),
        child: const Icon(
          Icons.shopping_cart,
          color: Colors.white,
        ),
      ),
    );
  }


  Widget _buildOrderSummary() {
    return Card(
      elevation: 4,
      margin:
          EdgeInsets.symmetric(vertical: screenWidth(context, dividedBy: 30)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Order Summary',
              style: TextStyle(
                  fontSize: screenHeight(context, dividedBy: 40),
                  fontWeight: FontWeight.bold),
            ),
            const Divider(),
            ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.4,
              ),
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: _selectedProducts.length,
                itemBuilder: (context, index) {
                  final product = _selectedProducts[index];
                  final int quantity =
                      int.tryParse(product.quantity?.toString() ?? '0') ?? 0;
                  final double mrp =
                      double.tryParse(product.mrp?.toString() ?? '0.0') ?? 0.0;
                  final double total = mrp * quantity;

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            product.productName ?? 'No Name',
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          Text(
                            '₹$total',
                            style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Color(0xff00838F),
                                fontSize: 16),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text('Quantity: $quantity',
                          style: const TextStyle(color: Colors.grey)),
                      const Divider(),
                    ],
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Net Amount',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xff00838F),
                  ),
                ),
                Text(
                  '₹${_calculateNetAmount().toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xff00838F),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Center(
              child: SizedBox(
                 width:  screenWidth(context, dividedBy: 2.5),
                  
                 
              height: screenHeight(context, dividedBy: 11),
                  
                child: ElevatedButton(
                  onPressed: () async {
                    if (_selectedCustomerId == null ||
                        _dateController.text.isEmpty ||
                        !_products.any((product) => product.selected)) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Please complete all required fields!'),
                        ),
                      );
                      return;
                    }
                    DateTime parsedDate =
                        DateFormat('dd/MM/yyyy').parse(_dateController.text);
                    DateFormat('yyyy-MM-dd').format(parsedDate);
                
                    List<OrderDetailsList> productOrders = _products
                        .where((product) => product.selected)
                        .map((product) {
                      final int quantity =
                          int.tryParse(product.quantity?.toString() ?? '0') ?? 0;
                      final double mrp =
                          double.tryParse(product.mrp?.toString() ?? '0.0') ??
                              0.0;
                      final double totalAmount = mrp * quantity;
                
                      return OrderDetailsList(
                        productId: product.productId!,
                        quantity: quantity,
                        totalAmount: totalAmount,
                      );
                    }).toList();
                
                    // print(
                    //     'Order Details: ${productOrders.map((order) => order.toString()).join(', ')}');
                    OrderResponseModel order = OrderResponseModel(
                      custId: int.parse(_selectedCustomerId!),
                      orderDate: parsedDate,
                      netAmount: _calculateNetAmount().toDouble(),
                      orderDetailsList: productOrders,
                    );
                
                    // print('Order Data: ${order.toString()}');
                    try {
                      final response = await OrderService().saveOrder(order);
                
                      if (response.statusCode == 200) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text('Order saved successfully!')),
                        );
                      } else {
                        print('Error response body: ${response.body}');
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                                'Failed to save order: ${response.statusCode}'),
                          ),
                        );
                      }
                    } catch (e) {
                      print('Error details: $e');
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Failed to save order')),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xff00838F),
                    foregroundColor: Colors.white,
                  ),
                  child: Text('Save Order',style: TextStyle(fontSize:screenHeight(context, dividedBy: 40),fontWeight: FontWeight.bold ),),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
