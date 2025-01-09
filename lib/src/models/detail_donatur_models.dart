class DetailsDonaturModels {
  DetailsDonaturModels({
    this.success,
    this.message,
    this.data,
  });
  bool? success;
  String? message;
  Data? data;
  
  DetailsDonaturModels.fromJson(Map<String, dynamic> json){
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
  List<Rute>?rute;
  
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
    this.ruteId,
    this.nama,
    this.lat,
    this.lng,
    this.hari,
    this.status,
  });
  String? ruteId;
  String? nama;
  String? lat;
  String? lng;
  String? hari;
  int? status;
  
  Rute.fromJson(Map<String, dynamic> json){
    ruteId = json['ruteId'];
    nama = json['nama'];
    lat = json['lat'];
    lng = json['lng'];
    hari = json['hari'];
    status = json['status'];
  }
}