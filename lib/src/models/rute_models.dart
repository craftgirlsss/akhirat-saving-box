class RuteModels {
  RuteModels({
    required this.success,
    required this.message,
    required this.data,
  });
  late final bool success;
  late final String message;
  late final List<Data> data;
  
  RuteModels.fromJson(Map<String, dynamic> json){
    success = json['success'];
    message = json['message'];
    data = List.from(json['data']).map((e)=>Data.fromJson(e)).toList();
  }
}

class Data {
  Data({
    this.id,
    this.name,
    this.lat,
    this.lng,
    this.lastUpdate,
  });
  String? id;
  String? name;
  String? lat;
  String? lng;
  String? lastUpdate;
  
  Data.fromJson(Map<String, dynamic> json){
    id = json['id'];
    name = json['name'];
    lat = json['lat'];
    lng = json['lng'];
    lastUpdate = null;
  }
}