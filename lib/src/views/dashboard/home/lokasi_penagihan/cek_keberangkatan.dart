import 'dart:io';
import 'package:asb_app/src/components/global/index.dart';
import 'package:asb_app/src/controllers/tracking/tracking_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:image_picker/image_picker.dart';

class CekKeberangkatan extends StatefulWidget {
  const CekKeberangkatan({super.key});

  @override
  State<CekKeberangkatan> createState() => _CekKeberangkatanState();
}

class _CekKeberangkatanState extends State<CekKeberangkatan> {
  RxString urlPhotoHelm = ''.obs;
  RxString urlPhotoSepatu = ''.obs;
  RxString urlPhotoMotor = ''.obs;
  TextEditingController notesController = TextEditingController();
  ScrollController scrollController = ScrollController();
  TrackingController trackingController = Get.find();

  @override
  void initState() {
    super.initState();
  }


  @override
  void dispose() {
    notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Text("Cek Kelengkapan", style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
          actions: [
            CupertinoButton(
              onPressed: (){
                Get.defaultDialog(
                  title: "Informasi",
                  barrierDismissible: false,
                  middleText: "Sebelum melakukan keberangkatan, anda diwajibkan untuk melaporkan seluruh persiapan sesuai SOP yang telah ditentukan. Terimakasih",
                  backgroundColor: Colors.green,
                  titleStyle: const TextStyle(color: Colors.white),
                  middleTextStyle: const TextStyle(color: Colors.white),
                  buttonColor: Colors.white,
                  textConfirm: "Paham",
                  confirmTextColor: Colors.green,
                  onConfirm: (){
                    Navigator.pop(context);
                  }
                );
              },
              child: const Icon(CupertinoIcons.info, color: GlobalVariable.secondaryColor), 
            )
          ],
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 5),
          physics: const BouncingScrollPhysics(),
          child: Center(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text("Self Preparation", style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
                      CupertinoButton(
                        padding: EdgeInsets.zero,
                        onPressed: (){
                          Get.defaultDialog(
                            title: "Informasi",
                            barrierDismissible: false,
                            middleText: "Sebelum melakukan keberangkatan, anda diwajibkan untuk melaporkan seluruh persiapan sesuai SOP yang telah ditentukan. Terimakasih",
                            backgroundColor: Colors.green,
                            titleStyle: const TextStyle(color: Colors.white),
                            middleTextStyle: const TextStyle(color: Colors.white),
                            buttonColor: Colors.white,
                            textConfirm: "Paham",
                            confirmTextColor: Colors.green,
                            onConfirm: (){
                              Navigator.pop(context);
                            }
                          );
                        },
                        child: const Icon(CupertinoIcons.info_circle_fill, size: 15, color: Colors.black))
                    ],
                  ),
                ),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  physics: const ScrollPhysics(),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Obx(() => CupertinoButton(
                          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                          onPressed: trackingController.isLoading.value ? null : (){
                            pickImageFromCameraHelm();
                          },
                          child: boxAddingCamera(urlImage: urlPhotoHelm.value != "" ? urlPhotoHelm.value : null)
                        ),
                      ),
                      Obx(() => CupertinoButton(
                          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                          onPressed: trackingController.isLoading.value ? null : (){
                            pickImageFromCameraSepatu();
                          },
                          child: boxAddingCamera(name: "Sepatu dan Celana", urlImage: urlPhotoSepatu.value != "" ? urlPhotoSepatu.value : null)
                        ),
                      ),
                      Obx(() => CupertinoButton(
                          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                          onPressed: trackingController.isLoading.value ? null : (){
                            pickImageFromCameraMotor();
                          },
                          child: boxAddingCamera(name: "Motor dan Kaleng/Tas", urlImage: urlPhotoMotor.value != "" ? urlPhotoMotor.value : null)
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text("Catatan Khusus (Opsional)", style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
                      CupertinoButton(
                        padding: EdgeInsets.zero,
                        onPressed: (){
                          Get.defaultDialog(
                            title: "Informasi",
                            barrierDismissible: false,
                            middleText: "Anda dapat memberikan catatan kepada admin.",
                            backgroundColor: Colors.green,
                            titleStyle: const TextStyle(color: Colors.white),
                            middleTextStyle: const TextStyle(color: Colors.white),
                            buttonColor: Colors.white,
                            textConfirm: "Paham",
                            confirmTextColor: Colors.green,
                            onConfirm: (){
                              Navigator.pop(context);
                            }
                          );
                        },
                        child: const Icon(CupertinoIcons.info_circle_fill, size: 15, color: Colors.black))
                    ],
                  ),
                ),
      
