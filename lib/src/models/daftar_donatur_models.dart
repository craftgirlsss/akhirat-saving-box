class DaftarDonaturModels {
  DaftarDonaturModels({
    required this.success,
    required this.message,
    required this.data,
  });
  late final bool success;
  late final String message;
  late final List<Data> data;
  
  DaftarDonaturModels.fromJson(Map<String, dynamic> json){
    success = json['success'];
    message = json['message'];
    data = List.from(json['data']).map((e)=>Data.fromJson(e)).toList();
  }
}

class Data {
  Data({
    this.id,
    this.ruteId,
    this.jadwal,
    this.name,
    this.alamat,
    this.noHp,
    this.jam,
    this.tanggal,
    this.h,
    this.h1,
    this.h2,
    this.rapel,
    this.jadwalRapel,
    this.statusPengambilan,
    this.status,
  });
  String? id;
  String? ruteId;
  String? jadwal;
  String? name;
  String? alamat;
  String? noHp;
  String? jam;
  String? tanggal;
  bool? h;
  bool? h1;
  bool? h2;
  bool? rapel;
  bool? jadwalRapel;
  bool? statusPengambilan;
  String? status;
  
  Data.fromJson(Map<String, dynamic> json){
    id = json['id'];
    ruteId = json['rute_id'];
    jadwal = json['jadwal'];
    name = json['name'];
    alamat = json['alamat'];
    noHp = json['no_hp'];
    jam = json['jam'];
    tanggal = json['tanggal'];
    h = json['h'];
    h1 = json['h1'];
    h2 = json['h2'];
    rapel = json['rapel'];
    jadwalRapel = json['jadwal_rapel'];
    statusPengambilan = json['status_pengambilan'];
    status = json['status'];
  }
}