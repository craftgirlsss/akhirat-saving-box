class TempatPengambilanModels {
  TempatPengambilanModels({
    this.success,
    this.message,
    this.data,
  });
  bool? success;
  String? message;
  List<Data>? data;
  
  TempatPengambilanModels.fromJson(Map<String, dynamic> json){
    success = json['success'];
    message = json['message'];
    data = List.from(json['data']).map((e)=>Data.fromJson(e)).toList();
  }
}

class Data {
  Data({
    this.name,
    this.code,
    this.address,
    this.thumbnail,
    this.available,
    this.lastUpdate,
  });
  String? name;
  String? code;
  String? address;
  String? thumbnail;
  String? available;
  String? lastUpdate;
  
  Data.fromJson(Map<String, dynamic> json){
    name = json['name'];
    code = json['code'];
    address = json['address'];
    thumbnail = json['thumbnail'];
    available = json['available'];
    lastUpdate = json['last_update'];
  }
}