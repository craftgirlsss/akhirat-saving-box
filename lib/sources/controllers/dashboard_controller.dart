import 'dart:async';
import 'dart:convert';
import 'package:asb_app/sources/views/dashboards/absensi/absensi_checkout_view.dart';
import 'package:asb_app/sources/views/dashboards/absensi/absensi_keberangkatan_view.dart';
import 'package:asb_app/src/controllers/auth/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class DashboardController extends GetxController {
  var currentTime = DateTime.now().obs;
  var location = 'Mendapatkan lokasi...'.obs;
  AuthController authController = Get.put(AuthController());
  var hasCheckedIn = false.obs; // Pastikan baris ini ada
  var hasCheckedOut = false.obs; // Pastikan baris ini juga ada
  var isCheckingStatus = true.obs; // Tambahkan state untuk loading status


  @override
  void onInit() {
    _startClock();
    _getLocation();
    checkAbsenceStatus();
    super.onInit();
  }

  void _startClock() {
    Timer.periodic(const Duration(seconds: 1), (timer) {
      currentTime.value = DateTime.now();
    });
  }

  Future<void> _getLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );
      if (placemarks.isNotEmpty) {
        final place = placemarks.first;
        final address = "${place.street}, ${place.subLocality}, ${place.locality}, ${place.administrativeArea}, ${place.country}";
        location.value = address;
      } else {
        location.value = 'Tidak dapat menemukan alamat';
      }
    } catch (e) {
      location.value = 'Gagal mendapatkan lokasi';
      print(e);
    }
  }


  Future<void> checkAbsenceStatus() async {
    isCheckingStatus(true);
    try {
      final prefs = await SharedPreferences.getInstance();
      final userToken = prefs.getString('token');
      if (userToken == null) {
        hasCheckedIn.value = false;
        isCheckingStatus(false);
        return;
      }

      var headers = {
        'X-Api-Key': 's4jJ6jRP95AT04BLBdGgHw4sDgJdmD',
      };
      
      // Menggunakan Get request dengan parameter di URI
      final response = await http.get(
        Uri.parse('https://asb-asbuwloj-api.techcrm.net/cek-keberangkatan?user=$userToken'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success'] == true) {
          prefs.setString('kode_keberangkatan', data['data']['code']);
          authController.kodeKeberangkatan(data['data']['code']);
          hasCheckedIn.value = true;
        } else {
          hasCheckedIn.value = false;
        }
      } else {
        Get.snackbar('Error', 'Gagal memuat status absensi: ${response.reasonPhrase}');
        hasCheckedIn.value = false;
      }
    } catch (e) {
      Get.snackbar('Error', 'Terjadi kesalahan saat memeriksa status: $e');
      hasCheckedIn.value = false;
    } finally {
      isCheckingStatus(false);
    }
  }

  void startJourney() {
  if (!hasCheckedIn.value) {
    Get.to(() => AbsensiKeberangkatanView()); // Arahkan ke halaman absen
  } else {
    _showErrorDialog('Anda sudah absen masuk hari ini.', 'Tidak dapat memulai perjalanan lagi.');
  }
}

  void checkout() {
    if (hasCheckedIn.value && !hasCheckedOut.value) {
      Get.to(() => AbsensiCheckoutView());
    } else if (!hasCheckedIn.value) {
      _showErrorDialog('Anda harus absen masuk terlebih dahulu.', 'Tidak dapat melakukan check-out.');
    } else {
      _showErrorDialog('Anda sudah absen pulang hari ini.', 'Tidak dapat melakukan check-out lagi.');
    }
  }

  // Fungsi untuk menampilkan dialog
  void _showErrorDialog(String title, String message) {
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('OK', style: TextStyle(color: Colors.blueAccent)),
          ),
        ],
      ),
    );
  }
}