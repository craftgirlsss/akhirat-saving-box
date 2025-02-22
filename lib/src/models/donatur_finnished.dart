// class DonaturFinnished {
//   DonaturFinnished({
//     required this.success,
//     required this.message,
//     required this.data,
//   });
//   late final bool success;
//   late final String message;
//   late final List<Data> data;
  
//   DonaturFinnished.fromJson(Map<String, dynamic> json){
//     success = json['success'];
//     message = json['message'];
//     data = List.from(json['data']).map((e)=>Data.fromJson(e)).toList();
//   }
// }

// class Data {
//   Data({
//     this.kode,
//     this.nama,
//     this.jumlahDonasi,
//     this.namaProgram,
//   });
//   String? kode;
//   String? nama;
//   int? jumlahDonasi;
//   String? namaProgram;
  
//   Data.fromJson(Map<String, dynamic> json){
//     kode = json['kode'];
//     nama = json['nama'];
//     jumlahDonasi = json['jumlah_donasi'];
//     namaProgram = json['nama_program'];
//   }
// }

import 'dart:convert';

DonaturFinnished welcomeFromJson(String str) => DonaturFinnished.fromJson(json.decode(str));

String welcomeToJson(DonaturFinnished data) => json.encode(data.toJson());

class DonaturFinnished {
    bool success;
    String message;
    List<Datum> data;

    DonaturFinnished({
        required this.success,
        required this.message,
        required this.data,
    });

    factory DonaturFinnished.fromJson(Map<String, dynamic> json) => DonaturFinnished(
        success: json["success"],
        message: json["message"],
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
    };
}

class Datum {
    String kode;
    String nama;
    int jumlahDonasi;
    String namaProgram;
    String? jadwalID;
    String? terbilang;
    List<List<dynamic>> summary;

    Datum({
        required this.kode,
        required this.nama,
        required this.jumlahDonasi,
        required this.namaProgram,
        required this.summary,
        this.jadwalID,
        this.terbilang
    });

    factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        kode: json["kode"],
        nama: json["nama"],
        jumlahDonasi: json["jumlah_donasi"],
        namaProgram: json["nama_program"],
        jadwalID: json['jadwal'],
        terbilang: json['terbilang'],
        summary: List<List<dynamic>>.from(json["summary"].map((x) => List<dynamic>.from(x.map((x) => x)))),
    );

    Map<String, dynamic> toJson() => {
        "kode": kode,
        "nama": nama,
        "jumlah_donasi": jumlahDonasi,
        "nama_program": namaProgram,
        "terbilang" : terbilang,
        "jadwal" : jadwalID,
        "summary": List<dynamic>.from(summary.map((x) => List<dynamic>.from(x.map((x) => x)))),
    };
}