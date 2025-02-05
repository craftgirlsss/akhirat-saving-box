import 'package:asb_app/src/components/global/index.dart';
import 'package:asb_app/src/controllers/tracking/tracking_controller.dart';
import 'package:asb_app/src/views/dashboard/home/lokasi_penagihan/cek_keberangkatan.dart';
import 'package:asb_app/src/views/dashboard/home/lokasi_penagihan/daftar_lokasi_tagihan_v2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:icons_plus/icons_plus.dart';

class MenuHariH extends StatefulWidget {
  const MenuHariH({super.key});

  @override
  State<MenuHariH> createState() => _MenuHariHState();
}

class _MenuHariHState extends State<MenuHariH> {
  TrackingController trackingController = Get.find();
  RxBool loading = false.obs;

  RxList menuTimDistribusi = 
    [
        {
          "name" : "Berangkat",
          "icon" : const Icon(Icons.rocket_launch, size: 30, color: GlobalVariable.secondaryColor), 
        },
        {
          "name" : "Donatur",
          "icon" : const Icon(CupertinoIcons.person_2_fill, size: 30, color: GlobalVariable.secondaryColor),
        },
        {
          "name" : "Kembali",
          "icon" : const Icon(Iconsax.back_square_bold, size: 30, color: GlobalVariable.secondaryColor),
        }
    ].obs;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final orientation = MediaQuery.of(context).orientation;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        forceMaterialTransparency: true,
        leading: IconButton(
          onPressed: (){
            Navigator.pop(context);
          }, 
          icon: const Icon(Iconsax.arrow_left_2_bold, size: 30,)
        ),
        backgroundColor:Colors.white,
        title: const Text("Daftar Aksi H", style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Obx(() => Wrap(
            alignment: WrapAlignment.center,
              children: List.generate(menuTimDistribusi.length, (i){
                return Obx(() => CupertinoButton(
                    onPressed: loading.value ? null : (){
                      if(i == 0){
                        if(trackingController.wasSelfieAsFirst.value){
                          Get.snackbar("Gagal", "Anda sudah melakukan cek keberangkatan untuk hari ini", backgroundColor: GlobalVariable.secondaryColor, colorText: Colors.white);
                        }else{
                          Get.to(() => const CekKeberangkatan());
                        }
                      }else if(i == 1){
                        if(trackingController.wasSelfieAsFirst.value){
                          // Get.to(() => const DaftarDonaturH());
                          Get.to(() => const DaftarLokasiTagihanv2());
                        }else{
                          Get.snackbar("Gagal", "Anda belum melakukan progress keberangkatan untuk hari ini", backgroundColor: GlobalVariable.secondaryColor, colorText: Colors.white);
                        }
                      }else{
                        if(trackingController.wasSelfieAsFirst.value){
                          Get.to(() => const CekKeberangkatan(isGoBack: true));
                        }else{
                          Get.snackbar("Gagal", "Anda belum melakukan progress keberangkatan untuk hari ini", backgroundColor: GlobalVariable.secondaryColor, colorText: Colors.white);
                        }
                      }
                    },
                    child: Container(
                      width: orientation == Orientation.portrait ? size.width / 3 : size.width / 6,
                      height: orientation == Orientation.portrait ? size.width / 3 : size.width / 6,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 6)],
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.black12, width: 0.5)
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Obx(() => menuTimDistribusi[i]['icon']),
                          const SizedBox(height: 6),
                          Obx(() => Text(menuTimDistribusi[i]['name'], style: const TextStyle(color: GlobalVariable.secondaryColor)))
                        ],
                      )
                    ),
                  ),
                );
              }),
            ),
          ),
        ),
      ),
    );
  }
}