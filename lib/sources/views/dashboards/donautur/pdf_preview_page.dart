import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:share_plus/share_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:dio/dio.dart';
import 'dart:io';

class PdfPreviewPage extends StatelessWidget {
  final String pdfUrl;
  
  const PdfPreviewPage({super.key, required this.pdfUrl});

  // --- FUNGSI MENDOWNLOAD DAN SHARE ---
  Future<String?> _downloadFile(BuildContext context) async {
    try {
      final dir = await getTemporaryDirectory();
      final filePath = '${dir.path}/kwitansi_${DateTime.now().millisecondsSinceEpoch}.pdf';
      
      await Dio().download(pdfUrl, filePath, onReceiveProgress: (received, total) {
        // Tampilkan progress download jika diperlukan
      });
      return filePath;
    } catch (e) {
      Get.snackbar('Error Download', 'Gagal mendownload file: $e', backgroundColor: Colors.red);
      return null;
    }
  }
  
  void _sharePdf(BuildContext context) async {
    final path = await _downloadFile(context);
    if (path != null) {
      final file = XFile(path);
      await Share.shareXFiles([file], text: 'Kwitansi Donasi ASB');
    }
  }
  
  void _downloadPdf(BuildContext context) async {
    final path = await _downloadFile(context);
    if (path != null) {
      // Pindahkan file dari temp ke lokasi download yang permanen
      // Di Android, ini bisa ke 'ExternalStorageDirectory' atau 'Downloads'
      
      final externalDir = await getExternalStorageDirectory(); // Lokasi yang lebih umum
      final permanentPath = '${externalDir!.path}/Download/kwitansi_${DateTime.now().millisecondsSinceEpoch}.pdf';
      
      try {
          await File(path).copy(permanentPath);
          Get.snackbar('Sukses', 'Kwitansi berhasil disimpan di: ${permanentPath}', backgroundColor: Colors.green);
      } catch(e) {
          Get.snackbar('Error Simpan', 'Gagal memindahkan file ke folder Download: $e', backgroundColor: Colors.red);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kwitansi', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.indigo,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          // Tombol Download
          IconButton(
            icon: const Icon(Icons.download),
            onPressed: () => _downloadPdf(context),
            tooltip: 'Download Kwitansi',
          ),
          // Tombol Share
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () => _sharePdf(context),
            tooltip: 'Bagikan Kwitansi',
          ),
        ],
      ),
      body: SfPdfViewer.network(
        pdfUrl,
        // Tampilkan loading screen/indicator saat memuat PDF
        initialScrollOffset: const Offset(0, 0),
        onDocumentLoadFailed: (details) {
          Get.snackbar('Error', 'Gagal memuat PDF: ${details.description}', backgroundColor: Colors.red);
        },
      ),
    );
  }
}