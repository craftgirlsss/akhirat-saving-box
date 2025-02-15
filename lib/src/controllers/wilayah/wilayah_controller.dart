import 'dart:convert';
import 'package:asb_app/src/components/global/index.dart';
import 'package:asb_app/src/controllers/auth/auth_controller.dart';
import 'package:asb_app/src/models/detail_donatur_finnished.dart';
import 'package:asb_app/src/models/donatur_finnished.dart';
import 'package:asb_app/src/models/donatur_models.dart';
import 'package:asb_app/src/models/kabupaten_models.dart';
import 'package:asb_app/src/models/kecamatan_models.dart';
import 'package:asb_app/src/models/lokasi_donatur_models.dart';
import 'package:asb_app/src/models/program_models.dart';
import 'package:asb_app/src/models/provice_models.dart';
import 'package:asb_app/src/models/wilayah_models.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class WilayahController extends GetxController{
  RxBool isLoading = false.obs;
  RxString responseString = "".obs;
  RxList<RxMap<String, dynamic>> daftarWilayah = RxList<RxMap<String, dynamic>>();
  AuthController authController = Get.put(AuthController());
  Rxn<WilayahModels> wilayahModels = Rxn<WilayahModels>();
  Rxn<DaftarDonatur> daftarDonatur = Rxn<DaftarDonatur>();
  Rxn<DaftarProgramModels> daftarProgram = Rxn<DaftarProgramModels>();
  Rxn<ProvinceModels> provinceModels = Rxn<ProvinceModels>();
  Rxn<KabupatenModels> kabupatenModels= Rxn<KabupatenModels>();
  Rxn<KecamatanModels> kecamatanModels = Rxn<KecamatanModels>();
  Rxn<DonaturFinnished> donaturFinnishedModels = Rxn<DonaturFinnished>();
  Rxn<DetailDonaturFinnished> detailDonaturFinnish = Rxn<DetailDonaturFinnished>();
  Rxn<LokasiDonaturModels> lokasiDonaturModels = Rxn<LokasiDonaturModels>();

  Future<bool> getWilayah() async {
    try {
      isLoading(true);
      http.Response response = await http.get(
        Uri.tryParse("${GlobalVariable.mainURL}/master/area/list?user=${authController.token.value}")!,
        headers: {
          'x-api-key': GlobalVariable.apiKey,
        }
      );

      var result = jsonDecode(response.body);
      isLoading(false);
      if (response.statusCode == 200) {
        if(result['success']) {
          wilayahModels.value = WilayahModels.fromJson(result);
          responseString.value = result['message'];
          return true;
        }
        responseString.value = result['message'];
        return false;
      } else {
        responseString.value = result['message'];
        return false;
      }
    } catch (e) {
      isLoading(false);
      responseString.value = e.toString();
      return false;
    }
  }

  // Get Donatur Lokasi
  Future<bool> getDonatrurLokasiByDonaturKode({String? donaturKode}) async {
    try {
      isLoading(true);
      http.Response response = await http.get(
        Uri.tryParse("${GlobalVariable.mainURL}/master/donatur/list-lokasi?user=${authController.token.value}&kode=$donaturKode")!,
        headers: {
          'x-api-key': GlobalVariable.apiKey,
        }
      );

      var result = jsonDecode(response.body);
      isLoading(false);
      print(result);
      if (response.statusCode == 200) {
        if(result['success']) {
          lokasiDonaturModels.value = LokasiDonaturModels.fromJson(result);
          responseString.value = result['message'];
          return true;
        }
        responseString.value = result['message'];
        return false;
      } else {
        responseString.value = result['message'];
        return false;
      }
    } catch (e) {
      isLoading(false);
      responseString.value = e.toString();
      return false;
    }
  }

  // Edit Lokasi Donatur
  Future<bool> editLokasiDonaturByIdLokasi({String? lokasiID, String? lat, String? long, String? keterangan}) async {
    try {
      isLoading(true);
      http.Response response = await http.post(
        Uri.tryParse("${GlobalVariable.mainURL}/master/donatur/edit-rute")!,
        headers: {
          'x-api-key': GlobalVariable.apiKey,
        },
        body: {
          'user': authController.token.value,
          'id_lokasi': lokasiID,
          'lat': lat,
          'lng': long,
          'keterangan': keterangan
        },
      );
      var result = jsonDecode(response.body);
      isLoading(false);
      if (response.statusCode == 200) {
        if(result['success']) {
          responseString.value = result['message'];
          return true;
        }
        responseString.value = result['message'];
        return false;
      } else {
        responseString.value = result['message'];
        return false;
      }
    } catch (e) {
      isLoading(false);
      responseString.value = e.toString();
      return false;
    }
  }

  // Tambah Lokasi Donatur
  Future<bool> tambahLokasiDonaturByIdLokasi({String? donaturKode, String? lat, String? long, String? keterangan}) async {
    try {
      isLoading(true);
      http.Response response = await http.post(
        Uri.tryParse("${GlobalVariable.mainURL}/master/donatur/tambah-rute")!,
        headers: {
          'x-api-key': GlobalVariable.apiKey,
        },
        body: {
          'user': authController.token.value,
          'kode': donaturKode,
          'lat': lat,
          'lng': long,
          'keterangan': keterangan
        },
      );
      var result = jsonDecode(response.body);
      isLoading(false);
      if (response.statusCode == 200) {
        if(result['success']) {
          responseString.value = result['message'];
          return true;
        }
        responseString.value = result['message'];
        return false;
      } else {
        responseString.value = result['message'];
        return false;
      }
    } catch (e) {
      isLoading(false);
      responseString.value = e.toString();
      return false;
    }
  }

  // Cancel pengambilan Donatur
  /* Status
    Belum Berangkat = 6
    Setengah Perjalanan = 7
    Tercapai = 8
  */
  Future<bool> cancelLokasiDonaturByIdLokasi({String? jadwalID, String? lat, String? long, String? keterangan, String? status}) async {
    try {
      isLoading(true);
      http.Response response = await http.post(
        Uri.tryParse("${GlobalVariable.mainURL}/cancel")!,
        headers: {
          'x-api-key': GlobalVariable.apiKey,
        },
        body: {
          'user': authController.token.value,
          'jadwal': jadwalID,
          'status': status,
          'desc': keterangan,
          'lat': lat,
          'lng': long
        },
      );
      var result = jsonDecode(response.body);
      isLoading(false);
      if (response.statusCode == 200) {
        if(result['success']) {
          responseString.value = result['message'];
          return true;
        }
        responseString.value = result['message'];
        return false;
      } else {
        responseString.value = result['message'];
        return false;
      }
    } catch (e) {
      isLoading(false);
      responseString.value = e.toString();
      return false;
    }
  }

  Future<bool> getDonaturByWilayahID({String? wilayahID}) async {
    try {
      isLoading(true);
      http.Response response = await http.get(
        Uri.tryParse("${GlobalVariable.mainURL}/master/donatur/list?user=${authController.token.value}&rute_id=$wilayahID")!,
        headers: {
          'x-api-key': GlobalVariable.apiKey,
        }
      );

      var result = jsonDecode(response.body);
      isLoading(false);
      if (response.statusCode == 200) {
        if(result['success']) {
          daftarDonatur.value = DaftarDonatur.fromJson(result);
          responseString.value = result['message'];
          return true;
        }
        responseString.value = result['message'];
        return false;
      } else {
        responseString.value = result['message'];
        return false;
      }
    } catch (e) {
      isLoading(false);
      responseString.value = e.toString();
      return false;
    }
  }

  // Get Program
  Future<bool> getProgram() async {
    try {
      isLoading(true);
      http.Response response = await http.get(
        Uri.tryParse("${GlobalVariable.mainURL}/master/program/list?user=${authController.token.value}")!,
        headers: {
          'x-api-key': GlobalVariable.apiKey,
        }
      );

      var result = jsonDecode(response.body);
      isLoading(false);
      if (response.statusCode == 200) {
        if(result['success']) {
          daftarProgram.value = DaftarProgramModels.fromJson(result);
          responseString.value = result['message'];
          return true;
        }
        responseString.value = result['message'];
        return false;
      } else {
        responseString.value = result['message'];
        return false;
      }
    } catch (e) {
      isLoading(false);
      responseString.value = e.toString();
      return false;
    }
  }

  // Get daftar donatur yang sudah dihitung pendapatan
  Future<bool> getDonaturFinnished({String? date}) async {
    try {
      isLoading(true);
      http.Response response = await http.get(
        Uri.tryParse("${GlobalVariable.mainURL}/master/kuitansi/list?bulan=$date&user=${authController.token.value}")!,
        headers: {
          'x-api-key': GlobalVariable.apiKey,
        }
      );

      var result = jsonDecode(response.body);
      isLoading(false);
      if (response.statusCode == 200) {
        if(result['success']) {
          donaturFinnishedModels.value = DonaturFinnished.fromJson(result);
          responseString.value = result['message'];
          return true;
        }
        responseString.value = result['message'];
        return false;
      } else {
        responseString.value = result['message'];
        return false;
      }
    } catch (e) {
      isLoading(false);
      responseString.value = e.toString();
      return false;
    }
  }

  // Get daftar donatur yang sudah dihitung pendapatan by Jadwal ID
  Future<bool> getDonaturFinnishedByJadwalID({String? date, String? jadwalID}) async {
    try {
      isLoading(true);
      http.Response response = await http.get(
        Uri.tryParse("${GlobalVariable.mainURL}/master/kuitansi/get_detail?user=${authController.token.value}&jadwal=$jadwalID")!,
        headers: {
          'x-api-key': GlobalVariable.apiKey,
        }
      );

      var result = jsonDecode(response.body);
      isLoading(false);
      if (response.statusCode == 200) {
        if(result['success']) {
          detailDonaturFinnish.value = DetailDonaturFinnished.fromJson(result);
          responseString.value = result['message'];
          return true;
        }
        responseString.value = result['message'];
        return false;
      } else {
        responseString.value = result['message'];
        return false;
      }
    } catch (e) {
      isLoading(false);
      responseString.value = e.toString();
      return false;
    }
  }

  // Update Catatan Default
  Future<bool> updateCatatanDefaultDonatur({String? donaturCode, String? note}) async {
    try {
      isLoading(true);
      http.Response response = await http.post(
        Uri.tryParse("${GlobalVariable.mainURL}/master/donatur/update_catatan")!,
        headers: {
          'x-api-key': GlobalVariable.apiKey,
        },
        body: {
          'user': authController.token.value,
          'code': donaturCode,
          'desc': note
        },
      );
      var result = jsonDecode(response.body);
      isLoading(false);
      if (response.statusCode == 200) {
        if(result['success']) {
          responseString.value = result['message'];
          return true;
        }
        responseString.value = result['message'];
        return false;
      } else {
        responseString.value = result['message'];
        return false;
      }
    } catch (e) {
      isLoading(false);
      responseString.value = e.toString();
      return false;
    }
  }

  // Update Catatan Khusus
  Future<bool> updateCatatanKhususDonatur({String? jadwaID, String? note}) async {
    try {
      isLoading(true);
      http.Response response = await http.post(
        Uri.tryParse("${GlobalVariable.mainURL}/master/jadwal/update_catatan")!,
        headers: {
          'x-api-key': GlobalVariable.apiKey,
        },
        body: {
          'user': authController.token.value,
          'jadwal': jadwaID,
          'desc': note
        },
      );
      var result = jsonDecode(response.body);
      isLoading(false);
      if (response.statusCode == 200) {
        if(result['success']) {
          responseString.value = result['message'];
          return true;
        }
        responseString.value = result['message'];
        return false;
      } else {
        responseString.value = result['message'];
        return false;
      }
    } catch (e) {
      isLoading(false);
      responseString.value = e.toString();
      return false;
    }
  }

  // API Rajaongkir
  Future<bool> getProvince() async {
    try {
      isLoading(true);
      http.Response response = await http.get(Uri.tryParse("https://pro.rajaongkir.com/api/province")!, headers: {'key': 'e049d10db2bd7fc4d5ec3cb4035633be'});
      isLoading(false);
      if (response.statusCode == 200) {
        var result = jsonDecode(response.body);
        if(kDebugMode) print(result);
        provinceModels.value = ProvinceModels.fromJson(result);
        return true;
      } else {
        return false;
      }
    } catch (e) {
      isLoading(false);
      return false;
    }
  }

 Future<bool> getKabupaten({String? idProvince}) async {
    try {
      isLoading(true);
      http.Response response = await http.get(Uri.tryParse("https://pro.rajaongkir.com/api/city?province=$idProvince")!, headers: {'key': 'e049d10db2bd7fc4d5ec3cb4035633be'});
      isLoading(false);
      if (response.statusCode == 200) {
        var result = jsonDecode(response.body);
        kabupatenModels.value = KabupatenModels.fromJson(result);
        if(kDebugMode) print(result);
        return true;
      } else {
        return false;
      }
    } catch (e) {
      isLoading(false);
      return false;
    }
  }

  Future<bool> getKecamatan({String? idKabupaten, String? idProvince}) async {
    try {
      isLoading(true);
      http.Response response = await http.get(Uri.tryParse("https://pro.rajaongkir.com/api/subdistrict?province=$idProvince&city=$idKabupaten")!, headers: {'key': 'e049d10db2bd7fc4d5ec3cb4035633be'});
      isLoading(false);
      if (response.statusCode == 200) {
        var result = jsonDecode(response.body);
        kecamatanModels.value = KecamatanModels.fromJson(result);
        if(kDebugMode) print(result);
        return true;
      } else {
        return false;
      }
    } catch (e) {
      isLoading(false);
      return false;
    } finally {
      isLoading(false);
    }
  }
  // end of API RajaOngking
}