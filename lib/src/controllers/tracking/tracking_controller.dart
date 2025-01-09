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
  AuthController authController = Get.find();
  Rxn<TempatPengambilanModels> tempatPengambilanModels = Rxn<TempatPengambilanModels>();
  Rxn<DetailsDonaturModels> detailDonaturModels = Rxn<DetailsDonaturModels>();
  

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

  Future<bool> postCheckingSelfFirst({String? urlImage}) async {
    try {
      isLoading(true);
      var request = http.MultipartRequest('POST', Uri.parse('${GlobalVariable.mainURL}/mulai-berangkat'));
      request.fields.addAll({
        'user': authController.token.value
      });
      request.files.add(await http.MultipartFile.fromPath('image', urlImage!, contentType: MediaType('image', 'jpeg')));
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

  Future<bool> checkDetailsOfDonatur({String? code}) async {
    try {
      isLoading(true);
      http.Response response = await http.get(
        Uri.tryParse("${GlobalVariable.mainURL}/detail-donatur?code=$code&user=${authController.token.value}")!,
        headers: {
          'x-api-key': GlobalVariable.apiKey,
        }
      );

      var result = jsonDecode(response.body);
      isLoading(false);
      if (response.statusCode == 200) {
        if(result['success']) {
          detailDonaturModels.value = DetailsDonaturModels.fromJson(result);
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