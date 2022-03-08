import 'package:shop_app/main.dart';

class RegisterModel {
  bool? status;
  String? message;
  UserData? userData;

  RegisterModel.fromJson(Map<String, dynamic> json){
    status = json['status'];
    message = json['message'];
    userData = json['data'] != null?UserData.fromJson(json['data']): null;
  }
}
class UserData {
  String? name;
  String? email;
  String? phone;
  String? image;
  String? token;

  UserData.fromJson(Map<String, dynamic> json){
    name = json['name'];
    email = json['email'];
    phone = json['phone'];
    image = json['image'];
    token = json['token'];
  }
}