class Profile {
  bool? status;
  String? message;
  UserData? userData;

  Profile.fromJson(Map<String, dynamic> json){
    status = json['status'];
    message = json['message'];
    userData = json['data'] != null? UserData.fromJson(json['data']): null;
  }

  toJson(){
    return {
      'status': status,
      'message': message,
      'data': UserData().toJson()
    };
  }
}
class UserData {
  String? name;
  String? email;
  String? phone;
  String? image;
  String? token;
  int? points;


  UserData({this.name, this.email, this.phone, this.image, this.points, this.token});

  UserData.fromJson(Map<String, dynamic> json){
    name = json['name'];
    email = json['email'];
    phone = json['phone'];
    image = json['image'];
    token = json['token'];
    points = json['points'];
  }

  toJson() {
    return {
      'name': name,
      'email': email,
      'phone': phone,
      'image': image,
      'points': points
    };
  }
}