import 'dart:io';
import 'package:asb_app/sources/controllers/donatur_list_controller.dart';
import 'package:asb_app/sources/views/dashboards/donautur/perhitungan_perolehan_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/donatur_model.dart'; // Pastikan path benar

class KonfirmasiPengambilanController extends GetxController {
  final Donatur donatur;
  
  // Data reaktif
  var selectedImages = <File>[].obs;
  var deskripsi = ''.obs;
  var isLoading = false.obs;
  
  // Data lokasi
  var currentLatitude = Rxn<double>();
  var currentLongitude = Rxn<double>();
  var locationError = ''.obs;

  KonfirmasiPengambilanController({required this.donatur});

  @override
  void onInit() {
    super.onInit();
    // Ambil lokasi saat controller dibuat
    getCurrentLocation();
  }

  // --- FUNGSI PENGAMBILAN LOKASI ---
  Future<void> getCurrentLocation() async {
    locationError.value = '';
    try {
      bool serviceEnabled;
      LocationPermission permission;

      serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        locationError.value = 'Layanan lokasi dinonaktifkan. Mohon aktifkan GPS Anda.';
        return;
      }

      permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          locationError.value = 'Izin lokasi ditolak.';
          return;
        }
      }
      
      if (permission == LocationPermission.deniedForever) {
        locationError.value = 'Izin lokasi ditolak permanen. Ubah di pengaturan aplikasi.';
        return;
      }

      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high
      );
      currentLatitude.value = position.latitude;
      currentLongitude.value = position.longitude;

    } catch (e) {
      locationError.value = 'Gagal mendapatkan lokasi: $e';
    }
  }

  // --- FUNGSI PEMILIHAN FOTO ---
  Future<void> pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.camera, imageQuality: 50);

    if (pickedFile != null) {
      if (selectedImages.length < 3) {
        selectedImages.add(File(pickedFile.path));
      } else {
        Get.snackbar('Perhatian', 'Maksimal 3 foto diperbolehkan.', backgroundColor: Colors.amber);
      }
    }
  }
  
  void removeImage(int index) {
    selectedImages.removeAt(index);
  }

  // --- FUNGSI PENGIRIMAN API ---
  Future<void> konfirmasiPengambilan() async {
    if (selectedImages.isEmpty) {
      Get.snackbar('Validasi', 'Mohon upload minimal 1 foto bukti pengambilan.', backgroundColor: Colors.red);
      return;
    }
    if (currentLatitude.value == null || currentLongitude.value == null) {
      Get.snackbar('Validasi', locationError.value.isNotEmpty ? locationError.value : 'Lokasi belum terambil. Coba muat ulang.', backgroundColor: Colors.red);
      return;
    }

    isLoading(true);
    try {
      final prefs = await SharedPreferences.getInstance();
      final userToken = prefs.getString('token'); // Asumsi ini adalah 'user' ID
      
      if (userToken == null) {
        Get.snackbar('Error', 'Sesi pengguna tidak valid.', backgroundColor: Colors.red);
        return;
      }

      var headers = {
        'X-Api-Key': 's4jJ6jRP95AT04BLBdGgHw4sDgJdmD'
      };
      
      var request = http.MultipartRequest(
        'POST', 
        Uri.parse('https://asb-asbuwloj-api.techcrm.net/konfirmasi-pengambilan')
      );
      
      // Isi fields
      request.fields.addAll({
        'jadwal': donatur.jadwalId ?? '', 
        'user': userToken,
        'lat': currentLatitude.value!.toString(),
        'lng': currentLongitude.value!.toString(),
        'desc': deskripsi.value,
      });

      // Isi files
      for (var image in selectedImages) {
        request.files.add(
          await http.MultipartFile.fromPath(
            'images[]', // Gunakan array field name jika API mendukungnya
            image.path,
            contentType: MediaType('image', 'jpeg')
          )
        );
      }

      request.headers.addAll(headers);

      final http.StreamedResponse response = await request.send();
      final respBody = await response.stream.bytesToString();

      if (response.statusCode == 200) {
        // Asumsi respons JSON berisi 'success: true'
        Get.snackbar('Sukses', 'Konfirmasi pengambilan berhasil dikirim!', backgroundColor: Colors.green);
        Get.back(); // Kembali ke halaman detail donatur
        
        // Opsional: Refresh list donatur di halaman sebelumnya
        Get.find<DonaturListController>().fetchDonaturList();
        final prefs = await SharedPreferences.getInstance();
        final userToken = prefs.getString('token') ?? ''; // Ambil user token lagi
        final jadwalId = donatur.jadwalId ?? '';

        // --- UBAH NAVIGASI DI SINI ---
        // Kirim jadwalID dan userToken ke halaman perhitungan
        Get.off(() => PerhitunganPerolehanView(), arguments: {
            'jadwalID': jadwalId,
            'userToken': userToken,
            'namaDonatur': donatur.nama
        }); 

      } else {
        Get.snackbar('Error', 'Gagal konfirmasi: ${response.reasonPhrase} | $respBody', backgroundColor: Colors.red);
      }
    } catch (e) {
      Get.snackbar('Error', 'Terjadi kesalahan: $e', backgroundColor: Colors.red);
    } finally {
      isLoading(false);
    }
  }
}