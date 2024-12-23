class ResponseModel {
  int? custID;
  String? name;
  // int? quantity;
  String? phoneNumber;
  String? address;

  ResponseModel(
      {this.custID, this.name, this.phoneNumber, this.address});

  ResponseModel.fromJson(Map<String, dynamic> json) {
    custID = json['cust_ID'];
    name = json['name'];
    // quantity = json['quantity'];
    phoneNumber = json['phone_number'];
    address = json['address'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['cust_ID'] = this.custID;
    data['name'] = this.name;
    // data['quantity'] = this.quantity;
    data['phone_number'] = this.phoneNumber;
    data['address'] = this.address;
    return data;
  }
}