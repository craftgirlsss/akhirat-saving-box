import 'package:asb_app/src/components/global/index.dart';
import 'package:asb_app/src/controllers/tracking/tracking_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:latlong2/latlong.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  TrackingController trackingController = Get.find();

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 1), (){
      trackingController.getAllHistoryPengambilan();
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("History Pengambilan", style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
        leading: IconButton(
          onPressed: (){
            Navigator.pop(context);
          }, 
          icon: const Icon(Iconsax.arrow_left_2_bold, size: 30)
        ),
      ),
      body: Obx(() => trackingController.isLoading.value 
        ? SizedBox(
            width: size.width, 
            height: size.height / 1.2, 
            child: const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(color: GlobalVariable.secondaryColor),
                SizedBox(height: 10),
                Text("Getting data...")
              ],
            )
          )
        : Obx(() => trackingController.historyModels.value == null 
          ? SizedBox(
            width: size.width,
            height: size.height / 1.2,
            child: const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(CupertinoIcons.map_pin_ellipse),
                SizedBox(height: 10),
                Text("Tidak ada history")
              ],
            ),
          ) 
          : SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              children: List.generate(trackingController.historyModels.value?.data.length ?? 0, (i){
                return cardHistory(
                  size: size,
                  onPressed: (){},
                  description: trackingController.historyModels.value?.data[i].donatur?.nama,
                  title: trackingController.historyModels.value?.data[i].rute,
                  latitude: double.tryParse(trackingController.historyModels.value?.data[i].lat ?? '0'),
                  longitude: double.tryParse(trackingController.historyModels.value?.data[i].lng ?? '0')
                );
              }),
            ),
          ),
        ),
      ),
    );
  }
  
  Widget cardHistory({Size? size, double? latitude, double? longitude, String? title, String? description, Function()? onPressed}) {
    return CupertinoButton(
      onPressed: onPressed,
      padding: EdgeInsets.zero,
      child: Container(
        height: 80,
        clipBehavior: Clip.hardEdge,
        padding: const EdgeInsets.only(right: 10),
        margin: const EdgeInsets.only(top: 5, bottom: 5, left: 10, right: 10),
        decoration: BoxDecoration(
          color: const Color.fromRGBO(253, 246, 227, 1),
          borderRadius: BorderRadius.circular(13),
          border: Border.all(color: Colors.black12),
          boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 6)]
        ),
        child: Row(
          children: [
            //Container Map
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5)
              ),
              child: FlutterMap(
                options: MapOptions(
                  initialCenter: LatLng(latitude ?? 0.0, longitude ?? 0.0), //?? LatLng(widget.latitude, widget.longitude),
                  initialZoom: 15
                ),
                children: [
                  TileLayer(
                    urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                    userAgentPackageName: 'com.example.app',
                    maxNativeZoom: 19,
                    retinaMode: true,
                  ),
                  MarkerLayer(
                    markers: [
                      Marker(
                        rotate: true,
                        point: LatLng(latitude ?? 0.0, longitude ?? 0.0),
                        child: const Icon(Icons.place_rounded, color: Colors.red, size: 15)
                      ),
                    ]
                  ),
                ]
              ),
            ),
            const SizedBox(width: 10),
      
            //Tittle
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 3),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title ?? 'Unknown Name', style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold), maxLines: 2),
                    const SizedBox(height: 5),
                    Text(description ?? 'Unknown Description', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.normal, color: Colors.black45), maxLines: 2,),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}