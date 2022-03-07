class Profile {
  bool? status;
  String? message;
  UserData? userData;

  Profile.fromJson(Map<String, dynamic> json){
    status = json['status'];
    message = json['message'];
    userData = UserData.fromJson(json['data']);
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
  int? points;


  UserData({this.name, this.email, this.phone, this.image, this.points});

  UserData.fromJson(Map<String, dynamic> json){
    name = json['name'];
    email = json['email'];
    phone = json['phone'];
    image = json['image'];
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