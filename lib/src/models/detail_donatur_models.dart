class DetailDonaturModels {
  DetailDonaturModels({
    required this.success,
    required this.message,
    required this.data,
  });
  late final bool success;
  late final String message;
  late final Data data;
  
  DetailDonaturModels.fromJson(Map<String, dynamic> json){
    success = json['success'];
    message = json['message'];
    data = Data.fromJson(json['data']);
  }
}

class Data {
  Data({
    this.name,
    this.code,
    this.address,
    this.thumbnail,
    this.lastUpdate,
    this.rute,
  });
  String? name;
  String? code;
  String? address;
  String? thumbnail;
  String? lastUpdate;
  List<Rute>? rute;
  
  Data.fromJson(Map<String, dynamic> json){
    name = json['name'];
    code = json['code'];
    address = json['address'];
    thumbnail = json['thumbnail'];
    lastUpdate = json['last_update'];
    rute = List.from(json['rute']).map((e)=>Rute.fromJson(e)).toList();
  }
}

class Rute {
  Rute({
    required this.ruteId,
    required this.nama,
    required this.lat,
    required this.lng,
    required this.hari,
    required this.images,
    required this.status,
  });
  late final String ruteId;
  late final String nama;
  late final String lat;
  late final String lng;
  late final String hari;
  late final List<String> images;
  late final String status;
  
  Rute.fromJson(Map<String, dynamic> json){
    ruteId = json['ruteId'];
    nama = json['nama'];
    lat = json['lat'];
    lng = json['lng'];
    hari = json['hari'];
    images = List.castFrom<dynamic, String>(json['images']);
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['ruteId'] = ruteId;
    _data['nama'] = nama;
    _data['lat'] = lat;
    _data['lng'] = lng;
    _data['hari'] = hari;
    _data['images'] = images;
    _data['status'] = status;
    return _data;
  }
}