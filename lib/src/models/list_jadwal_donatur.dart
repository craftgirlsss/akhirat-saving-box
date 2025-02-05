class ListJadwal {
  ListJadwal({
    required this.success,
    required this.message,
    required this.data,
  });
  late final bool success;
  late final String message;
  late final List<Data> data;
  
  ListJadwal.fromJson(Map<String, dynamic> json){
    success = json['success'];
    message = json['message'];
    data = List.from(json['data']).map((e)=>Data.fromJson(e)).toList();
  }
}

class Data {
  Data({
    this.id,
    this.kode,
    this.nama,
    this.hari,
    this.jam,
    this.status,
    this.statusStr,
    this.lastUpdate,
  });
  String? id;
  String? kode;
  String? nama;
  String? hari;
  String? jam;
  String? status;
  String? statusStr;
  String? lastUpdate;
  
  Data.fromJson(Map<String, dynamic> json){
    id = json['id'];
    kode = json['kode'];
    nama = json['nama'];
    hari = json['hari'];
    jam = json['jam'];
    status = json['status'];
    statusStr = json['status_str'];
    lastUpdate = json['last_update'];
  }
}