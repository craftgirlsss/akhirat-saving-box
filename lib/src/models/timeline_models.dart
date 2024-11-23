class AutoGenerate {
  AutoGenerate({
    required this.id,
    required this.namaBagian,
    required this.date,
    required this.pic,
    required this.prosesUtama,
  });
  late final int id;
  late final String namaBagian;
  late final String date;
  late final Pic pic;
  late final List<ProsesUtama> prosesUtama;
  
  AutoGenerate.fromJson(Map<String, dynamic> json){
    id = json['id'];
    namaBagian = json['nama_bagian'];
    date = json['date'];
    pic = Pic.fromJson(json['pic']);
    prosesUtama = List.from(json['proses_utama']).map((e)=>ProsesUtama.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['nama_bagian'] = namaBagian;
    _data['date'] = date;
    _data['pic'] = pic.toJson();
    _data['proses_utama'] = prosesUtama.map((e)=>e.toJson()).toList();
    return _data;
  }
}

class Pic {
  Pic({
    required this.name,
    required this.profilePicture,
  });
  late final String name;
  late final String profilePicture;
  
  Pic.fromJson(Map<String, dynamic> json){
    name = json['name'];
    profilePicture = json['profile_picture'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['name'] = name;
    _data['profile_picture'] = profilePicture;
    return _data;
  }
}

class ProsesUtama {
  ProsesUtama({
    required this.namaProses,
    required this.prosesSelesai,
    required this.subProses,
  });
  late final String namaProses;
  late final bool prosesSelesai;
  late final List<SubProses> subProses;
  
  ProsesUtama.fromJson(Map<String, dynamic> json){
    namaProses = json['nama_proses'];
    prosesSelesai = json['proses_selesai'];
    subProses = List.from(json['sub_proses']).map((e)=>SubProses.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['nama_proses'] = namaProses;
    _data['proses_selesai'] = prosesSelesai;
    _data['sub_proses'] = subProses.map((e)=>e.toJson()).toList();
    return _data;
  }
}

class SubProses {
  SubProses({
    required this.startProses,
    required this.prosesSelesai,
    required this.namaProses,
  });
  late final String startProses;
  late final bool prosesSelesai;
  late final String namaProses;
  
  SubProses.fromJson(Map<String, dynamic> json){
    startProses = json['start_proses'];
    prosesSelesai = json['proses_selesai'];
    namaProses = json['nama_proses'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['start_proses'] = startProses;
    _data['proses_selesai'] = prosesSelesai;
    _data['nama_proses'] = namaProses;
    return _data;
  }
}