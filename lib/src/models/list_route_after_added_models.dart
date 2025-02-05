class ListRuteAfterAddedModels {
  ListRuteAfterAddedModels({
    required this.success,
    required this.message,
    required this.data,
  });
  late final bool success;
  late final String message;
  List<Data>? data;
  
  ListRuteAfterAddedModels.fromJson(Map<String, dynamic> json){
    success = json['success'];
    message = json['message'];
    data = List.from(json['data']).map((e)=>Data.fromJson(e)).toList();
  }
}

class Data {
  Data({
    this.id,
    this.kode,
    this.namaRute,
    this.nama,
    this.telepon,
    this.jenisKelamin,
    this.usia,
    this.alamat,
    this.jam,
    this.tanggalPengambilan,
    this.fotoPenukaran,
    this.lokasiPenukaran,
    this.catatanKhusus,
    this.h,
    this.h1,
    this.jadwalID,
    this.h2,
    this.rapel,
    this.jadwalRapel,
    this.status,
    this.lastUpdate,
  });
  String? id;
  String? kode;
  String? namaRute;
  String? nama;
  String? jadwalID;
  String? telepon;
  String? jenisKelamin;
  String? usia;
  String? alamat;
  String? jam;
  String? tanggalPengambilan;
  List<dynamic>? fotoPenukaran;
  LokasiPenukaran? lokasiPenukaran;
  LokasiTerakhir? lokasiTerakhir;
  String? catatanKhusus;
  bool? h;
  bool? h1;
  bool? h2;
  bool? rapel;
  bool? jadwalRapel;
  String? status;
  String? lastUpdate;
  
  Data.fromJson(Map<String, dynamic> json){
    id = json['id'];
    kode = json['kode'];
    namaRute = json['nama_rute'];
    nama = json['nama'];
    telepon = json['telepon'];
    jenisKelamin = json['jenis_kelamin'];
    usia = json['usia'];
    alamat = json['alamat'];
    jam = json['jam'];
    jadwalID = json['jadwal'];
    tanggalPengambilan = json['tanggal_pengambilan'];
    fotoPenukaran = List.castFrom<dynamic, dynamic>(json['foto_penukaran']);
    lokasiPenukaran = LokasiPenukaran.fromJson(json['lokasi_penukaran']);
    lokasiTerakhir = LokasiTerakhir.fromJson(json['lokasi_terakhir']);
    catatanKhusus = json['catatan_khusus'];
    h = json['h'];
    h1 = json['h1'];
    h2 = json['h2'];
    rapel = json['rapel'];
    jadwalRapel = json['jadwal_rapel'];
    status = json['status'];
    lastUpdate = json['last_update'];
  }
}

class LokasiPenukaran {
  LokasiPenukaran({
    this.lat,
    this.lng,
  });
  String? lat;
  String? lng;
  
  LokasiPenukaran.fromJson(Map<String, dynamic> json){
    lat = json['lat'];
    lng = json['lng'];
  }
}

class LokasiTerakhir {
  LokasiTerakhir({
    this.lat,
    this.lng,
  });
  String? lat;
  String? lng;
  
  LokasiTerakhir.fromJson(Map<String, dynamic> json){
    lat = json['lat'];
    lng = json['lng'];
  }
}