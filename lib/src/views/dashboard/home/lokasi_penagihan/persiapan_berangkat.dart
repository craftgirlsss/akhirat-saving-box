import 'dart:io';
import 'package:asb_app/src/components/alert/alert_success.dart';
import 'package:asb_app/src/components/global/index.dart';
import 'package:asb_app/src/controllers/utilities/location_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class PersiapanBerangkat extends StatefulWidget {
  final String? urlImage;
  const PersiapanBerangkat({super.key, this.urlImage});

  @override
  State<PersiapanBerangkat> createState() => _PersiapanBerangkatState();
}

class _PersiapanBerangkatState extends State<PersiapanBerangkat> {
  LocationController locationController = Get.find();
  DateTime now = DateTime.now();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Upload Foto"),
        actions: [
          Obx(() => CupertinoButton(
            onPressed: locationController.isLoading.value ? null : (){
              locationController.wasSelfieAsFirst.value = true;
              alertSuccess(context,title: "Berhasil", content: "Berhasil unggah foto untuk memulai perjalanan pengambilan kotak", onOK: (){
                Navigator.pop(context);
              });
            },
            child: const Text("Submit", style: TextStyle(color: GlobalVariable.secondaryColor))
            ),
          )
        ],
      ),
      body: Stack(
        children: [
          widget.urlImage != null ? Image.file(File(widget.urlImage!), fit: BoxFit.contain) : Container(color: Colors.black, width: size.width, height: size.height),
          Positioned(
            left: 0,
            right: 0,
            top: 0,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Location : ${locationController.myLocation.value}", style: const TextStyle(color: Colors.white, shadows: [BoxShadow(color: Colors.black, blurRadius: 4)])),
                  Text("Latitude : ${locationController.myLatitude.value}", style: const TextStyle(color: Colors.white, shadows: [BoxShadow(color: Colors.black, blurRadius: 4)])),
                  Text("Longitude : ${locationController.myLongitude.value}", style: const TextStyle(color: Colors.white, shadows: [BoxShadow(color: Colors.black, blurRadius: 4)])),
                  Text("Waktu : ${DateFormat('dd MMMM yyyy').add_jms().format(now)}", style: const TextStyle(color: Colors.white, shadows: [BoxShadow(color: Colors.black, blurRadius: 4)])),
                ],
              ),
            )
          )
        ],
      ),
    );
  }
}