import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:test_eshopping/Models/order_response_model.dart';

class OrderService {
  OrderService();


Future<http.Response> saveOrder(OrderResponseModel order) async {
  try {
   
    final requestBody = {
      'cust_Id': order.custId, 
      'orderDate': order.orderDate?.toIso8601String(), 
      'netAmount': order.netAmount, 
      'orderDetailsList': order.orderDetailsList?.map((details) {
        return {
          'product_Id': details.productId, 
          'quantity': details.quantity, 
          'totalAmount': details.totalAmount, 
        };
      }).toList(),
    };

    print(requestBody);
    final response = await http.post(
      Uri.parse('http://localhost:5022/api/Order/AddOrder'), 
      body: jsonEncode(requestBody), 
      headers: {'Content-Type': 'application/json'}, 
    );

    return response;
  } catch (e) {
    
    print('Error in saveOrder: $e');
    rethrow;
  }
}

static Future<http.Response> getAllOrders(String custId) async {
    try {
      final response = await http.get(
        Uri.parse('http://localhost:5022/api/Order/GetOrdersByCustomer/$custId'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        print('Orders fetched successfully: ${response.body}');
      } else {
        print('Failed to fetch orders: ${response.statusCode} ${response.body}');
      }

      return response;
    } catch (e) {
      print('Error in getAllOrders: $e');
      rethrow;
    }
  }
}

  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
//   //  PUT: Update an order
//   static Future<http.Response> updateOrder(OrderResponseModel order) async {
//     Map<String, dynamic> mappedData = order.toJson();

//     var url = Uri.parse("${baseUrl}/api/Order/UpdateOrder");
//     var client = http.Client();

//     try {
//       http.Response response = await client.put(
//         url,
//         headers: {"Content-Type": "application/json"},
//         body: json.encode(mappedData),
//       );
//       return response;
//     } catch (e) {
//       print("Error: $e");
//       rethrow;
//     } finally {
//       client.close();
//     }
//   }

//   // DELETE: Delete an order by ID
//   static Future<http.Response> deleteOrder(int orderId) async {
//     var url = Uri.parse("${baseUrl}/api/Order/DeleteOrder/$orderId");
//     var client = http.Client();

//     try {
//       http.Response response = await client.delete(
//         url,
//         headers: {"Content-Type": "application/json"},
//       );
//       return response;
//     } catch (e) {
//       print("Error: $e");
//       rethrow;
//     } finally {
//       client.close();
//     }
//   }
// }
