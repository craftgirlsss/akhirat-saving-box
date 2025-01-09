class ProfileModels {
  ProfileModels({
    required this.success,
    required this.message,
    required this.data,
  });
  late final bool success;
  late final String message;
  late final Data data;
  
  ProfileModels.fromJson(Map<String, dynamic> json){
    success = json['success'];
    message = json['message'];
    data = Data.fromJson(json['data']);
  }
}

class Data {
  Data({
    required this.name,
    required this.email,
    required this.img,
    required this.lastUpdate,
  });
  late final String name;
  late final String email;
  late final String img;
  late final String lastUpdate;
  
  Data.fromJson(Map<String, dynamic> json){
    name = json['name'];
    email = json['email'];
    img = json['img'];
    lastUpdate = json['last_update'];
  }
}