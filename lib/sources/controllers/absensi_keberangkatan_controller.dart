import 'dart:io';
import 'package:asb_app/sources/controllers/dashboard_controller.dart';
import 'package:asb_app/sources/views/dashboards/dashboard_view.dart';
import 'package:asb_app/src/controllers/auth/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';

class AbsensiKeberangkatanController extends GetxController {
  var isLoading = false.obs;
  AuthController authController = Get.put(AuthController());
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
      if (authController.token.value == "") {
        Get.snackbar('Error', 'Sesi login tidak valid. Silakan login kembali.', backgroundColor: Colors.red, colorText: Colors.white, icon: const Icon(Icons.error, color: Colors.white));
        return;
      }

      var request = http.MultipartRequest('POST', Uri.parse('https://asb-asbuwloj-api.techcrm.net/mulai-berangkat'));
      request.headers.addAll({
        'X-Api-Key': 's4jJ6jRP95AT04BLBdGgHw4sDgJdmD',
      });

      request.fields.addAll({
        'user': authController.token.value, // Gunakan user token dari SharedPreferences
        'desc': notesController.text,
      });

      request.files.add(await http.MultipartFile.fromPath('image1', selfieFile.value!.path, contentType: MediaType('image', 'jpeg')));
      request.files.add(await http.MultipartFile.fromPath('image2', shoesAndPantsFile.value!.path, contentType: MediaType('image', 'jpeg')));
      request.files.add(await http.MultipartFile.fromPath('image3', bikeAndCanFile.value!.path, contentType: MediaType('image', 'jpeg')));

      final response = await request.send();

      if (response.statusCode == 200) {
        Get.snackbar('Sukses', 'Absen keberangkatan berhasil!', backgroundColor: Colors.green, colorText: Colors.white, icon: const Icon(Icons.done_all, color: Colors.white));
        final DashboardController dashboardController = Get.find();
        dashboardController.hasCheckedIn.value = true;
        dashboardController.checkAbsenceStatus();
        Get.off(() => DashboardView());
      } else {
        final respBody = await response.stream.bytesToString();
        Get.snackbar('Error', 'Gagal absen keberangkatan: ${response.reasonPhrase} | $respBody', backgroundColor: Colors.red, colorText: Colors.white);
      }
    } catch (e) {
      Get.snackbar('Error', 'Terjadi kesalahan: $e', backgroundColor: Colors.red, colorText: Colors.white);
    } finally {
      isLoading(false);
    }
  }
}