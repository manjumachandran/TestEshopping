// To parse this JSON data, do
//
//     final orderResponseModel = orderResponseModelFromJson(jsonString);

import 'dart:convert';

OrderResponseModel orderResponseModelFromJson(String str) => OrderResponseModel.fromJson(json.decode(str));

String orderResponseModelToJson(OrderResponseModel data) => json.encode(data.toJson());

class OrderResponseModel {
  // final int? orderID;
     DateTime? orderDate;
    final int? custId;
    final double? netAmount;
    final List<OrderDetailsList>? orderDetailsList;

    OrderResponseModel({
        this.orderDate,
        this.custId,
        this.netAmount,
        this.orderDetailsList,
        // this.orderID,
    });

    factory OrderResponseModel.fromJson(Map<String, dynamic> json) => OrderResponseModel(
      // orderID: json["OrderID"],
      orderDate: json["orderDate"] == null ? null : DateTime.parse(json["orderDate"]),
        custId: json["cust_ID"],
        netAmount: json["netAmount"],
        orderDetailsList: json["orderDetailsList"] == null ? [] : List<OrderDetailsList>.from(json["orderDetailsList"]!.map((x) => OrderDetailsList.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "OrderID"
        "orderDate": orderDate?.toIso8601String(),
        "cust_ID": custId,
        "netAmount": netAmount,
        "orderDetailsList": orderDetailsList == null ? [] : List<dynamic>.from(orderDetailsList!.map((x) => x.toJson())),
    };
    @override
  String toString() {
    return 'OrderResponseModel(custId: $custId, orderDate: $orderDate, netAmount: $netAmount, orderDetailsList: [${orderDetailsList?.join(', ')}])';
  }
}


class OrderDetailsList {
    
    final int? productId;
    final dynamic totalAmount;
    final int? quantity;

    OrderDetailsList({
       
        this.productId,
        this.totalAmount,
        this.quantity,
    });

    factory OrderDetailsList.fromJson(Map<String, dynamic> json) => OrderDetailsList(
      
        productId: json["product_Id"],
        totalAmount: json["totalAmount"],
        quantity: json["quantity"],
    );

    Map<String, dynamic> toJson() => {
        
        "product_Id": productId,
        "totalAmount": totalAmount,
        "quantity": quantity,
    };
     @override
  String toString() {
    return 'OrderDetailsList(productId: $productId, totalAmount: $totalAmount, quantity: $quantity, )';
  }
}
// void setOrderDetailsOrderDate(List<OrderDetailsList> orderDetailsList, DateTime orderDate) {
//   for (var orderDetails in orderDetailsList) {
//     orderDetails.orderDate ??= orderDate;
//   }
// }
