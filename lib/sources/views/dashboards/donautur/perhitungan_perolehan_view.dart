import 'package:asb_app/sources/controllers/perhitungan_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:icons_plus/icons_plus.dart';

class PerhitunganPerolehanView extends StatelessWidget {
  
  final PerhitunganPerolehanController controller;
  
  PerhitunganPerolehanView({super.key}) 
    : controller = Get.put(PerhitunganPerolehanController(
      // Ambil argumen yang dikirim dari KonfirmasiPengambilanView
      jadwalID: Get.arguments['jadwalID'] as String,
      userToken: Get.arguments['userToken'] as String,
      namaDonatur: Get.arguments['namaDonatur'] as String
    ));

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<PerhitunganPerolehanController>();

    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        backgroundColor: Colors.grey.shade50,
        appBar: AppBar(
          title: const Text('Perhitungan Perolehan Tunai', style: TextStyle(color: Colors.white)),
          backgroundColor: Colors.indigo,
          iconTheme: const IconThemeData(color: Colors.white),
        ),
        body: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Obx(() => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Rincian Kepingan Uang', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    const Divider(),
                    
                    // --- Input untuk pecahan > 500 ---
                    ...controller.denomDescriptions.keys.map((denom) {
                      return _buildDenomRow(
                        context,
                        controller,
                        denom,
                        controller.denomDescriptions[denom]!,
                      );
                    }),
      
                    const SizedBox(height: 30),
      
                    // --- Input Receh (Total di bawah Rp 500) ---
                    const Text('Uang Receh (< Rp 500)', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    const Divider(),
                    _buildRecehRow(context, controller),
      
                    const SizedBox(height: 30),
                    
                    // --- Hasil Perhitungan ---
                    _buildTotalCard(controller),
                  ],
                )),
              ),
            ),
            
            // --- Tombol Simpan ---
            _buildSaveButton(controller),
          ],
        ),
      ),
    );
  }

  // --- Widget Pembantu: Input Pecahan Uang ---
  Widget _buildDenomRow(BuildContext context, PerhitunganPerolehanController controller, int denom, String description) {
    // Hitung total untuk pecahan ini
    final currentCount = controller.counts[denom] ?? 0;
    final totalDenom = denom * currentCount;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Text(
              '${controller.rupiahFormatter.format(denom)} ($description)',
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
          
          Expanded(
            flex: 2,
            child: TextField(
              keyboardType: TextInputType.number,
              textAlign: TextAlign.center,
              onChanged: (value) => controller.updateCount(denom, value),
              decoration: const InputDecoration(
                hintText: 'Jumlah keping',
                isDense: true,
                border: OutlineInputBorder(),
              ),
            ),
          ),
          
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.only(left: 12.0),
              child: Text(
                controller.rupiahFormatter.format(totalDenom),
                textAlign: TextAlign.right,
                style: TextStyle(fontWeight: FontWeight.bold, color: totalDenom > 0 ? Colors.green.shade700 : Colors.grey),
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  // --- Widget Pembantu: Input Total Receh ---
  Widget _buildRecehRow(BuildContext context, PerhitunganPerolehanController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          const Expanded(
            flex: 3,
            child: Text(
              'Total Receh',
              style: TextStyle(fontWeight: FontWeight.w600, color: Colors.blue),
            ),
          ),
          
          Expanded(
            flex: 4,
            child: TextField(
              keyboardType: TextInputType.number,
              textAlign: TextAlign.right,
              onChanged: (value) => controller.updateTotalReceh(value),
              decoration: const InputDecoration(
                hintText: 'Masukkan total receh',
                isDense: true,
                prefixText: 'Rp ',
                border: OutlineInputBorder(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --- Widget Pembantu: Kartu Total ---
  Widget _buildTotalCard(PerhitunganPerolehanController controller) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.indigo.shade50,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.indigo.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildTotalRow('Total Uang Kertas/Koin (> Rp 500)', controller.rupiahFormatter.format(controller.subTotalPerolehan), Colors.black87),
          const SizedBox(height: 8),
          _buildTotalRow('Total Uang Receh (< Rp 500)', controller.rupiahFormatter.format(controller.totalReceh.value), Colors.black87),
          const Divider(thickness: 2, height: 20),
          _buildTotalRow('GRAND TOTAL PEROLEHAN', controller.rupiahFormatter.format(controller.grandTotalPerolehan), Colors.indigo.shade700, size: 22),
        ],
      ),
    );
  }

  Widget _buildTotalRow(String label, String value, Color color, {double size = 16}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: TextStyle(fontWeight: FontWeight.w600, fontSize: size * 0.75)),
        Text(value, style: TextStyle(fontWeight: FontWeight.bold, fontSize: size, color: color)),
      ],
    );
  }

  Widget _buildSaveButton(PerhitunganPerolehanController controller) {
      return Container(
        padding: const EdgeInsets.all(16),
        width: double.infinity,
        child: Obx(() => ElevatedButton.icon( // Bungkus dengan Obx untuk state loading
          onPressed: controller.isLoading.value ? null : (){
            controller.savePerolehan(namaDonatur: controller.namaDonatur);
          },
          icon: controller.isLoading.value 
              ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
              : const Icon(EvaIcons.save, size: 24),
          label: Text(
            controller.isLoading.value ? 'Mengirim...' : 'Simpan Perhitungan dan Selesai', 
            style: const TextStyle(fontSize: 18)
          ),
          // ... (style lainnya)
        ),
      ));
    }
}