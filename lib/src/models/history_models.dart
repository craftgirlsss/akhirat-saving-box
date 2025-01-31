class HistoryModels {
  HistoryModels({
    required this.success,
    required this.message,
    required this.data,
  });
  late final bool success;
  late final String message;
  late final List<Data> data;
  
  HistoryModels.fromJson(Map<String, dynamic> json){
    success = json['success'];
    message = json['message'];
    data = List.from(json['data']).map((e)=>Data.fromJson(e)).toList();
  }
}

class Data {
  Data({
    this.idJadwal,
    this.kode,
    this.rute,
    this.lat,
    this.lng,
    this.donatur,
    this.jadwal,
  });
  String? idJadwal;
  String? kode;
  String? rute;
  String? lat;
  String? lng;
  Donatur? donatur;
  Jadwal? jadwal;
  
  Data.fromJson(Map<String, dynamic> json){
    idJadwal = json['id_jadwal'];
    kode = json['kode'];
    rute = json['rute'];
    lat = json['lat'];
    lng = json['lng'];
    donatur = Donatur.fromJson(json['donatur']);
    jadwal = Jadwal.fromJson(json['jadwal']);
  }
}

class Donatur {
  Donatur({
    required this.nama,
    required this.kode,
    required this.alamat,
  });
  late final String nama;
  late final String kode;
  late final String alamat;
  
  Donatur.fromJson(Map<String, dynamic> json){
    nama = json['nama'];
    kode = json['kode'];
    alamat = json['alamat'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['nama'] = nama;
    _data['kode'] = kode;
    _data['alamat'] = alamat;
    return _data;
  }
}

class Jadwal {
  Jadwal({
    required this.tanggal,
    required this.waktu,
  });
  late final String tanggal;
  late final String waktu;
  
  Jadwal.fromJson(Map<String, dynamic> json){
    tanggal = json['tanggal'];
    waktu = json['waktu'];
  }
}