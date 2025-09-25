import 'package:asb_app/sources/controllers/konfirmasi_pengambilan_controller.dart';
import 'package:asb_app/sources/models/donatur_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:io';
import 'package:icons_plus/icons_plus.dart';

class KonfirmasiPengambilanView extends StatelessWidget {
  final Donatur donatur = Get.arguments as Donatur;
  
  KonfirmasiPengambilanView({super.key}) {
    Get.put(KonfirmasiPengambilanController(donatur: donatur));
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<KonfirmasiPengambilanController>();

    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        backgroundColor: Colors.grey.shade50,
        appBar: AppBar(
          title: const Text('Konfirmasi Pengambilan', style: TextStyle(color: Colors.white)),
          backgroundColor: Colors.blueAccent,
          iconTheme: const IconThemeData(color: Colors.white),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // --- Informasi Donatur ---
              _buildInfoCard(
                title: 'Donatur',
                content: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Nama: ${controller.donatur.nama ?? '-'}', style: const TextStyle(fontSize: 16)),
                    Text('ID Jadwal: ${controller.donatur.jadwalId ?? 'N/A'}', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              
              // --- Input Deskripsi ---
              _buildInfoCard(
                title: 'Catatan Pengambilan',
                content: TextField(
                  onChanged: (value) => controller.deskripsi.value = value,
                  maxLines: 3,
                  decoration: const InputDecoration(
                    hintText: 'Masukkan deskripsi atau catatan tambahan...',
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.all(12),
                  ),
                ),
              ),
              const SizedBox(height: 24),
      
              // --- Lokasi Pekerja ---
              _buildInfoCard(
                title: 'Lokasi Anda Saat Ini',
                content: Obx(() {
                  if (controller.locationError.isNotEmpty) {
                    return Text('Error: ${controller.locationError.value}', style: const TextStyle(color: Colors.red));
                  }
                  if (controller.currentLatitude.value == null) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Latitude: ${controller.currentLatitude.value!.toStringAsFixed(6)}'),
                      Text('Longitude: ${controller.currentLongitude.value!.toStringAsFixed(6)}'),
                      const SizedBox(height: 8),
                      TextButton.icon(
                        onPressed: controller.getCurrentLocation,
                        icon: const Icon(Iconsax.refresh_circle_outline, size: 18),
                        label: const Text('Muat Ulang Lokasi'),
                      )
                    ],
                  );
                }),
              ),
              const SizedBox(height: 24),
      
              // --- Upload Foto ---
              _buildInfoCard(
                title: 'Foto Bukti Pengambilan (Maks 3)',
                content: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Obx(() => Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: [
                        // Tombol Ambil Foto
                        GestureDetector(
                          onTap: controller.pickImage,
                          child: Container(
                            width: 100,
                            height: 100,
                            decoration: BoxDecoration(
                              color: Colors.grey.shade200,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: Colors.grey.shade400),
                            ),
                            child: const Icon(Icons.camera_alt, size: 40, color: Colors.grey),
                          ),
                        ),
                        
                        // Tampilkan Foto yang Sudah Dipilih
                        ...controller.selectedImages.asMap().entries.map((entry) {
                          int index = entry.key;
                          File image = entry.value;
                          return Stack(
                            children: [
                              Container(
                                width: 100,
                                height: 100,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  image: DecorationImage(
                                    image: FileImage(image),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              Positioned(
                                top: 0,
                                right: 0,
                                child: GestureDetector(
                                  onTap: () => controller.removeImage(index),
                                  child: Container(
                                    padding: const EdgeInsets.all(2),
                                    decoration: const BoxDecoration(
                                      color: Colors.red,
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(Icons.close, size: 16, color: Colors.white),
                                  ),
                                ),
                              ),
                            ],
                          );
                        }),
                      ],
                    )),
                  ],
                ),
              ),
              const SizedBox(height: 30),
      
              // --- Tombol Konfirmasi ---
              Obx(() => SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: controller.isLoading.value ? null : controller.konfirmasiPengambilan,
                    icon: controller.isLoading.value
                        ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                        : const Icon(EvaIcons.checkmark_circle),
                    label: Text(
                      controller.isLoading.value ? 'Mengirim...' : 'Kirim Konfirmasi',
                      style: const TextStyle(fontSize: 18),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      padding: const EdgeInsets.symmetric(vertical: 18),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  // Widget Pembantu
  Widget _buildInfoCard({required String title, required Widget content}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            spreadRadius: 1,
            blurRadius: 10,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blueAccent)),
          const Divider(height: 24),
          content,
        ],
      ),
    );
  }
}