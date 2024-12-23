import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:test_eshopping/Models/product_response_model.dart';

class ProductService {
  static const String baseUrl = "http://localhost:5022";

 
  static Future<http.Response> addProduct(ProductResponseModel product) async {
    Map<String, dynamic> mappedData = product.toJson();
    var url = Uri.parse("$baseUrl/api/Product/AddProduct");
    var client = http.Client();

    try {
      http.Response response = await client.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: json.encode(mappedData),
      );
      return response;
    } catch (e) {
      print("Error: $e");
      rethrow;
    } finally {
      client.close();
    }
  }

  static Future<List<ProductResponseModel>> getAllProducts() async {
    var url = Uri.parse("$baseUrl/api/Product/GetAllProducts");
    var client = http.Client();

    try {
      final response = await client.get(
        url,
        headers: {"Content-Type": "application/json"},
      );

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        
      return data.map<ProductResponseModel>((productjson) {
          return ProductResponseModel.fromJson(productjson);
        }).toList();
      } else {
        print("Error: ${response.statusCode} - ${response.body}");
        return [];
      }
    } catch (e) {
      print("Exception: $e");
      return [];
    } finally {
      client.close();
    }
  }
}


 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
  // // Update product details
  // static Future<http.Response> updateProduct(ProductResponseModel product) async {
  //   Map<String, dynamic> mappedData = product.toJson();
  //   var url = Uri.parse("$baseUrl/api/Product/UpdateProduct");
  //   var client = http.Client();

  //   try {
  //     http.Response response = await client.put(
  //       url,
  //       headers: {"Content-Type": "application/json"},
  //       body: json.encode(mappedData),
  //     );
  //     return response;
  //   } catch (e) {
  //     print("Error: $e");
  //     rethrow;
  //   } finally {
  //     client.close();
  //   }
  // }

  // // Delete a product by ID
  // static Future<http.Response> deleteProduct(String productId) async {
  //   var url = Uri.parse("$baseUrl/api/Product/DeleteProduct/$productId");
  //   var client = http.Client();

  //   try {
  //     http.Response response = await client.delete(
  //       url,
  //       headers: {"Content-Type": "application/json"},
  //     );
  //     return response;
  //   } catch (e) {
  //     print("Error: $e");
  //     rethrow;
  //   } finally {
  //     client.close();
  //   }
  // }

