class DaftarDonaturByRute {
  DaftarDonaturByRute({
    required this.success,
    required this.message,
    required this.data,
  });
  late final bool success;
  late final String message;
  late final List<Data> data;
  
  DaftarDonaturByRute.fromJson(Map<String, dynamic> json){
    success = json['success'];
    message = json['message'];
    data = List.from(json['data']).map((e)=>Data.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['success'] = success;
    _data['message'] = message;
    _data['data'] = data.map((e)=>e.toJson()).toList();
    return _data;
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
    required this.alamat,
     this.jam,
     this.tanggalPengambilan,
    required this.fotoPenukaran,
    required this.lokasiPenukaran,
    required this.catatanKhusus,
    required this.h,
    required this.h1,
    required this.h2,
    required this.rapel,
    required this.jadwalRapel,
    required this.status,
    required this.lastUpdate,
  });
  late final String id;
  late final String kode;
  late final String nama;
  late final String telepon;
  late final String jenisKelamin;
  late final String usia;
  late final String alamat;
  late final Null jam;
  late final Null tanggalPengambilan;
  late final String fotoPenukaran;
  late final LokasiPenukaran lokasiPenukaran;
  late final String catatanKhusus;
  late final bool h;
  late final bool h1;
  late final bool h2;
  late final bool rapel;
  late final bool jadwalRapel;
  late final String status;
  late final String lastUpdate;
  
  Data.fromJson(Map<String, dynamic> json){
    id = json['id'];
    kode = json['kode'];
    nama = json['nama'];
    telepon = json['telepon'];
    jenisKelamin = json['jenis_kelamin'];
    usia = json['usia'];
    alamat = json['alamat'];
    jam = null;
    tanggalPengambilan = null;
    fotoPenukaran = json['foto_penukaran'];
    lokasiPenukaran = LokasiPenukaran.fromJson(json['lokasi_penukaran']);
    catatanKhusus = json['catatan_khusus'];
    h = json['h'];
    h1 = json['h1'];
    h2 = json['h2'];
    rapel = json['rapel'];
    jadwalRapel = json['jadwal_rapel'];
    status = json['status'];
    lastUpdate = json['last_update'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['kode'] = kode;
    _data['nama'] = nama;
    _data['telepon'] = telepon;
    _data['jenis_kelamin'] = jenisKelamin;
    _data['usia'] = usia;
    _data['alamat'] = alamat;
    _data['jam'] = jam;
    _data['tanggal_pengambilan'] = tanggalPengambilan;
    _data['foto_penukaran'] = fotoPenukaran;
    _data['lokasi_penukaran'] = lokasiPenukaran.toJson();
    _data['catatan_khusus'] = catatanKhusus;
    _data['h'] = h;
    _data['h1'] = h1;
    _data['h2'] = h2;
    _data['rapel'] = rapel;
    _data['jadwal_rapel'] = jadwalRapel;
    _data['status'] = status;
    _data['last_update'] = lastUpdate;
    return _data;
  }
}

class LokasiPenukaran {
  LokasiPenukaran({
    required this.lat,
    required this.lng,
  });
  late final String lat;
  late final String lng;
  
  LokasiPenukaran.fromJson(Map<String, dynamic> json){
    lat = json['lat'];
    lng = json['lng'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['lat'] = lat;
    _data['lng'] = lng;
    return _data;
  }
}