class DaftarDonatur {
  DaftarDonatur({
    required this.success,
    required this.message,
    required this.data,
  });
  late final bool success;
  late final String message;
  late final List<Data> data;
  
  DaftarDonatur.fromJson(Map<String, dynamic> json){
    success = json['success'];
    message = json['message'];
    data = List.from(json['data']).map((e)=>Data.fromJson(e)).toList();
  }
}

class Data {
  Data({
    required this.id,
    required this.kode,
    required this.nama,
    required this.telepon,
    required this.jenisKelamin,
    required this.usia,
    required this.status,
    required this.lastUpdate,
  });
  late final String id;
  late final String kode;
  late final String nama;
  late final String telepon;
  late final String jenisKelamin;
  late final String usia;
  late final String status;
  late final String lastUpdate;
  
  Data.fromJson(Map<String, dynamic> json){
    id = json['id'];
    kode = json['kode'];
    nama = json['nama'];
    telepon = json['telepon'];
    jenisKelamin = json['jenis_kelamin'];
    usia = json['usia'];
    status = json['status'];
    lastUpdate = json['last_update'];
  }
}