import 'dart:convert';
import 'package:asb_app/sources/views/dashboards/donautur/pdf_preview_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import '../models/master_model.dart'; // Pastikan MasterItem ada di sini

class GenerateKwitansiAutoController extends GetxController {
  // Data yang diterima dari PerhitunganPerolehanView
  final String jadwalID;
  final String userToken;
  final int totalPerolehan; // Tetap disimpan untuk ditampilkan di view

  GenerateKwitansiAutoController({
    required this.jadwalID,
    required this.userToken,
    required this.totalPerolehan,
  });

  // Data Master
  var listPengurus = <MasterItem>[].obs;
  var isDataLoading = true.obs;

  // State Pilihan Pengguna
  var selectedPengurusId = Rxn<String>();
  var isGenerating = false.obs;

  final rupiahFormatter = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp', decimalDigits: 0);

  @override
  void onInit() {
    super.onInit();
    fetchPengurusData();
  }

  // --- FUNGSI MENGAMBIL DAFTAR PENGURUS ---
  Future<void> fetchPengurusData() async {
    isDataLoading(true);
    try {
      var headers = {'X-Api-Key': 's4jJ6jRP95AT04BLBdGgHw4sDgJdmD'};
      var url = 'https://asb-asbuwloj-api.techcrm.net/nama-pengurus?user=$userToken';
      var response = await http.get(Uri.parse(url), headers: headers);
      
      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        final masterResponse = MasterListResponse.fromJson(jsonResponse, 'name'); // 'name' adalah key untuk nama pengurus
        
        if (masterResponse.success) {
          listPengurus.assignAll(masterResponse.data);
          // Auto-select pengurus pertama jika ada
          if (listPengurus.isNotEmpty) {
            selectedPengurusId.value = listPengurus.first.id;
          }
        } else {
          Get.snackbar('Error', 'Gagal memuat daftar pengurus: ${masterResponse.message}', backgroundColor: Colors.red);
        }
      } else {
        Get.snackbar('Error', 'Gagal memuat data pengurus: ${response.reasonPhrase}', backgroundColor: Colors.red);
      }
    } catch (e) {
      Get.snackbar('Error', 'Terjadi kesalahan saat memuat pengurus: $e', backgroundColor: Colors.red);
    } finally {
      isDataLoading(false);
    }
  }

  // --- FUNGSI GENERATE KWITANSI ---
  Future<void> generateKwitansi() async {
    if (selectedPengurusId.value == null) {
      Get.snackbar('Perhatian', 'Mohon pilih Pengurus terlebih dahulu.', backgroundColor: Colors.amber);
      return;
    }

    isGenerating(true);
    try {
      var headers = {
        'Content-Type': 'application/x-www-form-urlencoded',
        'X-Api-Key': 's4jJ6jRP95AT04BLBdGgHw4sDgJdmD'
      };
      
      var request = http.Request('POST', Uri.parse('https://asb-asbuwloj-api.techcrm.net/master/kuitansi/create'));
      request.bodyFields = {
        'user': userToken,
        'jadwal': jadwalID,
        'pengurus': selectedPengurusId.value!,
      };
      request.headers.addAll(headers);

      final http.StreamedResponse response = await request.send();
      final respBody = await response.stream.bytesToString();
      final jsonResponse = json.decode(respBody);

      if (response.statusCode == 200 && jsonResponse['success'] == true) {
        final String pdfUrl = jsonResponse['data']['url'];

        Get.snackbar('Sukses', 'Kwitansi berhasil dibuat!', backgroundColor: Colors.green, colorText: Colors.white);
        
        // Navigasi ke halaman PDF Preview
        Get.to(() => PdfPreviewPage(pdfUrl: pdfUrl));
        
      } else {
        Get.snackbar(
          'Error', 
          'Gagal membuat kwitansi: ${jsonResponse['message'] ?? response.reasonPhrase}',
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