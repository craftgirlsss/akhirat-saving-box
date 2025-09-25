import 'package:asb_app/sources/components/cards/donatur_card.dart';
import 'package:asb_app/sources/controllers/donatur_list_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'donatur_detail_view.dart';

class DonaturListView extends StatelessWidget {
  final DonaturListController controller = Get.put(DonaturListController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: const Text('Daftar Donatur', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.blueAccent,
        actions: [
          // Tambahkan tombol informasi di sini
          IconButton(
            icon: const Icon(Icons.info_outline, color: Colors.white),
            onPressed: () => _showLegendDialog(context),
          ),
        ],
      ),
      // ... sisa body dari kode sebelumnya
      body: Column(
        children: [
          _buildFilterSection(context),
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }
              if (controller.donaturList.isEmpty) {
                return const Center(child: Text('Tidak ada donatur ditemukan.', style: TextStyle(fontSize: 16, color: Colors.grey)));
              }
              return ListView.builder(
                padding: const EdgeInsets.all(16.0),
                itemCount: controller.donaturList.length,
                itemBuilder: (context, index) {
                  final donatur = controller.donaturList[index];
                  return DonaturCard(
                    donatur: donatur,
                    index: index + 1,
                    onTap: () {
                      Get.to(() => DonaturDetailView(), arguments: donatur);
                    },
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }

  // Fungsi untuk menampilkan dialog
  void _showLegendDialog(BuildContext context) {
    Get.dialog(
      AlertDialog(
        backgroundColor: Colors.white,
        title: const Text('Informasi Notifikasi', style: TextStyle(fontWeight: FontWeight.bold)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildLegendItem(color: Colors.red, label: 'H-2: Jatuh tempo dalam 2 hari'),
            _buildLegendItem(color: Colors.orange, label: 'H-1: Jatuh tempo besok'),
            _buildLegendItem(color: Colors.green, label: 'H: Jatuh tempo hari ini'),
            _buildLegendItem(color: Colors.purple, label: 'Rapel: Ada tunggakan pembayaran'),
            _buildLegendItem(color: Colors.blue, label: 'Jadwal Rapel: Terdapat jadwal rapel'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Tutup', style: TextStyle(color: Colors.blueAccent)),
          ),
        ],
      ),
    );
  }

  Widget _buildLegendItem({required Color color, required String label}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(Icons.notifications, color: color, size: 20),
          const SizedBox(width: 16),
          Expanded(child: Text(label)),
        ],
      ),
    );
  }

  // ... _buildFilterSection dan DonaturCard tetap sama seperti sebelumnya
  Widget _buildFilterSection(BuildContext context) {
    // ...
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.white,
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Obx(() {
                    // 1. Buat daftar item Dropdown dari data rute
                    List<DropdownMenuItem<String>> dropdownItems = controller.routeList
                        .map((area) => DropdownMenuItem(value: area.nama, child: Text(area.nama)))
                        .toList();

                    // 2. Tentukan nilai yang akan digunakan sebagai 'value' saat ini
                    String currentValue = controller.selectedRuteName.value;

                    // 3. Tambahkan item placeholder jika daftar rute kosong atau sedang memuat
                    if (dropdownItems.isEmpty) {
                        // Pastikan nilai placeholder yang digunakan di Controller ('Memuat Rute...')
                        // atau nilai default lain disertakan dalam daftar items.
                        dropdownItems.add(DropdownMenuItem(
                            value: currentValue,
                            child: Text(currentValue, style: const TextStyle(color: Colors.grey)),
                        ));
                    }

                    // 4. Lakukan validasi terakhir untuk menghindari error.
                    // Jika nilai yang terpilih tidak ada di dalam daftar item (misal, karena data baru),
                    // setel kembali nilai terpilih ke item pertama (atau placeholder).
                    if (!dropdownItems.any((item) => item.value == currentValue)) {
                        // Ini akan memastikan 'value' selalu cocok dengan item saat ini.
                        currentValue = dropdownItems.first.value!;
                        // Penting: Update nilai di controller agar sinkron setelah data dimuat
                        // dan item lama tidak valid lagi.
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                            controller.selectedRuteName.value = currentValue;
                            // Jangan panggil fetchDonaturList di sini, karena sudah dipanggil di onInit setelah rute di set.
                        });
                    }

                    return DropdownButtonFormField<String>(
                        // Gunakan currentValue yang sudah divalidasi
                        value: currentValue,
                        items: dropdownItems,
                        onChanged: (val) {
                            if (val != null && val != 'Memuat Rute...') {
                                // Panggil fungsi perubahan rute yang sudah kita buat di Controller
                                controller.changeSelectedRute(val); 
                            }
                        },
                        decoration: const InputDecoration(labelText: 'Pilih Rute'),
                        // Nonaktifkan dropdown jika hanya ada satu item placeholder
                        hint: dropdownItems.length == 1 && dropdownItems.first.value == currentValue 
                              ? Text(currentValue) : null,
                    );
                }),
            ),
              const SizedBox(width: 16),
              Expanded(
                child: Obx(() => DropdownButtonFormField<String>(
                  value: controller.selectedProgramType.value,
                  items: ['Semua', 'Rapel'].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                  onChanged: (val) {
                    controller.selectedProgramType.value = val!;
                    controller.fetchDonaturList();
                  },
                  decoration: const InputDecoration(labelText: 'Tipe Program'),
                )),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Month and Year Picker
          Row(
            children: [
              const Icon(Icons.calendar_today, color: Colors.grey),
              const SizedBox(width: 8),
              const Text('Tanggal:', style: TextStyle(fontSize: 16, color: Colors.grey)),
              const SizedBox(width: 8),
              Obx(() => Text(controller.selectedDate.value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold))),
              const SizedBox(width: 8),
              IconButton(
                icon: const Icon(Icons.edit, color: Colors.blueAccent),
                onPressed: () => _showMonthPicker(context),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showMonthPicker(BuildContext context) async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      initialDatePickerMode: DatePickerMode.year,
    );
    if (pickedDate != null) {
      controller.selectedDate.value = DateFormat('yyyy-MM').format(pickedDate);
      controller.fetchDonaturList();
    }
  }
}