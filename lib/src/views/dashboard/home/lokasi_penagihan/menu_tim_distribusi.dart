import 'package:asb_app/src/components/global/index.dart';
import 'package:asb_app/src/controllers/tracking/tracking_controller.dart';
import 'package:asb_app/src/views/dashboard/home/lokasi_penagihan/daftar_lokasi_tagihan_v3.dart';
import 'package:asb_app/src/views/dashboard/home/lokasi_penagihan/menu_hari_h.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:icons_plus/icons_plus.dart';

class MenuTimDistribusi extends StatefulWidget {
  const MenuTimDistribusi({super.key});

  @override
  State<MenuTimDistribusi> createState() => _MenuTimDistribusiState();
}

class _MenuTimDistribusiState extends State<MenuTimDistribusi> {
  TrackingController trackingController = Get.put(TrackingController());
  RxBool loading = false.obs;

  RxList menuTimDistribusi = 
    [
        {
          "name" : "Reminder",
          "icon" : const Icon(Clarity.alarm_clock_line, size: 30, color: GlobalVariable.secondaryColor), 
        },
        {
          "name" : "H",
          "icon" : const Icon(Clarity.calendar_outline_badged, size: 30, color: GlobalVariable.secondaryColor),
        },
    ].obs;

    @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 1), () => trackingController.checkingSelfFirst());
  }

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
        title: const Text("Daftar Aksi Tim Distribusi", style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Obx(() => Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(menuTimDistribusi.length, (i){
                return Obx(() => CupertinoButton(
                  onPressed: trackingController.isLoading.value ? null : (){
                    if(i == 0){
                      Get.to(() => const DaftarLokasiTagihanv3(isReminder: true,));
                    }else{
                      Get.to(() => const MenuHariH());
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
              );})),
            ),
          ],
        ),
      ),
    );
  }
}