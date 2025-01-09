import 'dart:io';

import 'package:asb_app/src/components/global/index.dart';
import 'package:asb_app/src/controllers/tracking/tracking_controller.dart';
import 'package:asb_app/src/controllers/utilities/location_controller.dart';
import 'package:asb_app/src/views/dashboard/home/lokasi_penagihan/cek_keberangkatan.dart';
import 'package:asb_app/src/views/dashboard/home/lokasi_penagihan/detail_lokasi.dart';
import 'package:asb_app/src/views/dashboard/home/lokasi_penagihan/persiapan_berangkat.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:image_picker/image_picker.dart';

class DaftarLokasiTagihan extends StatefulWidget {
  const DaftarLokasiTagihan({super.key});

  @override
  State<DaftarLokasiTagihan> createState() => _DaftarLokasiTagihanState();
}

class _DaftarLokasiTagihanState extends State<DaftarLokasiTagihan> {
  LocationController locationController = Get.put(LocationController());
  TrackingController trackingController = Get.put(TrackingController());
  RxBool wasSelfieAsFirst = false.obs;

  @override
  void initState() {
    super.initState();
    trackingController.getListTempatPengambilan();
    trackingController.checkingSelfFirst().then((value){
      wasSelfieAsFirst.value = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        forceMaterialTransparency: true,
        title: const Text("Daftar Tempat", style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
        centerTitle: true,
        actions: [
          Obx(() => CupertinoButton(onPressed: wasSelfieAsFirst.value ? null : (){
            // pickImageFromCamera();
            Get.to(() => const CekKeberangkatan());
          }, child: Icon(CupertinoIcons.photo_camera_solid, color: wasSelfieAsFirst.value ? Colors.grey : GlobalVariable.secondaryColor)))
        ],
      ),
      body: Obx(() => trackingController.isLoading.value ? SizedBox(
        width: size.width,
        height: size.height / 1.2,
        child: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(color: GlobalVariable.secondaryColor),
              SizedBox(height: 8),
              Text("Mendapatkan Data Lokasi...", style: TextStyle(fontSize: 12))
            ],
          ),
        ),
      ) : RefreshIndicator(
        backgroundColor: GlobalVariable.secondaryColor,
        color: Colors.white,
        semanticsLabel: "Loading...",
        onRefresh: () async => await trackingController.getListTempatPengambilan(),
        child: Obx(() {
          if(trackingController.tempatPengambilanModels.value?.data?.length == null || trackingController.tempatPengambilanModels.value?.data?.length == 0){
            return SizedBox(
              width: size.width,
              height: size.height / 1.2,
              child: const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(FontAwesome.map_pin_solid, size: 50, color: GlobalVariable.secondaryColor),
                    SizedBox(height: 8),
                    Text("Belum ada daftar lokasi untuk anda", style: TextStyle(fontSize: 12))
                  ],
                ),
              ),
            );
          } 
          return ListView(
              children: List.generate(trackingController.tempatPengambilanModels.value?.data?.length ?? 0, (i){
                return Obx(() => cardItem(
                    urlPhoto: trackingController.tempatPengambilanModels.value?.data?[i].thumbnail,
                    onPressed: wasSelfieAsFirst.value ? (){
                      Get.to(() => DetailLokasi(
                        type: Type.masjid,
                        code: trackingController.tempatPengambilanModels.value?.data?[i].code,
                        name: trackingController.tempatPengambilanModels.value?.data?[i].name ?? "Nama tempat tidak ada", 
                        subtitle: trackingController.tempatPengambilanModels.value?.data?[i].address ?? "Nama tempat tidak diketahui"));
                    } : (){
                      Get.to(() => DetailLokasi(
                        code: trackingController.tempatPengambilanModels.value?.data?[i].code,
                        type: Type.masjid,
                        name: trackingController.tempatPengambilanModels.value?.data?[i].name ?? "Nama tempat tidak ada", 
                        subtitle: trackingController.tempatPengambilanModels.value?.data?[i].address ?? "Nama tempat tidak diketahui"));
                      // _showAlertDialogOnlyYes(context, title: "Gagal", content: "Anda belum melakukan pengambilan gambar diri sendiri untuk memulai pengambilan kotak, silahkan klik tombol kamera pada pojok kanan atas. Mohon foto selfi dengan perlengkapan lengkap sesuai aturan yang berlaku.");
                    },
                    title: trackingController.tempatPengambilanModels.value?.data?[i].name ?? "Nama tempat tidak ada",
                    subtitle: trackingController.tempatPengambilanModels.value?.data?[i].available != null ? "${trackingController.tempatPengambilanModels.value?.data?[i].available} tempat belum diambil" : "Nama tempat tidak diketahui",
                    wasChecked: false
                  ),
                );
              })
            );
            }
          ),
        ),
      ),
      bottomNavigationBar: Obx(() => Padding(
          padding: const EdgeInsets.all(30),
          child: wasSelfieAsFirst.value ? const Row(
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

  void showAlertDialog(BuildContext contex, {String? title, String? content}) {
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