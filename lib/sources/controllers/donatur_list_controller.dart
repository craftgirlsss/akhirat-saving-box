import 'dart:convert';
import 'package:asb_app/sources/models/donatur_model.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

import 'package:asb_app/sources/models/area_model.dart'; // Pastikan path ini benar

class DonaturListController extends GetxController {
  var isLoading = true.obs;
  var donaturList = <Donatur>[].obs;
  
  // State untuk filter
  // Ganti selectedRute (yang menyimpan nama) dengan ID rute yang akan dikirim ke API Donatur
  var selectedRuteId = ''.obs; 
  var selectedDate = DateFormat('yyyy-MM').format(DateTime.now()).obs;
  var selectedProgramType = 'Semua'.obs;

   // New States for Rute
  var routeList = <AreaModel>[].obs;
  // selectedRuteName digunakan untuk tampilan di Dropdown (display name)
  var selectedRuteName = 'Memuat Rute...'.obs;

  @override
  void onInit() {
    // Panggil fetchRouteList terlebih dahulu saat controller diinisialisasi
    fetchRouteList();
    super.onInit();
  }

  // Fungsi untuk mendapatkan ID rute berdasarkan Nama
  String _getRuteIdByName(String name) {
    try {
      return routeList.firstWhere((rute) => rute.nama == name).id;
    } catch (e) {
      return ''; // Kembalikan string kosong jika tidak ditemukan
    }
  }

  // FUNGSI 1: Ambil Daftar Rute dari API
  Future<void> fetchRouteList() async {
    isLoading(true);
    try {
      final prefs = await SharedPreferences.getInstance();
      final userToken = prefs.getString('token'); // Pastikan key 'token' benar
      
      var headers = {
        'X-Api-Key': 's4jJ6jRP95AT04BLBdGgHw4sDgJdmD'
      };
      
      // Menggunakan token user dinamis untuk API rute
      var url = 'https://asb-asbuwloj-api.techcrm.net/master/area/list?user=$userToken';
      
      var response = await http.get(Uri.parse(url), headers: headers);
      
      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        if (jsonResponse['success'] == true && jsonResponse['data'] is List) {
          routeList.value = (jsonResponse['data'] as List)
              .map((item) => AreaModel.fromJson(item))
              .toList();

          // Set rute default dan panggil fetchDonaturList
          if (routeList.isNotEmpty) {
            selectedRuteName.value = routeList.first.nama;
            selectedRuteId.value = routeList.first.id;
            fetchDonaturList(); // Panggil daftar donatur setelah rute di set
          } else {
            selectedRuteName.value = 'Tidak Ada Rute';
            isLoading(false);
          }
        }
      } else {
        Get.snackbar('Error Rute', 'Gagal memuat rute: ${response.reasonPhrase}');
        selectedRuteName.value = 'Rute Gagal Dimuat';
        isLoading(false);
      }
    } catch (e) {
      Get.snackbar('Error Rute', 'Terjadi kesalahan saat memuat rute: $e');
      selectedRuteName.value = 'Rute Error';
      isLoading(false);
    }
  }

  // FUNGSI 2: Ambil Daftar Donatur dari API
  Future<void> fetchDonaturList() async {
    // Pastikan ID rute sudah ada sebelum memanggil API
    if (selectedRuteId.value.isEmpty) {
        isLoading(false);
        return;
    }
    
    isLoading(true);
    try {
      final prefs = await SharedPreferences.getInstance();
      final userToken = prefs.getString('token');
      
      // **Menggunakan selectedRuteId yang dinamis**
      final ruteID = selectedRuteId.value; 

      final response = await http.get(
        Uri.parse('https://asb-asbuwloj-api.techcrm.net/list-rute?rute=$ruteID&tanggal=${selectedDate.value}&user=$userToken&type=$selectedProgramType'),
        headers: {'X-Api-Key': 's4jJ6jRP95AT04BLBdGgHw4sDgJdmD'},
      );

      if (response.statusCode == 200) {
        final donaturResponse = donaturListResponseFromJson(response.body);
        if (donaturResponse.success) {
          donaturList.value = donaturResponse.data;
        } else {
          Get.snackbar('Error', 'Gagal memuat data donatur: ${donaturResponse.message}');
          donaturList.clear();
        }
      } else {
        Get.snackbar('Error', 'Gagal memuat data donatur: ${response.reasonPhrase}');
        donaturList.clear();
      }
    } catch (e) {
      Get.snackbar('Error', 'Terjadi kesalahan saat memuat donatur: $e');
      donaturList.clear();
    } finally {
      isLoading(false);
    }
  }

  // FUNGSI PEMBANTU: Dipanggil dari View ketika filter rute berubah
  void changeSelectedRute(String newRuteName) {
    selectedRuteName.value = newRuteName;
    selectedRuteId.value = _getRuteIdByName(newRuteName);
    fetchDonaturList();
  }

  // FUNGSI PEMBANTU: Dipanggil dari View ketika filter tanggal/program berubah
  void applyFilters() {
    fetchDonaturList();
  }
}