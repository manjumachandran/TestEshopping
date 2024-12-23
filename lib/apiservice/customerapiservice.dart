import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:test_eshopping/Models/customer_response_model.dart';

class CustomerService {
  static const String baseUrl = "http://localhost:5022";

  static Future<http.Response> postCustomer(ResponseModel responseModel) async {
    Map<String, dynamic> mappedData = responseModel.toJson();

    var url = Uri.parse("http://localhost:5022/api/Customer/AddAllCustomers");
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

  static Future<List<ResponseModel>> getAllCustomers() async {
    var url = Uri.parse("$baseUrl/api/Customer/GetAllCustomer");
    var client = http.Client();

    try {
      final response = await client.get(
        url,
        headers: {"Content-Type": "application/json"},
      );

      if (response.statusCode == 200) {
        List<dynamic> jsonData = jsonDecode(response.body);

        return jsonData
            .map<ResponseModel>((customer) => ResponseModel.fromJson(customer))
            .toList();
      } else {
        throw Exception(
            "Failed to fetch customers. Status Code: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Error fetching customers: $e");
    } finally {
      client.close();
    }
  }

  static Future<http.Response> updateCustomer(
      ResponseModel responseModel) async {
    Map<String, dynamic> mappedData = responseModel.toJson();

    var url = Uri.parse(
        "${baseUrl}/api/Customer/UpdateCustomer/${responseModel.custID}");
    var client = http.Client();

    try {
      http.Response response = await client.put(
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

  static Future<http.Response> deleteCustomer(
      ResponseModel responseModel) async {
    Map<String, dynamic> mappedData = responseModel.toJson();
    var url = Uri.parse(
        "${baseUrl}/api/Customer/DeleteCustomer/${responseModel.custID}");
    var client = http.Client();

    try {
      http.Response response = await client.delete(
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
}
