import 'dart:io';
import 'package:asb_app/sources/controllers/absensi_checkout_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AbsensiCheckoutView extends StatelessWidget {
  final AbsensiCheckoutController controller = Get.put(AbsensiCheckoutController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: const Text('Absen Pulang', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.orangeAccent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Ambil Dokumentasi Pulang', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            _buildImagePickerCard(
              title: 'Foto Selfie',
              onTap: () => controller.pickImage((file) => controller.selfieFile.value = file),
              imageFile: controller.selfieFile,
            ),
            const SizedBox(height: 16),
            _buildImagePickerCard(
              title: 'Foto Sepatu & Celana',
              onTap: () => controller.pickImage((file) => controller.shoesAndPantsFile.value = file),
              imageFile: controller.shoesAndPantsFile,
            ),
            const SizedBox(height: 16),
            _buildImagePickerCard(
              title: 'Foto Motor & Kaleng',
              onTap: () => controller.pickImage((file) => controller.bikeAndCanFile.value = file),
              imageFile: controller.bikeAndCanFile,
            ),
            const SizedBox(height: 24),
            const Text('Catatan Pulang', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            TextFormField(
              controller: controller.notesController,
              decoration: InputDecoration(
                hintText: 'Tulis catatan singkat...',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                fillColor: Colors.white,
                filled: true,
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 32),
            Obx(() => SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton.icon(
                onPressed: controller.isLoading.value ? null : () => controller.submitAbsensi(),
                icon: controller.isLoading.value ? const CircularProgressIndicator(color: Colors.white) : const Icon(Icons.send),
                label: const Text('Kirim Absensi Pulang', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orangeAccent,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  foregroundColor: Colors.white,
                ),
              ),
            )),
          ],
        ),
      ),
    );
  }

  Widget _buildImagePickerCard({
    required String title,
    required VoidCallback onTap,
    required Rxn<File> imageFile,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(15),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, spreadRadius: 1)],
        ),
        child: Obx(() => Row(
          children: [
            imageFile.value != null
                ? Container(
                    width: 70,
                    height: 70,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      image: DecorationImage(
                        image: FileImage(imageFile.value!),
                        fit: BoxFit.cover,
                      ),
                    ),
                  )
                : const Icon(Icons.camera_alt, color: Colors.blueGrey, size: 50),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 4),
                  Text(imageFile.value == null ? 'Ketuk untuk ambil foto' : 'Foto berhasil diambil', style: TextStyle(color: Colors.grey[600])),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios, color: Colors.grey),
          ],
        )),
      ),
    );
  }
}