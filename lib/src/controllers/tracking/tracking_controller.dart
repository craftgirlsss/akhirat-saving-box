import 'dart:convert';
import 'package:asb_app/src/components/global/index.dart';
import 'package:asb_app/src/controllers/auth/auth_controller.dart';
import 'package:asb_app/src/models/daftar_donatur_models.dart';
import 'package:asb_app/src/models/detail_donatur_models.dart';
import 'package:asb_app/src/models/history_models.dart';
import 'package:asb_app/src/models/list_jadwal_donatur.dart';
import 'package:asb_app/src/models/list_route_after_added_models.dart';
import 'package:asb_app/src/models/rute_models.dart';
import 'package:asb_app/src/models/tempat_pengambilan_models.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

class TrackingController extends GetxController {
  RxBool isLoading = false.obs;
  RxBool isLoadingUpdateTanggal = false.obs;
  RxString responseMessage = "".obs;
  RxBool wasSelfieAsFirst = false.obs;
  AuthController authController = Get.put(AuthController());
  Rxn<RuteModels> ruteModels = Rxn<RuteModels>();
  Rxn<DaftarDonaturModels> daftarDonatur = Rxn<DaftarDonaturModels>();
  Rxn<TempatPengambilanModels> tempatPengambilanModels = Rxn<TempatPengambilanModels>();
  Rxn<DetailDonaturModels> detailDonaturModels = Rxn<DetailDonaturModels>();
  Rxn<HistoryModels> historyModels = Rxn<HistoryModels>();
  Rxn<ListJadwal> listJadwalDonatur = Rxn<ListJadwal>();
  Rxn<ListRuteAfterAddedModels> listRuteTerbaru = Rxn<ListRuteAfterAddedModels>();

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

  Future<bool> getRuteV2({String? ruteID, String? type, String? tanggal}) async {
    try {
      isLoading(true);
      http.Response response = await http.get(
        Uri.tryParse("${GlobalVariable.mainURL}/list-rute?user=${authController.token.value}&rute=$ruteID&type=$type&tanggal=$tanggal")!,
        headers: {
          'x-api-key': GlobalVariable.apiKey,
        }
      );

      var result = jsonDecode(response.body);
      isLoading(false);
      // print("ini ruteID = $ruteID");
      // print("ini userID = ${authController.token.value}");
      // print("ini type = $type");
      // print("ini tanggal = $tanggal");
      // print(result);
      if (response.statusCode == 200) {
        if(result['success']) {
          listRuteTerbaru.value = ListRuteAfterAddedModels.fromJson(result);
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
          wasSelfieAsFirst(true);
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
      print(result);
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

  Future<bool> ubahTanggalRapel({String? donaturID, String? tanggal, String? jam}) async {
    print("Fungsi ubahTanggalRapel() dijalankan");
    try {
      isLoading(true);
      http.Response response = await http.post(
        Uri.tryParse("${GlobalVariable.mainURL}/master/jadwal/update")!,
        headers: {
          'x-api-key': GlobalVariable.apiKey,
        },
        body: {
          'user': authController.token.value,
          'drute_id': donaturID,
          'date': tanggal,
          'time' : jam
        },
      );
      var result = jsonDecode(response.body);
      print("Ini result ubahTanggalRapel => $result dengan donaturID => $donaturID dan userID => ${authController.token.value} dan tanggal => $tanggal");
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

  Future<bool> selesaiAmbil({String? jadwalID, List<String>? photos, double? lat, double? long, String? catatanKhusus}) async {
    try {
      isLoading(true);
      var request = http.MultipartRequest('POST', Uri.parse('${GlobalVariable.mainURL}/konfirmasi-pengambilan'));
      request.headers.addAll({'x-api-key': GlobalVariable.apiKey});
      request.fields.addAll({
        'jadwal': jadwalID ?? '',
        'user': authController.token.value,
        'lat': lat.toString(),
        'lng': long.toString(),
        'desc': catatanKhusus ?? "-"
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

      print("Ini bukti bukti => {jadwal: $jadwalID, userID: ${authController.token.value}, lattitude:$lat, long:$long, desc:$catatanKhusus photo:$photos}");

      http.StreamedResponse response = await request.send();
      var result = jsonDecode(await response.stream.bytesToString());
      print(result);
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

  Future<bool> getAllHistoryPengambilan() async {
    try {
      isLoading(true);
      http.Response response = await http.get(
        Uri.tryParse("${GlobalVariable.mainURL}/riwayat-pengambilan?user=${authController.token.value}")!,
        headers: {
          'x-api-key': GlobalVariable.apiKey,
        }
      );

      var result = jsonDecode(response.body);
      isLoading(false);
      if (response.statusCode == 200) {
        if(result['success']) {
          responseMessage.value = result['message'];
          historyModels.value = HistoryModels.fromJson(result);
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


  Future<bool> tambahDonaturAPI({
    String? wilayahID,
    String? province,
    String? kabupaten,
    String? kecamatan,
    String? programID,
    String? kodeASB,
    String? namaLengkap,
    String? gender,
    String? usia,
    String? noHP,
    String? alamat,
    double? lat,
    double? long,
  }) async {
    try {
      isLoading(true);
      http.Response response = await http.post(
        Uri.tryParse("${GlobalVariable.mainURL}/master/donatur/tambah")!,
        headers: {
          'x-api-key': GlobalVariable.apiKey,
        },
        body: {
          'user': authController.token.value,
          'kode': "ASB$kodeASB",
          'nama': namaLengkap,
          'jenis_kelamin': gender == "Laki-laki" ? "L" : "P",
          'usia': usia,
          'telepon': noHP,
          'alamat': alamat,
          'kecamatan': kecamatan,
          'kabupaten': kabupaten,
          'program': programID,
          'lat': lat.toString(),
          'lng': long.toString(),
          'area_id': wilayahID
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

  Future<bool> getDaftarJadwal() async {
    try {
      isLoading(true);
      http.Response response = await http.get(
        Uri.tryParse("${GlobalVariable.mainURL}/master/jadwal/list?user=${authController.token.value}")!,
        headers: {
          'x-api-key': GlobalVariable.apiKey,
        }
      );

      var result = jsonDecode(response.body);
      isLoading(false);
      if (response.statusCode == 200) {
        if(result['success']) {
          responseMessage.value = result['message'];
          listJadwalDonatur.value = ListJadwal.fromJson(result);
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

  Future<bool> updateTanggalPengambilan({String? donaturRuteID, String? date}) async {
    try {
      isLoadingUpdateTanggal(true);
      http.Response response = await http.post(
        Uri.tryParse("${GlobalVariable.mainURL}/master/jadwal/update")!,
        headers: {
          'x-api-key': GlobalVariable.apiKey,
        },
        body: {
          'user': authController.token.value,
          'drute_id': donaturRuteID ?? '0',
          'datetime': date ?? '2025-01-31 00:00:00'
        },
      );
      var result = jsonDecode(response.body);
      isLoadingUpdateTanggal(false);
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
      isLoadingUpdateTanggal(false);
      responseMessage.value = e.toString();
      return false;
    }
  }
}