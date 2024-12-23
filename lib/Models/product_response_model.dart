// To parse this JSON data, do
//
//     final productResponseModel = productResponseModelFromJson(jsonString);

import 'dart:convert';

ProductResponseModel productResponseModelFromJson(String str) => ProductResponseModel.fromJson(json.decode(str));

String productResponseModelToJson(ProductResponseModel data) => json.encode(data.toJson());

class ProductResponseModel {
 final dynamic productId; 
  final String? productName;
  final String? mrp;
   dynamic quantity;
  bool selected; 
   int? stock;

  ProductResponseModel({
     this.productId, 
    this.productName,
    this.mrp,
    this.quantity = 0, 
    this.selected = false, 
     this.stock,
    
  });

  factory ProductResponseModel.fromJson(Map<String, dynamic> json) => ProductResponseModel(
     productId: json["product_id"], 
    productName: json["product_name"],
    mrp: json["mrp"],
    quantity: 0, 
     stock: json["stock"],
  );

  Map<String, dynamic> toJson() => {
     "product_id": productId, 
    "product_name": productName,
    "mrp": mrp,
    "quantity": quantity,
     "stock": stock,
  };
}
