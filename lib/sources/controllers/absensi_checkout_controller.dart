import 'dart:io';
import 'package:asb_app/sources/views/dashboards/dashboard_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../controllers/dashboard_controller.dart';

class AbsensiCheckoutController extends GetxController {
  var isLoading = false.obs;
  final ImagePicker _picker = ImagePicker();
  var selfieFile = Rxn<File>();
  var shoesAndPantsFile = Rxn<File>();
  var bikeAndCanFile = Rxn<File>();
  var notesController = TextEditingController();

  Future<void> pickImage(Function(File?) onImagePicked) async {
    final pickedFile = await _picker.pickImage(source: ImageSource.camera, imageQuality: 70);
    if (pickedFile != null) {
      onImagePicked(File(pickedFile.path));
    } else {
      Get.snackbar('Informasi', 'Pengambilan gambar dibatalkan.');
    }
  }

  Future<void> submitAbsensi() async {
    if (selfieFile.value == null || shoesAndPantsFile.value == null || bikeAndCanFile.value == null) {
      Get.snackbar('Error', 'Harap lengkapi semua foto sebelum mengirim.', backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }

    isLoading(true);

    try {
      final prefs = await SharedPreferences.getInstance();
      final userToken = prefs.getString('token');
      final kodeJalan = prefs.getString('kode_keberangkatan'); // Ambil kode_jalan yang sudah disimpan

      if (userToken == null || kodeJalan == null) {
        Get.snackbar('Error', 'Sesi login atau kode jalan tidak valid. Silakan hubungi admin.', backgroundColor: Colors.red, colorText: Colors.white);
        return;
      }

      var request = http.MultipartRequest('POST', Uri.parse('https://asb-asbuwloj-api.techcrm.net/selesai'));
      request.headers.addAll({
        'X-Api-Key': 's4jJ6jRP95AT04BLBdGgHw4sDgJdmD',
      });

      request.fields.addAll({
        'user': userToken,
        'desc': notesController.text,
        'kode_jalan': kodeJalan,
      });

      request.files.add(await http.MultipartFile.fromPath('image1', selfieFile.value!.path, contentType: MediaType('image', 'jpeg')));
      request.files.add(await http.MultipartFile.fromPath('image2', shoesAndPantsFile.value!.path, contentType: MediaType('image', 'jpeg')));
      request.files.add(await http.MultipartFile.fromPath('image3', bikeAndCanFile.value!.path, contentType: MediaType('image', 'jpeg')));

      final response = await request.send();

      if (response.statusCode == 200) {
        Get.snackbar('Sukses', 'Absen pulang berhasil!', backgroundColor: Colors.green, colorText: Colors.white);
        final DashboardController dashboardController = Get.find();
        dashboardController.hasCheckedOut.value = true;
        dashboardController.checkAbsenceStatus();
        Get.off(() => DashboardView()); // Kembali ke dashboard setelah checkout
      } else {
        final respBody = await response.stream.bytesToString();
        Get.snackbar('Error', 'Gagal absen pulang: ${response.reasonPhrase} | $respBody', backgroundColor: Colors.red, colorText: Colors.white);
      }
    } catch (e) {
      Get.snackbar('Error', 'Terjadi kesalahan: $e', backgroundColor: Colors.red, colorText: Colors.white);
    } finally {
      isLoading(false);
    }
  }
}