import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../controllers/donatur_list_controller.dart'; 
import '../models/donatur_model.dart'; 

class DonaturDetailController extends GetxController {
  
  // PERBAIKAN: Gunakan 'late' dan inisialisasi di constructor
  late final Rx<Donatur> donatur; 
  
  var isSendingNotif = false.obs;
  var isUpdatingJadwal = false.obs;

  // States untuk Jadwal
  var selectedDate = Rxn<DateTime>();
  var selectedTime = Rxn<TimeOfDay>();
  
  // Formatters
  final dateFormatter = DateFormat('yyyy-MM-dd');
  final timeFormatter = DateFormat('HH:mm:ss');

  
  // PERBAIKAN: Terima data awal dan gunakan untuk inisialisasi properti 'donatur'
  DonaturDetailController({required Donatur initialDonatur}) {
    // 1. INISIALISASI Rx<Donatur> dengan data awal yang valid
    donatur = Rx<Donatur>(initialDonatur); 
    
    // 2. Logika Inisialisasi selectedTime dan selectedDate
    
    // VARIABEL BANTU untuk menampung tanggal dan waktu yang berhasil diurai
    DateTime? parsedDate;
    TimeOfDay? parsedTime;

    // A. PRIORITAS 1: Coba inisialisasi waktu dari kolom 'jam' terpisah (format HH:mm:ss)
    final jamString = donatur.value.jam;
    if (jamString != null && jamString.isNotEmpty) {
      try {
        final parts = jamString.split(':');
        final hour = int.parse(parts[0]);
        final minute = int.parse(parts[1]);
        parsedTime = TimeOfDay(hour: hour, minute: minute);
      } catch (_) {
        // Abaikan jika format jam salah
      }
    } 

    // B. PRIORITAS 2: Coba inisialisasi dari 'tanggal_pengambilan'
    final tanggalString = donatur.value.tanggalPengambilan;
    if (tanggalString != null && tanggalString.isNotEmpty) {
      try {
        // Coba parsing sebagai DateTime lengkap (termasuk waktu jika ada)
        final dt = DateTime.parse(tanggalString);
        parsedDate = dt;
        
        // Jika Prioritas 1 gagal, gunakan waktu dari DateTime (Prioritas 2)
        if (parsedTime == null) {
          parsedTime = TimeOfDay.fromDateTime(dt);
        }
      } catch (_) {
        // Abaikan jika format tanggal salah
      }
    }
    
    // 3. Set nilai Rx
    selectedDate.value = parsedDate;
    selectedTime.value = parsedTime;
}

  // --- FUNGSI: REFRESH DATA DONATUR DI HALAMAN DETAIL ---
  void refreshDonaturData() {
    final DonaturListController donaturListController = Get.find();
    
    final updatedDonatur = donaturListController.donaturList.firstWhereOrNull(
      (d) => d.kode == donatur.value.kode,
    );

    if (updatedDonatur != null) {
      donatur.value = updatedDonatur;
      Get.snackbar('Data Diperbarui', 'Status notifikasi telah di-refresh.', 
                   backgroundColor: Colors.lightBlue, colorText: Colors.white, duration: const Duration(seconds: 2));
    }
  }
  // -----------------------------------------------------------

  // --- FUNGSI: KIRIM NOTIFIKASI ---
  Future<void> sendNotification(String type) async {
    print(donatur.value.jadwaID);
    isSendingNotif(true);
    try {
      final prefs = await SharedPreferences.getInstance();
      final userToken = prefs.getString('token');

      if (userToken == null) {
        Get.snackbar('Error', 'Sesi pengguna tidak valid.', backgroundColor: Colors.red, colorText: Colors.white);
        return;
      }

      var headers = {
        'Content-Type': 'application/x-www-form-urlencoded',
        'X-Api-Key': 's4jJ6jRP95AT04BLBdGgHw4sDgJdmD'
      };

      var request = http.Request('POST', Uri.parse('https://asb-asbuwloj-api.techcrm.net/send-notif'));
      
      request.bodyFields = {
        'user': userToken,
        'type': type,
        'donatur': donatur.value.kode ?? '', 
        'jadwal': donatur.value.jadwaID ?? '' 
      };
      request.headers.addAll(headers);

      final response = await request.send();
      final respBody = await response.stream.bytesToString();
      
      if (response.statusCode == 200) {
        Get.snackbar('Sukses', 'Notifikasi berhasil dikirim!', backgroundColor: Colors.green, colorText: Colors.white);
        
        final DonaturListController donaturListController = Get.find();
        await donaturListController.fetchDonaturList();

        refreshDonaturData(); 
        
      } else {
        Get.snackbar('Error', 'Gagal mengirim notifikasi: ${response.reasonPhrase} | $respBody', backgroundColor: Colors.red, colorText: Colors.white);
      }
    } catch (e) {
      Get.snackbar('Error', 'Terjadi kesalahan: $e', backgroundColor: Colors.red, colorText: Colors.white);
    } finally {
      isSendingNotif(false);
    }
  }
  // -----------------------------------------------------------

  // --- FUNGSI: UPDATE JADWAL PENGAMBILAN ---
  Future<void> updateJadwal() async {
    if (selectedDate.value == null || selectedTime.value == null) {
      Get.snackbar('Perhatian', 'Mohon pilih tanggal dan jam pengambilan.', backgroundColor: Colors.amber, colorText: Colors.black);
      return;
    }

    isUpdatingJadwal(true);
    try {
      final prefs = await SharedPreferences.getInstance();
      final userToken = prefs.getString('token');
      
      if (userToken == null) {
        Get.snackbar('Error', 'Sesi pengguna tidak valid.', backgroundColor: Colors.red, colorText: Colors.white);
        return;
      }
      
      final DateTime selectedDateTime = selectedDate.value!.copyWith(
          hour: selectedTime.value!.hour, 
          minute: selectedTime.value!.minute
      );
      final String datetimeString = DateFormat('yyyy-MM-dd HH:mm:ss').format(selectedDateTime);

      var headers = {
        'Content-Type': 'application/x-www-form-urlencoded',
        'X-Api-Key': 's4jJ6jRP95AT04BLBdGgHw4sDgJdmD'
      };
      
      var request = http.Request('POST', Uri.parse('https://asb-asbuwloj-api.techcrm.net/master/jadwal/update_tanggal'));
      
      request.bodyFields = {
        'user': userToken,
        'drute_id': donatur.value.id ?? '', 
        'datetime': datetimeString
      };
      request.headers.addAll(headers);

      final response = await request.send();
      final respBody = await response.stream.bytesToString();

      if (response.statusCode == 200) {
        Get.snackbar('Sukses', 'Jadwal pengambilan berhasil diperbarui!', backgroundColor: Colors.green, colorText: Colors.white);
        
        Get.find<DonaturListController>().fetchDonaturList();
        refreshDonaturData(); 

      } else {
        Get.snackbar('Error', 'Gagal update jadwal: ${response.reasonPhrase} | $respBody', backgroundColor: Colors.red, colorText: Colors.white);
      }
    } catch (e) {
      Get.snackbar('Error', 'Terjadi kesalahan: $e', backgroundColor: Colors.red, colorText: Colors.white);
    } finally {
      isUpdatingJadwal(false);
    }
  }
  // -----------------------------------------------------------
}