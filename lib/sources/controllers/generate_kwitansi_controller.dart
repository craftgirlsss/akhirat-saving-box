import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import '../models/master_model.dart'; // Pastikan path benar

class GenerateKwitansiController extends GetxController {
  // Data yang diterima dari PerhitunganPerolehanView
  final String jadwalID;
  final String userToken;
  final String donaturName;
  final int totalPerolehan;

  GenerateKwitansiController({
    required this.jadwalID,
    required this.userToken,
    required this.donaturName,
    required this.totalPerolehan,
  });

  // Data Master untuk Dropdown
  var listPengurus = <MasterItem>[].obs;
  var listProgram = <MasterItem>[].obs;
  var isDataLoading = true.obs;

  // State Pilihan Pengguna
  var selectedPengurusId = Rxn<String>();
  var selectedProgramId = Rxn<String>();
  var isGenerating = false.obs;

  final rupiahFormatter = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp', decimalDigits: 0);
  
  @override
  void onInit() {
    super.onInit();
    fetchMasterData();
  }

  // --- FUNGSI MENGAMBIL DATA MASTER ---
  Future<void> fetchMasterData() async {
    isDataLoading(true);
    try {
      // Panggil kedua API secara paralel
      final results = await Future.wait([
        _fetchPengurus(),
        _fetchProgram(),
      ]);

      if (results[0].success) {
        listPengurus.assignAll(results[0].data);
      } else {
        Get.snackbar('Error', 'Gagal memuat daftar pengurus: ${results[0].message}', backgroundColor: Colors.red);
      }
      
      if (results[1].success) {
        listProgram.assignAll(results[1].data);
      } else {
        Get.snackbar('Error', 'Gagal memuat daftar program: ${results[1].message}', backgroundColor: Colors.red);
      }

    } catch (e) {
      Get.snackbar('Error', 'Terjadi kesalahan saat memuat data master: $e', backgroundColor: Colors.red);
    } finally {
      isDataLoading(false);
    }
  }

  // API List Pengurus
  Future<MasterListResponse> _fetchPengurus() async {
    var headers = {'X-Api-Key': 's4jJ6jRP95AT04BLBdGgHw4sDgJdmD'};
    var url = 'https://asb-asbuwloj-api.techcrm.net/nama-pengurus?user=$userToken';
    var response = await http.get(Uri.parse(url), headers: headers);
    
    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      return MasterListResponse.fromJson(jsonResponse, 'name'); // 'name' adalah key untuk nama pengurus
    } else {
      return MasterListResponse(success: false, message: response.reasonPhrase ?? 'Unknown Error', data: []);
    }
  }

  // API List Program
  Future<MasterListResponse> _fetchProgram() async {
    var headers = {'X-Api-Key': 's4jJ6jRP95AT04BLBdGgHw4sDgJdmD'};
    var url = 'https://asb-asbuwloj-api.techcrm.net/master/program/list?user=$userToken';
    var response = await http.get(Uri.parse(url), headers: headers);
    
    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      return MasterListResponse.fromJson(jsonResponse, 'nama'); // 'nama' adalah key untuk nama program
    } else {
      return MasterListResponse(success: false, message: response.reasonPhrase ?? 'Unknown Error', data: []);
    }
  }

  // --- FUNGSI GENERATE KWITANSI ---
  Future<void> generateKwitansi() async {
    if (selectedPengurusId.value == null || selectedProgramId.value == null) {
      Get.snackbar('Perhatian', 'Mohon pilih Pengurus dan Program terlebih dahulu.', backgroundColor: Colors.amber);
      return;
    }

    isGenerating(true);
    try {
      var headers = {
        'Content-Type': 'application/x-www-form-urlencoded',
        'X-Api-Key': 's4jJ6jRP95AT04BLBdGgHw4sDgJdmD'
      };
      
      var request = http.Request('POST', Uri.parse('https://asb-asbuwloj-api.techcrm.net/master/kuitansi/custom'));
      request.bodyFields = {
        'user': userToken,
        'donatur': donaturName,
        'program': listProgram.firstWhere((p) => p.id == selectedProgramId.value).name, // Kirim nama program
        'jumlah': totalPerolehan.toString(),
        'pengurus': selectedPengurusId.value!,
      };
      request.headers.addAll(headers);

      final http.StreamedResponse response = await request.send();
      final respBody = await response.stream.bytesToString();

      if (response.statusCode == 200) {
        Get.snackbar(
          'Sukses', 
          'Kwitansi berhasil dibuat! Total: ${rupiahFormatter.format(totalPerolehan)}',
          backgroundColor: Colors.green,
          colorText: Colors.white
        );
        
        // Selesai: Kembali ke dashboard atau rute utama
        Get.until((route) => Get.currentRoute == '/ruteList'); 
        
      } else {
        Get.snackbar(
          'Error', 
          'Gagal membuat kwitansi: ${response.reasonPhrase} | $respBody',
          backgroundColor: Colors.red,
          colorText: Colors.white
        );
      }
    } catch (e) {
      Get.snackbar('Error', 'Terjadi kesalahan saat koneksi: $e', backgroundColor: Colors.red);
    } finally {
      isGenerating(false);
    }
  }
}