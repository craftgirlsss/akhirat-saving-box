import 'dart:convert';
import 'package:asb_app/src/components/global/index.dart';
import 'package:asb_app/src/controllers/auth/auth_controller.dart';
import 'package:asb_app/src/models/daftar_donatur_models.dart';
import 'package:asb_app/src/models/detail_donatur_models.dart';
import 'package:asb_app/src/models/rute_models.dart';
import 'package:asb_app/src/models/tempat_pengambilan_models.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

class TrackingController extends GetxController {
  RxBool isLoading = false.obs;
  RxString responseMessage = "".obs;
  RxBool wasSelfieAsFirst = false.obs;
  AuthController authController = Get.put(AuthController());
  Rxn<RuteModels> ruteModels = Rxn<RuteModels>();
  Rxn<DaftarDonaturModels> daftarDonatur = Rxn<DaftarDonaturModels>();
  Rxn<TempatPengambilanModels> tempatPengambilanModels = Rxn<TempatPengambilanModels>();
  Rxn<DetailDonaturModels> detailDonaturModels = Rxn<DetailDonaturModels>();

  Future<bool> getRute() async {
    try {
      isLoading(true);
      http.Response response = await http.get(
        Uri.tryParse("${GlobalVariable.mainURL}/list-rute?user=${authController.token.value}")!,
        headers: {
          'x-api-key': GlobalVariable.apiKey,
        }
      );

      var result = jsonDecode(response.body);
      isLoading(false);
      if (response.statusCode == 200) {
        if(result['success']) {
          ruteModels.value = RuteModels.fromJson(result);
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

  Future<bool> getListDonatur({String? ruteID, String? date, String? type = "semua"}) async {
    try {
      isLoading(true);
      http.Response response = await http.get(
        Uri.tryParse("${GlobalVariable.mainURL}/list-donatur?user=${authController.token.value}&rute_id=$ruteID&type=$type&bulan=$date")!,
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
          daftarDonatur.value = DaftarDonaturModels.fromJson(result);
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


  Future<bool> ambilRute({String? jadwaID}) async {
    try {
      isLoading(true);
      http.Response response = await http.post(
        Uri.tryParse("${GlobalVariable.mainURL}/konfirmasi-rute")!,
        headers: {
          'x-api-key': GlobalVariable.apiKey,
        },
        body: {
          'user': authController.token.value,
          'jadwal': jadwaID
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


  Future<bool> postNotification({String? type, String? donaturID, String? jadwaID}) async {
    try {
      isLoading(true);
      http.Response response = await http.post(
        Uri.tryParse("${GlobalVariable.mainURL}/send-notif")!,
        headers: {
          'x-api-key': GlobalVariable.apiKey,
        },
        body: {
          'user': authController.token.value,
          'type': type,
          'donatur': donaturID,
          'jadwal': jadwaID
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

  Future<bool> ubahTanggalRapel({String? jam, String? jadwalID, String? tanggal}) async {
    try {
      isLoading(true);
      http.Response response = await http.post(
        Uri.tryParse("${GlobalVariable.mainURL}/update-jadwal")!,
        headers: {
          'x-api-key': GlobalVariable.apiKey,
        },
        body: {
          'user': authController.token.value,
          'jadwal': jadwalID,
          'tanggal': tanggal,
          'waktu': jam
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

  Future<bool> batalkanPengambilanRute({String? jadwalID}) async {
    try {
      isLoading(true);
      http.Response response = await http.post(
        Uri.tryParse("${GlobalVariable.mainURL}/batalkan-rute")!,
        headers: {
          'x-api-key': GlobalVariable.apiKey,
        },
        body: {
          'user': authController.token.value,
          'jadwal': jadwalID,
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

  Future<bool> selesaiAmbil({String? jadwalID, List<String>? photos}) async {
    try {
      isLoading(true);
      var request = http.MultipartRequest('POST', Uri.parse('${GlobalVariable.mainURL}/konfirmasi-pengambilan'));
      request.headers.addAll({'x-api-key': GlobalVariable.apiKey});
      request.fields.addAll({
        'jadwal': jadwalID ?? '',
        'user': authController.token.value
      });


      if(photos == null){
        responseMessage.value = "Image kosong";
        return false;
      }else if(photos.isEmpty){
        responseMessage.value = "Image kurang dari 1";
        return false;
      }

      for(int i = 0; i<photos.length; i++){
        request.files.add(await http.MultipartFile.fromPath('images[]', photos[i], contentType: MediaType('image', 'jpeg')));
      }

      http.StreamedResponse response = await request.send();
      jsonDecode(await response.stream.bytesToString());
      isLoading(false);
      if (response.statusCode == 200) {
        responseMessage.value = "Berhasil mengirim gambar";
        return true;
      } else {
        responseMessage.value = "Gagal mengirim gambar";
        return false;
      }
    } catch (e) {
      isLoading(false);
      responseMessage.value = e.toString();
      return false;
    }
  }

  Future<bool> hitungPerolehan({String? jadwalID, Map<String, dynamic>? perolehan}) async {
    try {
      isLoading(true);
      http.Response response = await http.post(
        Uri.tryParse("${GlobalVariable.mainURL}/konfirmasi-perhitungan")!,
        headers: {
          'x-api-key': GlobalVariable.apiKey,
        },
        body: {
          'user': authController.token.value,
          'jadwal': jadwalID,
          'data': jsonEncode(perolehan)
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