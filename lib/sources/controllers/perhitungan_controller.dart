import 'package:asb_app/sources/views/dashboards/donautur/generate_kwitansi_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:convert'; // Untuk encode JSON

class PerhitunganPerolehanController extends GetxController {
  
  // Data yang dikirim dari halaman sebelumnya
  final String jadwalID; 
  final String userToken;
  final String namaDonatur;
  
  // Satuan uang yang akan dihitung (dalam Rupiah)
  final Map<int, String> denomDescriptions = {
    100000: 'Seratus Ribu',
    50000: 'Lima Puluh Ribu',
    20000: 'Dua Puluh Ribu',
    10000: 'Sepuluh Ribu',
    5000: 'Lima Ribu',
    2000: 'Dua Ribu',
    1000: 'Seribu',
    500: 'Lima Ratus',
  };

  var counts = <int, int>{}.obs;
  var totalReceh = 0.obs;
  var isLoading = false.obs; // State loading untuk tombol

  final rupiahFormatter = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp', decimalDigits: 0);

  // CONSTRUCTOR BARU
  PerhitunganPerolehanController({required this.jadwalID, required this.userToken, required this.namaDonatur});

  @override
  void onInit() {
    for (var denom in denomDescriptions.keys) {
      counts[denom] = 0;
    }
    super.onInit();
  }

  // --- (updateCount, updateTotalReceh, subTotalPerolehan, grandTotalPerolehan tetap sama) ---

  void updateCount(int denom, String value) {
    int count = int.tryParse(value) ?? 0;
    counts[denom] = count;
    counts.refresh();
  }

  void updateTotalReceh(String value) {
    totalReceh.value = int.tryParse(value) ?? 0;
  }

  int get subTotalPerolehan {
    int total = 0;
    counts.forEach((denom, count) {
      total += denom * count;
    });
    return total;
  }
  
  int get grandTotalPerolehan => subTotalPerolehan + totalReceh.value;


  // --- FUNGSI BARU: POST API ---
  Future<void> savePerolehan({String? namaDonatur}) async {
    // Bangun body 'data' dalam format JSON
    Map<String, dynamic> dataPerhitungan = {
      'receh': totalReceh.value,
    };
    counts.forEach((denom, count) {
      dataPerhitungan[denom.toString()] = count;
    });
    
    // Konversi Map menjadi String JSON
    final dataJsonString = json.encode(dataPerhitungan);

    isLoading(true);
    try {
      var headers = {
        'X-Api-Key': 's4jJ6jRP95AT04BLBdGgHw4sDgJdmD'
      };
      
      var request = http.MultipartRequest(
        'POST', 
        Uri.parse('https://asb-asbuwloj-api.techcrm.net/konfirmasi-perhitungan')
      );
      
      request.fields.addAll({
        'jadwal': jadwalID,
        'user': userToken,
        'data': dataJsonString,
      });

      request.headers.addAll(headers);

      final http.StreamedResponse response = await request.send();
      final respBody = await response.stream.bytesToString();

      if (response.statusCode == 200) {
        Get.snackbar(
          'Sukses', 
          'Perhitungan total ${rupiahFormatter.format(grandTotalPerolehan)} berhasil dikirim!',
          backgroundColor: Colors.green,
          colorText: Colors.white
        );
        // Selesai: Kembali ke dashboard atau halaman rute utama
        Future.delayed(const Duration(seconds: 2), (){
          // Get.offNamed('/dashboard/donatur-list');
          // --- NAVIGASI KE HALAMAN KWITANSI ---
        Get.off(() => GenerateKwitansiView(), arguments: {
            'jadwalID': jadwalID,
            'userToken': userToken,
            'donaturName': namaDonatur ?? 'NAMA DONATUR DARI DETAIL', // Ganti dengan properti nama donatur yang benar
            'totalPerolehan': grandTotalPerolehan,
        });
        });
      } else {
        Get.snackbar(
          'Error', 
          'Gagal menyimpan perhitungan: ${response.reasonPhrase} | $respBody',
          backgroundColor: Colors.red,
          colorText: Colors.white
        );
      }
    } catch (e) {
      Get.snackbar('Error', 'Terjadi kesalahan saat koneksi: $e', backgroundColor: Colors.red);
    } finally {
      isLoading(false);
    }
  }
}