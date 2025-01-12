import 'dart:convert';
import 'package:asb_app/src/components/global/index.dart';
import 'package:asb_app/src/controllers/auth/auth_controller.dart';
import 'package:asb_app/src/models/detail_donatur_models.dart';
import 'package:asb_app/src/models/tempat_pengambilan_models.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

class TrackingController extends GetxController {
  RxBool isLoading = false.obs;
  RxString responseMessage = "".obs;
  RxBool wasSelfieAsFirst = false.obs;
  AuthController authController = Get.put(AuthController());
  Rxn<TempatPengambilanModels> tempatPengambilanModels = Rxn<TempatPengambilanModels>();
  Rxn<DetailDonaturModels> detailDonaturModels = Rxn<DetailDonaturModels>();
  

  Future<bool> getListTempatPengambilan() async {
    try {
      isLoading(true);
      http.Response response = await http.get(
        Uri.tryParse("${GlobalVariable.mainURL}/list-donatur?user=${authController.token.value}")!,
        headers: {
          'x-api-key': GlobalVariable.apiKey,
        }
      );

      var result = jsonDecode(response.body);
      isLoading(false);
      if (response.statusCode == 200) {
        if(result['success']) {
          tempatPengambilanModels.value = TempatPengambilanModels.fromJson(result);
          responseMessage.value = result['message'];
          return true;
        }
        responseMessage.value = result['message'];
        return false;
      } else {
        responseMessage.value = result['message'];
        return false;
      }
    } catch (e) {
      isLoading(false);
      responseMessage.value = e.toString();
      return false;
    }
  }

  Future<bool> checkingSelfFirst() async {
    try {
      isLoading(true);
      http.Response response = await http.get(
        Uri.tryParse("${GlobalVariable.mainURL}/cek-keberangkatan?user=${authController.token.value}")!,
        headers: {
          'x-api-key': GlobalVariable.apiKey,
        }
      );

      var result = jsonDecode(response.body);
      isLoading(false);
      if (response.statusCode == 200) {
        if(result['success']) {
          responseMessage.value = result['message'];
          return true;
        }
        responseMessage.value = result['message'];
        return false;
      } else {
        responseMessage.value = result['message'];
        return false;
      }
    } catch (e) {
      isLoading(false);
      responseMessage.value = e.toString();
      return false;
    }
  }

  Future<bool> postCheckingSelfFirst({String? urlImage1, String? urlImage2, String? urlImage3, String? description}) async {
    try {
      isLoading(true);
      var request = http.MultipartRequest('POST', Uri.parse('${GlobalVariable.mainURL}/mulai-berangkat'));
      request.fields.addAll({
        'user': authController.token.value,
        'desc': description ?? ""
      });
      if(urlImage1 == null || urlImage2 == null || urlImage3 == null){
        return false;
      }
      request.files.add(await http.MultipartFile.fromPath('image1', urlImage1, contentType: MediaType('image', 'jpeg')));
      request.files.add(await http.MultipartFile.fromPath('image2', urlImage2, contentType: MediaType('image', 'jpeg')));
      request.files.add(await http.MultipartFile.fromPath('image3', urlImage3, contentType: MediaType('image', 'jpeg')));
      request.headers.addAll({'x-api-key': GlobalVariable.apiKey});

      http.StreamedResponse response = await request.send();
      jsonDecode(await response.stream.bytesToString());
      isLoading(false);
      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      isLoading(false);
      responseMessage.value = e.toString();
      return false;
    }
  }

  Future<bool> checkDetailsOfDonatur({String? code, String? token}) async {
    try {
      isLoading(true);
      http.Response response = await http.get(
        Uri.tryParse("${GlobalVariable.mainURL}/detail-donatur?code=$code&user=$token")!,
        headers: {
          'x-api-key': GlobalVariable.apiKey,
        }
      );

      var result = jsonDecode(response.body);
      isLoading(false);
      if (response.statusCode == 200) {
        if(result['success']) {
          detailDonaturModels.value = DetailDonaturModels.fromJson(result);
          responseMessage.value = result['message'];
          return true;
        }
        responseMessage.value = result['message'];
        return false;
      } else {
        responseMessage.value = result['message'];
        return false;
      }
    } catch (e) {
      isLoading(false);
      responseMessage.value = e.toString();
      return false;
    }
  }


  Future<bool> konfirmasiPengambilanRute({String? kodeRute}) async {
    try {
      isLoading(true);
      http.Response response = await http.post(
        Uri.tryParse("${GlobalVariable.mainURL}/konfirmasi-rute")!,
        headers: {
          'x-api-key': GlobalVariable.apiKey,
        },
        body: {
          'user': authController.token.value,
          'idRute': kodeRute
        },
      );
      var result = jsonDecode(response.body);
      isLoading(false);
      if (response.statusCode == 200) {
        if(result['success']) {
          responseMessage.value = result['message'];
          return true;
        }
        responseMessage.value = result['message'];
        return false;
      } else {
        responseMessage.value = result['message'];
        return false;
      }
    } catch (e) {
      isLoading(false);
      responseMessage.value = e.toString();
      return false;
    }
  }
}