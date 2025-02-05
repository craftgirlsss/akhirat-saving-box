import 'package:asb_app/src/controllers/utilities/location_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:latlong2/latlong.dart';

class CekMapTerakhir extends StatefulWidget {
  final double? latitude;
  final double? longitude;
  const CekMapTerakhir({super.key, this.latitude, this.longitude});

  @override
  State<CekMapTerakhir> createState() => _CekMapTerakhirState();
}

class _CekMapTerakhirState extends State<CekMapTerakhir> {

  MapController mapController = MapController();
  LocationController locationController = Get.find();
  RxString locationString = "".obs;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 1), (){
      locationController.getAddressFromCoordinates(latitude: widget.latitude, longitude: widget.longitude).then((result){
        locationString(result);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Cek Map Terakhir"),
        leading: IconButton(
          onPressed: (){
            Navigator.pop(context);
          }, 
          icon: const Icon(Iconsax.arrow_left_2_bold, size: 30,)
        ),
      ),
      body: SizedBox(
        width: size.width,
        height: size.height,
        child: Stack(
          children: [
            FlutterMap(
              mapController: mapController,
              options: MapOptions(
                initialCenter: LatLng(widget.latitude!, widget.longitude!), //?? LatLng(widget.latitude, widget.longitude),
                initialZoom: 12
              ),
              children: [
                TileLayer(
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  userAgentPackageName: 'com.example.app',
                  maxNativeZoom: 12,
                  retinaMode: true,
                ),
                 MarkerLayer(
                  markers: [
                    Marker(
                      rotate: true,
                      point: LatLng(widget.latitude!, widget.longitude!),
                      child: const Icon(Icons.place_rounded, color: Colors.red)
                    ),
                  ]
                ),
              ],
            ),
            Positioned(
              top: 5,
              left: 0,
              right: 0,
              child: Container(
                width: size.width / 1.1,
                margin: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.white,
                  border: Border.all(color: Colors.white30, width: 0.4),
                  boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 10, offset: Offset(2, 2))]
                ),
                child: Obx(() => Text(locationString.value, textAlign: TextAlign.center))
              )
            )
          ],
        ),
      ),
    );
  }
}