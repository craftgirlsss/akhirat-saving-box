class LokasiDonaturModels {
  LokasiDonaturModels({
    required this.success,
    required this.message,
    required this.data,
  });
  late final bool success;
  late final String message;
  late final List<Data> data;
  
  LokasiDonaturModels.fromJson(Map<String, dynamic> json){
    success = json['success'];
    message = json['message'];
    data = List.from(json['data']).map((e)=>Data.fromJson(e)).toList();
  }
}

class Data {
  Data({
    required this.id,
     this.keterangan,
    required this.lat,
    required this.lng,
    required this.lastUpdate,
  });
  late final String id;
  late final String? keterangan;
  late final String lat;
  late final String lng;
  late final String lastUpdate;
  
  Data.fromJson(Map<String, dynamic> json){
    id = json['id'];
    keterangan = null;
    lat = json['lat'];
    lng = json['lng'];
    lastUpdate = json['last_update'];
  }
}