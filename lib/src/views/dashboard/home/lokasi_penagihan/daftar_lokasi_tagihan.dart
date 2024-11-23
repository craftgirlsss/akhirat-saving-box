import 'dart:io';

import 'package:asb_app/src/components/global/index.dart';
import 'package:asb_app/src/controllers/utilities/location_controller.dart';
import 'package:asb_app/src/views/dashboard/home/lokasi_penagihan/detail_lokasi.dart';
import 'package:asb_app/src/views/dashboard/home/lokasi_penagihan/persiapan_berangkat.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class DaftarLokasiTagihan extends StatefulWidget {
  const DaftarLokasiTagihan({super.key});

  @override
  State<DaftarLokasiTagihan> createState() => _DaftarLokasiTagihanState();
}

class _DaftarLokasiTagihanState extends State<DaftarLokasiTagihan> {
  LocationController locationController = Get.put(LocationController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        forceMaterialTransparency: true,
        title: const Text("Daftar Tempat", style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
        centerTitle: true,
        actions: [
          Obx(() => CupertinoButton(onPressed: locationController.wasSelfieAsFirst.value ? null : (){
            pickImageFromCamera();
          }, child: Icon(CupertinoIcons.photo_camera_solid, color: locationController.wasSelfieAsFirst.value ? Colors.grey : GlobalVariable.secondaryColor)))
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Obx(() => cardItem(
                urlPhoto: "https://static.promediateknologi.id/crop/0x150:1600x1053/0x0/webp/photo/p2/85/2023/06/26/oke-masjid-agung-salat-id-218673181.jpeg",
                  onPressed: locationController.wasSelfieAsFirst.value ? (){
                    Get.to(() => const DetailLokasi(
                      type: Type.masjid,
                      name: "Masjid Al-Muttaqin", subtitle: "Jl. Siti Hajar, No.5, Jagir, Surabaya"));
                  } : (){
                    _showAlertDialogOnlyYes(context, title: "Gagal", content: "Anda belum melakukan pengambilan gambar diri sendiri untuk memulai pengambilan kotak, silahkan klik tombol kamera pada pojok kanan atas. Mohon foto selfi dengan perlengkapan lengkap sesuai aturan yang berlaku.");
                  },
                  title: "Masjid Al-Muttaqin",
                  subtitle: "Jl. Siti Hajar, No.5, Jagir, Surabaya",
                  wasChecked: false
              ),
            ),

            Obx(() => cardItem(
                urlPhoto: "https://www.darulmukmin-karimun.or.id/wp-content/uploads/2023/06/d6c59f77-0775-47f5-bef5-5cf9763911e6-1.jpg",
                  onPressed: locationController.wasSelfieAsFirst.value ? (){
                    Get.to(() => const DetailLokasi(
                      type: Type.rumah,
                      name: "Rumah Tahfiz Darul Huffaz", subtitle: "Jl. Siti Hajar, No.5, Jagir, Surabaya"));
                  } : (){
                    _showAlertDialogOnlyYes(context, title: "Gagal", content: "Anda belum melakukan pengambilan gambar diri sendiri untuk memulai pengambilan kotak, silahkan klik tombol kamera pada pojok kanan atas. Mohon foto selfi dengan perlengkapan lengkap sesuai aturan yang berlaku.");
                  },
                  title: "Rumah Tahfiz Darul Huffaz",
                  subtitle: "Jl. Siti Hajar, No.5, Jagir, Surabaya",
                  wasChecked: false
              ),
            ),
          ]
          // children: List.generate(3, (i) => Obx(() => cardItem(
          //   urlPhoto: "https://static.promediateknologi.id/crop/0x150:1600x1053/0x0/webp/photo/p2/85/2023/06/26/oke-masjid-agung-salat-id-218673181.jpeg",
          //     onPressed: locationController.wasSelfieAsFirst.value ? (){
          //       Get.to(() => const DetailLokasi(name: "Masjid Al-Muttaqin", subtitle: "Jl. Siti Hajar, No.5, Jagir, Surabaya"));
          //     } : (){
          //       _showAlertDialogOnlyYes(context, title: "Gagal", content: "Anda belum melakukan pengambilan gambar diri sendiri untuk memulai pengambilan kotak, silahkan klik tombol kamera pada pojok kanan atas. Mohon foto selfi dengan perlengkapan lengkap sesuai aturan yang berlaku.");
          //     },
          //     title: "Masjid Al-Muttaqin",
          //     subtitle: "Jl. Siti Hajar, No.5, Jagir, Surabaya",
          //     wasChecked: false
          //   ),
          // )),
        ),
      ),
      bottomNavigationBar: Obx(() => Padding(
          padding: const EdgeInsets.all(30),
          child: locationController.wasSelfieAsFirst.value ? const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.check_circle_sharp, color: Colors.green, size: 17),
              SizedBox(width: 8),
              Text("Sudah mengirim foto awal keberangkatan", textAlign: TextAlign.center),
            ],
          ) : const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(CupertinoIcons.xmark_circle_fill, color: Colors.grey, size: 17),
              SizedBox(width: 8),
              Text("Belum mengambil foto untuk awal keberangkatan", textAlign: TextAlign.center),
            ],
          ),
        ),
      ),
    );
  }

  void _showAlertDialog(BuildContext contex, {String? title, String? content}) {
    showCupertinoDialog<void>(
      context: context,
      builder: (BuildContext context) => CupertinoAlertDialog(
        title: Text(title ?? 'Akhiri'),
        content: Text(content ?? 'Apakah anda sudah mendatangi tempat dan menandai telah dihadiri?'),
        actions: <CupertinoDialogAction>[
          CupertinoDialogAction(
            isDefaultAction: true,
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Tidak'),
          ),
          CupertinoDialogAction(
            isDestructiveAction: true,
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Ya'),
          ),
        ],
      ),
    );
  }

  void _showAlertDialogOnlyYes(BuildContext contex, {String? title, String? content}) {
    showCupertinoDialog<void>(
      context: context,
      builder: (BuildContext context) => CupertinoAlertDialog(
        title: Text(title ?? 'Akhiri'),
        content: Text(content ?? 'Apakah anda sudah mendatangi tempat dan menandai telah dihadiri?'),
        actions: <CupertinoDialogAction>[
          CupertinoDialogAction(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Mengerti'),
          ),
        ],
      ),
    );
  }

  File? imageCamera;
  String? imagePath;
  pickImageFromCamera() async {
    final ImagePicker picker = ImagePicker();
    final XFile? imagePicked = await picker.pickImage(source: ImageSource.camera, imageQuality: 50, preferredCameraDevice: CameraDevice.front, requestFullMetadata: true);
    if(imagePicked != null){
      setState(() {
        imageCamera = File(imagePicked.path);
        imagePath = imagePicked.path;
      });
      Get.to(() => PersiapanBerangkat(urlImage: imagePath));
    }else{
      debugPrint("Image kosong");
    }
  }

  Widget cardItem({String? title, String? subtitle, bool? wasChecked, String? urlPhoto, Function()? onPressed}){
    return ListTile(
      onTap: onPressed,
      leading: urlPhoto != null ? Container(
        width: 60,
        height: 60,
        clipBehavior: Clip.hardEdge,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black45),
          borderRadius: BorderRadius.circular(5)
        ),
        child: Image.network(urlPhoto, fit: BoxFit.cover)) : Image.asset('assets/images/background.png', width: 60),
      title: Text(title ?? "Nama tidak diketahui", style: const TextStyle(fontSize: 13, color: Colors.black, fontWeight: FontWeight.bold)),
      subtitle: Text(subtitle ?? "Alamat tidak diketahui", style: const TextStyle(fontSize: 10, color: Colors.black54)),
      trailing: wasChecked == true ? const Icon(Icons.check_circle_sharp, color: Colors.green, size: 25) : const Icon(Icons.circle_outlined, color: Colors.red, size: 25)
    );
  }
}