import 'package:asb_app/sources/controllers/dashboard_controller.dart';
import 'package:asb_app/sources/views/dashboards/donautur/donatur_list_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class DashboardView extends StatelessWidget {
  final DashboardController controller = Get.put(DashboardController());

  DashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text(
          'Dashboard ASB',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.blueAccent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Widget Informasi Real-Time & Lokasi
            _buildInfoCard(),
            const SizedBox(height: 24),
            // Judul Bagian Menu
            const Text(
              'Menu Utama',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 16),
            // Grid Menu
            _buildMenuGrid(),
          ],
        ),
      ),
    );
  }

  // Widget untuk menampilkan informasi jam dan lokasi
  Widget _buildInfoCard() {
    return Container(
      padding: const EdgeInsets.all(20),
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
      child: Row(
        children: [
          const Icon(Icons.access_time, color: Colors.blueAccent, size: 40),
          const SizedBox(width: 16),
          Expanded(
            child: Obx(() => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  DateFormat().add_jms().format(controller.currentTime.value),
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                Text(
                  DateFormat('EEEE, d MMMM y').format(controller.currentTime.value),
                  style: TextStyle(color: Colors.grey[600]),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.location_on, color: Colors.redAccent, size: 16),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        controller.location.value,
                        style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                      ),
                    ),
                  ],
                ),
              ],
            )),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuGrid() {
    return Obx(
      () => GridView.count(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        children: [
          _buildMenuItem(
            icon: Icons.people_alt,
            label: 'Daftar Donatur',
            color: Colors.lightBlueAccent,
            onTap: () => Get.to(() => DonaturListView()),
          ),
          _buildMenuItem(
            icon: Icons.directions_run,
            label: 'Mulai Berangkat',
            color: Colors.greenAccent,
            onTap: controller.startJourney,
            isDisabled: controller.hasCheckedIn.value,
          ),
          _buildMenuItem(
            icon: Icons.home,
            label: 'Check Out',
            color: Colors.orangeAccent,
            onTap: controller.checkout,
            isDisabled: !controller.hasCheckedIn.value || controller.hasCheckedOut.value,
          ),
          _buildMenuItem(
            icon: Icons.person_add,
            label: 'Tambah Donatur',
            color: Colors.purpleAccent,
            onTap: () => Get.toNamed('/tambah-donatur'),
          ),
          _buildMenuItem(
            icon: Icons.receipt_long,
            label: 'Buat Kwitansi',
            color: Colors.tealAccent,
            onTap: () => Get.toNamed('/buat-kwitansi'),
          ),
          _buildMenuItem(
            icon: Icons.settings,
            label: 'Settings',
            color: Colors.indigoAccent,
            onTap: () => Get.toNamed('/buat-kwitansi'),
          ),
        ],
      ),
    );
  }

  // Perbarui widget _buildMenuItem untuk mendukung status nonaktif (disabled)
  Widget _buildMenuItem({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
    bool isDisabled = false,
  }) {
    final effectiveColor = isDisabled ? Colors.grey : color;
    final effectiveOnTap = isDisabled ? () {} : onTap;

    return InkWell(
      onTap: effectiveOnTap,
      borderRadius: BorderRadius.circular(15),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDisabled ? Colors.grey[200] : Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: effectiveColor.withOpacity(isDisabled ? 0 : 0.2),
              spreadRadius: 2,
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 50,
              color: effectiveColor,
            ),
            const SizedBox(height: 8),
            Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: isDisabled ? Colors.grey[600] : Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }
}