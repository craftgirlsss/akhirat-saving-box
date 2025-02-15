import 'dart:convert';

DetailDonaturFinnished detailDonaturFinnishedFromJson(String str) => DetailDonaturFinnished.fromJson(json.decode(str));

String detailDonaturFinnishedToJson(DetailDonaturFinnished data) => json.encode(data.toJson());

class DetailDonaturFinnished {
    bool success;
    String message;
    Data data;

    DetailDonaturFinnished({
        required this.success,
        required this.message,
        required this.data,
    });

    factory DetailDonaturFinnished.fromJson(Map<String, dynamic> json) => DetailDonaturFinnished(
        success: json["success"],
        message: json["message"],
        data: Data.fromJson(json["data"]),
    );

    Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
        "data": data.toJson(),
    };
}

class Data {
    String kode;
    String nama;
    int jumlahDonasi;
    String namaProgram;
    List<List<dynamic>> summary;

    Data({
        required this.kode,
        required this.nama,
        required this.jumlahDonasi,
        required this.namaProgram,
        required this.summary,
    });

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        kode: json["kode"],
        nama: json["nama"],
        jumlahDonasi: json["jumlah_donasi"],
        namaProgram: json["nama_program"],
        summary: List<List<dynamic>>.from(json["summary"].map((x) => List<dynamic>.from(x.map((x) => x)))),
    );

    Map<String, dynamic> toJson() => {
        "kode": kode,
        "nama": nama,
        "jumlah_donasi": jumlahDonasi,
        "nama_program": namaProgram,
        "summary": List<dynamic>.from(summary.map((x) => List<dynamic>.from(x.map((x) => x)))),
    };
}