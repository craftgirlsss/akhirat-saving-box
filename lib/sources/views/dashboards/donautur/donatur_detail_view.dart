import 'package:asb_app/sources/controllers/donatur_detail_controller.dart';
import 'package:asb_app/sources/models/donatur_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';

class DonaturDetailView extends StatelessWidget {

  final DonaturDetailController controller;

  DonaturDetailView({super.key})
      // PERBAIKAN: Tangani argumen dengan aman dan inisialisasi controller dengan argumen.
      : controller = Get.put(DonaturDetailController(
          initialDonatur: Get.arguments is Donatur 
            ? Get.arguments as Donatur 
            : Donatur(id: null, kode: 'Error', nama: 'Error: Data Hilang'), // Beri objek Donatur 'kosong'
        ));

  Future<LatLng?> _getCurrentLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition();
      return LatLng(position.latitude, position.longitude);
    } catch (e) {
      print('Error getting current location: $e');
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    // Gunakan Obx untuk membungkus seluruh body agar dapat merespon perubahan data donatur di controller
    return Obx(() {
      final Donatur currentDonatur = controller.donatur.value;

      // Parsing lokasi donatur menggunakan data dari controller
      final double? donaturLat = double.tryParse(currentDonatur.lokasiPenukaran?.lat ?? '');
      final double? donaturLng = double.tryParse(currentDonatur.lokasiPenukaran?.lng ?? '');

      // Cek apakah lokasi donatur valid
      final bool isDonaturLocationValid = donaturLat != null && donaturLng != null;
      final LatLng? donaturLocation = isDonaturLocationValid ? LatLng(donaturLat, donaturLng) : null;

      return Scaffold(
        backgroundColor: Colors.grey.shade50,
        appBar: AppBar(
          title: Text(currentDonatur.nama ?? '', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          backgroundColor: Colors.blueAccent,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildJadwalCard(context),
              const SizedBox(height: 24),
              _buildDetailCard(
                title: 'Informasi Donatur',
                children: [
                  // Semua akses properti sekarang menggunakan currentDonatur
                  _buildDetailRow(label: 'Nama Donatur', value: currentDonatur.nama ?? '-'),
                  _buildDetailRow(label: 'Kode Donatur', value: currentDonatur.kode ?? '-'),
                  _buildDetailRow(label: 'Nomor HP', value: currentDonatur.telepon ?? '-'),
                  _buildDetailRow(label: 'Jenis Kelamin', value: currentDonatur.jenisKelamin ?? '-'),
                  _buildDetailRow(label: 'Alamat', value: currentDonatur.alamat ?? '-'),
                  _buildDetailRow(label: 'Catatan Khusus', value: currentDonatur.catatanKhusus ?? '-'),
                  _buildDetailRow(label: 'Catatan Default', value: currentDonatur.catatanDefault ?? '-'),
                ],
              ),
              const SizedBox(height: 24),
              _buildDetailCard(
                title: 'Lokasi Donatur',
                children: [
                  // Logika kondisional untuk menampilkan peta atau teks
                  isDonaturLocationValid
                      ? SizedBox(
                          height: 300,
                          child: FutureBuilder<LatLng?>(
                            future: _getCurrentLocation(),
                            builder: (context, snapshot) {
                              final LatLng? workerLocation = snapshot.data;
                              
                              final List<Marker> markers = [
                                Marker(
                                  width: 80.0,
                                  height: 80.0,
                                  point: donaturLocation!,
                                  child: const Icon(Icons.location_on, color: Colors.blueAccent, size: 40),
                                ),
                                if (workerLocation != null)
                                  Marker(
                                    width: 80.0,
                                    height: 80.0,
                                    point: workerLocation,
                                    child: const Icon(Icons.person_pin_circle, color: Colors.green, size: 40),
                                  ),
                              ];

                              return FlutterMap(
                                options: MapOptions(
                                  initialCenter: donaturLocation,
                                  initialZoom: 15.0,
                                ),
                                children: [
                                  TileLayer(
                                    urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                                    userAgentPackageName: 'com.example.app',
                                  ),
                                  MarkerLayer(markers: markers),
                                ],
                              );
                            },
                          ),
                        )
                      : Container(
                          height: 300,
                          alignment: Alignment.center,
                          child: const Text(
                            'Lokasi donatur tidak ditemukan.',
                            style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic, color: Colors.red),
                          ),
                        ),
                ],
              ),
              const SizedBox(height: 24),
              _buildDetailCard(
                title: 'Status Notifikasi',
                children: [
                  // Status notifikasi juga menggunakan currentDonatur
                  _buildStatusRow(
                    label: 'H-2',
                    isActive: currentDonatur.h2 ?? false,
                    color: Colors.red,
                    onTap: () => controller.sendNotification('h2'),
                  ),
                  _buildStatusRow(
                    label: 'H-1',
                    isActive: currentDonatur.h1 ?? false,
                    color: Colors.orange,
                    onTap: () => controller.sendNotification('h1'),
                  ),
                  _buildStatusRow(
                    label: 'H',
                    isActive: currentDonatur.h ?? false,
                    color: Colors.green,
                    onTap: () => controller.sendNotification('h'),
                  ),
                  _buildStatusRow(
                    label: 'Rapel',
                    isActive: currentDonatur.rapel ?? false,
                    color: Colors.purple,
                    onTap: () => controller.sendNotification('rapel'),
                  ),
                  _buildStatusRow(
                    label: 'Jadwal Rapel',
                    isActive: currentDonatur.jadwalRapel ?? false,
                    color: Colors.blue,
                    onTap: () => controller.sendNotification('jadwal_rapel'),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    // ...
                  },
                  icon: const Icon(EvaIcons.checkmark_circle),
                  label: const Text('Konfirmasi Pengambilan', style: TextStyle(fontSize: 16)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  // --- Fungsi Pembantu (Tidak Berubah) ---

  Widget _buildDetailCard({required String title, required List<Widget> children}) {
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
          Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const Divider(height: 24),
          ...children,
        ],
      ),
    );
  }
  
  Widget _buildDetailRow({required String label, required String value}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(flex: 1, child: Text(label, style: const TextStyle(fontWeight: FontWeight.w600))),
          Expanded(flex: 2, child: Text(value)),
        ],
      ),
    );
  }

  Widget _buildStatusRow({required String label, required bool isActive, required Color color, required VoidCallback onTap,}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(Icons.notifications, color: isActive ? color : Colors.grey),
              const SizedBox(width: 8),
              Text(
                label,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: isActive ? Colors.black87 : Colors.grey,
                ),
              ),
              const SizedBox(width: 16),
              Text(isActive ? 'Aktif' : 'Tidak Aktif'),
            ],
          ),
          Obx(() => IconButton(
            padding: EdgeInsets.zero,
            onPressed: controller.isSendingNotif.value ? null : onTap,
            icon: controller.isSendingNotif.value
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(strokeWidth: 2.0),
                  )
                : const Icon(Iconsax.send_1_outline),
          )),
        ],
      ),
    );
  }

  Widget _buildJadwalCard(BuildContext context) {
    return _buildDetailCard(
      title: 'Atur Jadwal Pengambilan',
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Pilihan Tanggal
            Expanded(
              child: Obx(() => InkWell(
                onTap: () => _selectDate(context),
                child: InputDecorator(
                  decoration: const InputDecoration(
                    labelText: 'Tanggal',
                    border: OutlineInputBorder(),
                    suffixIcon: Icon(Icons.calendar_today, size: 20),
                  ),
                  child: Text(
                    controller.selectedDate.value == null 
                        ? 'Pilih Tanggal' 
                        : controller.dateFormatter.format(controller.selectedDate.value!),
                    style: TextStyle(fontSize: 16, color: controller.selectedDate.value == null ? Colors.grey[600] : Colors.black),
                  ),
                ),
              )),
            ),
            const SizedBox(width: 16),
            
            // Pilihan Jam
            Expanded(
              child: Obx(() => InkWell(
                onTap: () => _selectTime(context),
                child: InputDecorator(
                  decoration: const InputDecoration(
                    labelText: 'Jam',
                    border: OutlineInputBorder(),
                    suffixIcon: Icon(Icons.access_time, size: 20),
                  ),
                  child: Text(
                    controller.selectedTime.value == null 
                        ? 'Pilih Jam' 
                        : controller.selectedTime.value!.format(context),
                    style: TextStyle(fontSize: 16, color: controller.selectedTime.value == null ? Colors.grey[600] : Colors.black),
                  ),
                ),
              )),
            ),
          ],
        ),
        
        const SizedBox(height: 16),

        // Tombol Simpan Jadwal
        Obx(() => SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: controller.isUpdatingJadwal.value ? null : controller.updateJadwal,
              icon: controller.isUpdatingJadwal.value 
                  ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                  : const Icon(Icons.save),
              label: Text(
                controller.isUpdatingJadwal.value ? 'Menyimpan...' : 'Simpan Jadwal Baru', 
                style: const TextStyle(fontSize: 16)
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
            ),
          ),
        ),
      ],
    );
  }

  // FUNGSI BARU: Date Picker
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: controller.selectedDate.value ?? DateTime.now(),
        firstDate: DateTime.now().subtract(const Duration(days: 365)),
        lastDate: DateTime.now().add(const Duration(days: 365 * 5)),
        builder: (context, child) => Theme(
            data: ThemeData.light().copyWith(
              colorScheme: const ColorScheme.light(primary: Colors.blueAccent),
            ),
            child: child!,
        ),
    );
    if (picked != null) {
      controller.selectedDate.value = picked;
    }
  }

  // FUNGSI BARU: Time Picker
  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: controller.selectedTime.value ?? TimeOfDay.now(),
      builder: (context, child) => Theme(
        data: ThemeData.light().copyWith(
          colorScheme: const ColorScheme.light(primary: Colors.blueAccent),
        ),
        child: child!,
      ),
    );
    if (picked != null) {
      controller.selectedTime.value = picked;
    }
  }
}