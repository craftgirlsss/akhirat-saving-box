import 'dart:convert';
import 'package:asb_app/src/components/global/index.dart';
import 'package:asb_app/src/controllers/auth/auth_controller.dart';
import 'package:asb_app/src/models/donatur_models.dart';
import 'package:asb_app/src/models/kabupaten_models.dart';
import 'package:asb_app/src/models/kecamatan_models.dart';
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