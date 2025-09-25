import 'package:asb_app/sources/controllers/generate_kwitansi_controller.dart';
import 'package:asb_app/sources/models/master_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:icons_plus/icons_plus.dart';

class GenerateKwitansiView extends StatelessWidget {
  
  final GenerateKwitansiController controller;

  GenerateKwitansiView({super.key})
      : controller = Get.put(GenerateKwitansiController(
          // Asumsi argumen dikirim dari PerhitunganPerolehanView
          jadwalID: Get.arguments['jadwalID'] as String,
          userToken: Get.arguments['userToken'] as String,
          donaturName: Get.arguments['donaturName'] as String,
          totalPerolehan: Get.arguments['totalPerolehan'] as int,
        ));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Generate Kwitansi', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.indigo,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Obx(() {
        if (controller.isDataLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // --- Kartu Total ---
              _buildTotalCard(controller),
              const SizedBox(height: 30),

              // --- Dropdown Pilihan Pengurus ---
              _buildMasterDropdown(
                label: 'Pengurus yang Menerima Dana',
                hint: 'Pilih Pengurus',
                items: controller.listPengurus,
                selectedValue: controller.selectedPengurusId.value,
                onChanged: (MasterItem? item) {
                  controller.selectedPengurusId.value = item?.id;
                },
              ),
              const SizedBox(height: 20),

              // --- Dropdown Pilihan Program ---
              _buildMasterDropdown(
                label: 'Program Donasi',
                hint: 'Pilih Program',
                items: controller.listProgram,
                selectedValue: controller.selectedProgramId.value,
                onChanged: (MasterItem? item) {
                  controller.selectedProgramId.value = item?.id;
                },
              ),
              const SizedBox(height: 40),

              // --- Tombol Generate ---
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: controller.isGenerating.value ? null : controller.generateKwitansi,
                  icon: controller.isGenerating.value 
                      ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                      : const Icon(EvaIcons.file_text),
                  label: Text(
                    controller.isGenerating.value ? 'Membuat Kwitansi...' : 'Generate Kwitansi',
                    style: const TextStyle(fontSize: 18),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    padding: const EdgeInsets.symmetric(vertical: 18),
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
  
  // Widget Pembantu: Kartu Total
  Widget _buildTotalCard(GenerateKwitansiController controller) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.indigo.shade50,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.indigo.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Rincian Kwitansi', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.indigo)),
          const Divider(),
          _buildInfoRow('Donatur', controller.donaturName),
          _buildInfoRow('ID Jadwal', controller.jadwalID),
          _buildInfoRow('Total Perolehan', controller.rupiahFormatter.format(controller.totalPerolehan), isTotal: true),
        ],
      ),
    );
  }
  
  Widget _buildInfoRow(String label, String value, {bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(fontWeight: FontWeight.w600, fontSize: isTotal ? 16 : 14)),
          Text(value, style: TextStyle(fontWeight: isTotal ? FontWeight.bold : FontWeight.normal, fontSize: isTotal ? 18 : 14, color: isTotal ? Colors.teal : Colors.black87)),
        ],
      ),
    );
  }

  // Widget Pembantu: Dropdown Master Data
  Widget _buildMasterDropdown({
    required String label,
    required String hint,
    required List<MasterItem> items,
    required String? selectedValue,
    required void Function(MasterItem?) onChanged,
  }) {
    // Cari MasterItem yang sesuai dengan selectedValue
    MasterItem? currentItem;
    if (selectedValue != null) {
      currentItem = items.firstWhereOrNull((item) => item.id == selectedValue);
    }
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade400),
            borderRadius: BorderRadius.circular(8),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<MasterItem>(
              isExpanded: true,
              hint: Text(hint),
              value: currentItem,
              items: items.map((MasterItem item) {
                return DropdownMenuItem<MasterItem>(
                  value: item,
                  child: Text(item.name),
                );
              }).toList(),
              onChanged: onChanged,
            ),
          ),
        ),
      ],
    );
  }
}