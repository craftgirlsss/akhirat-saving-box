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
    final String? jadwaID;
    final String? kode;
    final String? nama;
    final String? telepon;
    final String? alamat;
    final Lokasi? lokasiPenukaran;
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

    Donatur({
      this.id,
      this.jam,
      this.jadwaID,
      this.kode,
      this.nama,
      this.lokasiPenukaran,
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
      this.catatanDefault
    });

    factory Donatur.fromJson(Map<String, dynamic> json) => Donatur(
        id: json["id"],
        jam: json['jam'],
        jadwaID: json['jadwal'],
        kode: json["kode"],
        nama: json["nama"],
        telepon: json["telepon"],
        alamat: json["alamat"],
        h: json["h"],
        h1: json["h1"],
        h2: json["h2"],
        rapel: json["rapel"],
        jadwalRapel: json["jadwal_rapel"],
        jenisKelamin: json['jenis_kelamin'],
        tanggalPengambilan: json['tanggal_pengambilan'],
        catatanKhusus: json['catatan_khusus'],
        catatanDefault: json['catatan_default'],
    );
}

class Lokasi {
    final String? lat;
    final String? lng;
    Lokasi({this.lat, this.lng});
    factory Lokasi.fromJson(Map<String, dynamic> json) => Lokasi(
        lat: json["lat"],
        lng: json["lng"],
    );
}