                // TextField
                SizedBox(
                  height: size.width,
                  width: size.width,
                  child: Scrollbar(
                    controller: scrollController,
                    radius: const Radius.circular(5),
                    child: TextField(
                      controller: notesController,
                      cursorColor: Colors.black45,
                      minLines: 5,
                      maxLines: 5,
                      style: const TextStyle(color: Colors.black, fontSize: 12),
                      decoration: InputDecoration(
                        hintText: "Ketik pesan khusus disini...",
                        hintStyle: const TextStyle(color: Colors.black26, fontSize: 11),
                        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Colors.black12, width: 0.7)),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Colors.black12, width: 0.7)),
                        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Colors.black12, width: 0.7))
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(15),
          child: Obx(() => CupertinoButton(
              borderRadius: BorderRadius.circular(50),
              color: GlobalVariable.secondaryColor,
              onPressed: trackingController.isLoading.value ? null : (){
                if(urlPhotoHelm.value == "" || urlPhotoMotor.value == "" || urlPhotoSepatu.value == ""){

                }
              },
              child: const Text("Submit"), 
            ),
          ),
        ),
      ),
    );
  }

  Column boxAddingCamera({String? name, String? urlImage}){
    final size = MediaQuery.of(context).size;
    return Column(
      children: [
        Container(
          width: size.width / 2.6,
          height: size.width / 2.6,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.white,
            image: urlImage != null ? DecorationImage(image: FileImage(File(urlImage)), fit: BoxFit.cover) : null,
            boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 5)],
            border: Border.all(color: Colors.black12, width: 0.8)
          ),
          child: const Center(child: Padding(
            padding: EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(BoxIcons.bx_camera, color: Colors.black),
                SizedBox(height: 5),
                Text("Ambil Foto", style: TextStyle(fontSize: 11, color: Colors.black), textAlign: TextAlign.center)
              ],
            ),
          )),
        ),
        const SizedBox(height: 10),
        Text(name ?? "Helm dan Jaket", style: const TextStyle(fontSize: 13, color: Colors.black), textAlign: TextAlign.center),
      ],
    );
  }

  File? imageCameraHelm;
  pickImageFromCameraHelm() async {
    final ImagePicker picker = ImagePicker();
    final XFile? imagePicked = await picker.pickImage(source: ImageSource.camera, imageQuality: 50, preferredCameraDevice: CameraDevice.front, requestFullMetadata: true);
    if(imagePicked != null){
      setState(() {
        imageCameraHelm = File(imagePicked.path);
        urlPhotoHelm.value = imagePicked.path;
      });
    }else{
      debugPrint("Image kosong");
    }
  }

  File? imageCameraMotor;
  pickImageFromCameraMotor() async {
    final ImagePicker picker = ImagePicker();
    final XFile? imagePicked = await picker.pickImage(source: ImageSource.camera, imageQuality: 50, preferredCameraDevice: CameraDevice.front, requestFullMetadata: true);
    if(imagePicked != null){
      setState(() {
        imageCameraHelm = File(imagePicked.path);
        urlPhotoMotor.value = imagePicked.path;
      });
    }else{
      debugPrint("Image kosong");
    }
  }

  File? imageCameraSepatu;
  pickImageFromCameraSepatu() async {
    final ImagePicker picker = ImagePicker();
    final XFile? imagePicked = await picker.pickImage(source: ImageSource.camera, imageQuality: 50, preferredCameraDevice: CameraDevice.front, requestFullMetadata: true);
    if(imagePicked != null){
      setState(() {
        imageCameraHelm = File(imagePicked.path);
        urlPhotoSepatu.value = imagePicked.path;
      });
    }else{
      debugPrint("Image kosong");
    }
  }

}