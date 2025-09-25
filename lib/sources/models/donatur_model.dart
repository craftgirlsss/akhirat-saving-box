import 'dart:convert';

DonaturListResponse donaturListResponseFromJson(String str) => DonaturListResponse.fromJson(json.decode(str));

class DonaturListResponse {
    final bool success;
    final String message;
    final List<Donatur> data;

    DonaturListResponse({
        required this.success,
        required this.message,
        required this.data,
    });

    factory DonaturListResponse.fromJson(Map<String, dynamic> json) => DonaturListResponse(
        success: json["success"],
        message: json["message"],
        data: List<Donatur>.from(json["data"].map((x) => Donatur.fromJson(x))),
    );
}

class Donatur {
    final String? id;
    final String? jadwalId; // Mengubah nama properti menjadi jadwalId
    final String? kode;
    final String? nama;
    final String? namaRute; // Properti baru
    final String? telepon;
    final String? alamat;
    final LokasiPengambilan? lokasiPenukaran;
    final LokasiTerakhir? lokasiTerakhir;
    final bool? h;
    final bool? h1;
    final String? jam;
    final bool? h2;
    final bool? rapel;
    final bool? jadwalRapel;
    final String? jenisKelamin;
    final String? tanggalPengambilan;
    final String? catatanKhusus;
    final String? catatanDefault;
    final String? usia; // Properti baru
    final List<String>? fotoPenukaran; // Properti baru
    final String? status; // Properti baru
    final String? lastUpdate; // Properti baru

    Donatur({
      this.id,
      this.jam,
      this.jadwalId,
      this.kode,
      this.nama,
      this.namaRute,
      this.lokasiPenukaran,
      this.lokasiTerakhir,
      this.telepon,
      this.alamat,
      this.h,
      this.h1,
      this.h2,
      this.rapel,
      this.jadwalRapel,
      this.jenisKelamin,
      this.tanggalPengambilan,
      this.catatanKhusus,
      this.catatanDefault,
      this.usia,
      this.fotoPenukaran,
      this.status,
      this.lastUpdate,
    });

    factory Donatur.fromJson(Map<String, dynamic> json) => Donatur(
        id: json["id"],
        jam: json['jam'],
        jadwalId: json['jadwal'], // Menyesuaikan nama key
        kode: json["kode"],
        nama: json["nama"],
        namaRute: json["nama_rute"],
        telepon: json["telepon"],
        alamat: json["alamat"],
        h: json["h"],
        h1: json["h1"],
        h2: json["h2"],
        rapel: json["rapel"],
        lokasiPenukaran: json['lokasi_penukaran'] != null
            ? LokasiPengambilan.fromJson(json['lokasi_penukaran'])
            : null,
        lokasiTerakhir: json['lokasi_terakhir'] != null
            ? LokasiTerakhir.fromJson(json['lokasi_terakhir'])
            : null,
        jadwalRapel: json["jadwal_rapel"],
        jenisKelamin: json['jenis_kelamin'],
        tanggalPengambilan: json['tanggal_pengambilan'],
        catatanKhusus: json['catatan_khusus'],
        catatanDefault: json['catatan_default'],
        usia: json["usia"],
        fotoPenukaran: json["foto_penukaran"] != null
            ? List<String>.from(json["foto_penukaran"].map((x) => x))
            : null,
        status: json["status"],
        lastUpdate: json["last_update"],
    );
}

class LokasiPengambilan {
    final String? lat;
    final String? lng;
    LokasiPengambilan({this.lat, this.lng});
    factory LokasiPengambilan.fromJson(Map<String, dynamic> json) => LokasiPengambilan(
        lat: json["lat"],
        lng: json["lng"],
    );
}

class LokasiTerakhir {
    final String? lat;
    final String? lng;
    LokasiTerakhir({this.lat, this.lng});
    factory LokasiTerakhir.fromJson(Map<String, dynamic> json) => LokasiTerakhir(
        lat: json["lat"],
        lng: json["lng"],
    );
}