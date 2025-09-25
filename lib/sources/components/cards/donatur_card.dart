import 'package:asb_app/sources/models/donatur_model.dart';
import 'package:flutter/material.dart';

class DonaturCard extends StatelessWidget {
  final Donatur donatur;
  final int index;
  final VoidCallback onTap;

  const DonaturCard({
    super.key,
    required this.donatur,
    required this.index,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    '${index}. ${donatur.nama}',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                _buildNotificationIcons(donatur),
              ],
            ),
            SizedBox(height: 8),
            Text(
              'Kode: ${donatur.kode}',
              style: TextStyle(color: Colors.grey[700]),
            ),
            Text(
              'Alamat: ${donatur.alamat}',
              style: TextStyle(color: Colors.grey[700]),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              'No. HP: ${donatur.telepon}',
              style: TextStyle(color: Colors.grey[700]),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationIcons(Donatur donatur) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (donatur.h2 == true) const Icon(Icons.notifications, color: Colors.red, size: 20),
        if (donatur.h1 == true) const Icon(Icons.notifications, color: Colors.orange, size: 20),
        if (donatur.h == true) const Icon(Icons.notifications, color: Colors.green, size: 20),
        if (donatur.rapel == true) const Icon(Icons.notifications, color: Colors.purple, size: 20),
        if (donatur.jadwalRapel == true) const Icon(Icons.notifications, color: Colors.blue, size: 20),
      ],
    );
  }
}