import 'dart:io';
import 'package:asb_app/src/components/dropdown/default_dropdown.dart';
import 'package:asb_app/src/components/global/index.dart';
import 'package:asb_app/src/controllers/tracking/tracking_controller.dart';
import 'package:asb_app/src/controllers/utilities/location_controller.dart';
import 'package:asb_app/src/views/dashboard/home/lokasi_penagihan/data_cell.dart';
import 'package:asb_app/src/views/dashboard/home/lokasi_penagihan/detail_lokasi.dart';
import 'package:asb_app/src/views/dashboard/home/lokasi_penagihan/persiapan_berangkat.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

List<String> list2 = <String>['Semua', 'Rapel'];

class DaftarLokasiTagihanv2 extends StatefulWidget {
  const DaftarLokasiTagihanv2({super.key, this.restorationId});
  final String? restorationId;

  @override
  State<DaftarLokasiTagihanv2> createState() => _DaftarLokasiTagihanv2State();
}

class _DaftarLokasiTagihanv2State extends State<DaftarLokasiTagihanv2> {
  LocationController locationController = Get.put(LocationController());
  TrackingController trackingController = Get.put(TrackingController());
  TextEditingController tanggalController = TextEditingController();
  DateTime now = DateTime.now();
  int indexSelected = -1;
  RxString ruteID = ''.obs;
  RxBool enableSelection = false.obs;
  RxBool showDataTable = false.obs;
  RxString dropdownRute = "".obs;
  RxString dropdownTipe = "Semua".obs;
  RxList<String> listRute = ['Pilihan'].obs;

  String dateFormatted({DateTime? time}){
    return DateFormat('dd MMM yyyy').format(time ?? now);
  }

  String dateFormattedYearAndMonth({DateTime? time}){
    return DateFormat('yyyy MMM').format(time ?? now);
  }

  String dateFormatTime({DateTime? time}){
    return DateFormat().add_jm().format(time ?? now);
  }


  void _showDialog(Widget child) {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => Container(
        height: 216,
        padding: const EdgeInsets.only(top: 6.0),
        margin: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        color: CupertinoColors.systemBackground.resolveFrom(context),
        child: SafeArea(
          top: false,
          child: child,
        ),
      ),
    );
  }


  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 1), (){
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight]
      );
      trackingController.getRute().then((value){
        if(value){
          if(trackingController.ruteModels.value?.data != null){
            listRute.value = [];
            for(int i = 0; i < trackingController.ruteModels.value!.data.length; i++){
              listRute.add(trackingController.ruteModels.value!.data[i].name!);
            }
            tanggalController.text = dateFormattedYearAndMonth(time: now);
            ruteID(trackingController.ruteModels.value!.data[0].id);
            dropdownRute(trackingController.ruteModels.value!.data[0].name);
            dropdownTipe(list2[0]);
            enableSelection(true);
          }else{
            enableSelection(false);
            Get.snackbar("Gagal", "Data rute kosong", backgroundColor: Colors.red, colorText: Colors.white);
          }
        }
      });
      // trackingController.getListTempatPengambilan();
      // trackingController.checkingSelfFirst().then((value){
      //   trackingController.wasSelfieAsFirst.value = value;
      //   if(trackingController.tempatPengambilanModels.value?.data != null){
      //     list1 = [];
      //     for(int i = 0; i < trackingController.tempatPengambilanModels.value!.data!.length; i++){
      //       list1.add(trackingController.tempatPengambilanModels.value!.data![i].name!);
      //     }
      //   }
      // });
    });
  }

  @override
  void dispose() {
    tanggalController.dispose();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown
    ]);
    super.dispose();
  }

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
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: ElevatedButton(
              onPressed: (){
                Get.to(() => const DetailLokasi());
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: GlobalVariable.secondaryColor,
                elevation: 0
              ),
              child: const Text("Lanjut", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),)
            ),
          )
          // Obx(() => CupertinoButton(onPressed: trackingController.wasSelfieAsFirst.value ? null : (){
          //   // pickImageFromCamera();
          //   Get.to(() => const CekKeberangkatan());
          // }, child: Icon(CupertinoIcons.photo_camera_solid, color: trackingController.wasSelfieAsFirst.value ? Colors.grey : GlobalVariable.secondaryColor)))
        ],
      ),
      body: RefreshIndicator(
        backgroundColor: GlobalVariable.secondaryColor,
        color: Colors.white,
        onRefresh: () async {
          await trackingController.getRute().then((value){
            if(value){
              if(trackingController.ruteModels.value?.data != null){
                listRute.value = [];
                for(int i = 0; i < trackingController.ruteModels.value!.data.length; i++){
                  listRute.add(trackingController.ruteModels.value!.data[i].name!);
                }
                enableSelection(true);
              }else{
                enableSelection(false);
                Get.snackbar("Gagal", "Data rute kosong", backgroundColor: Colors.red, colorText: Colors.white);
              }
            }
          });
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("Rute"),
                        Obx(() => trackingController.isLoading.value 
                          ? const Text("Getting data...") 
                          : Obx(() => dropdownRute.value != "" ? DefaultDropdownButton(
                              dropdown: dropdownRute.value,
                              listContentDropDown: listRute,
                              onChanged: (value) {
                                dropdownRute.value = value!;
                                trackingController.getListDonatur(date: tanggalController.text, ruteID: ruteID.value).then((result){
                                  if(result){
                                    showDataTable(true);
                                  }else{
                                    showDataTable(false);
                                  }
                                });
                              },
                            ) : Container(),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("Tanggal"),
                        Obx(() => enableSelection.value ? SizedBox(
                          height: 33,
                          child: TextField(
                            enabled: true,
                            readOnly: true,
                            onTap: enableSelection.value ? (){
                              _showDialog(
                                CupertinoDatePicker(
                                  mode: CupertinoDatePickerMode.monthYear,
                                  initialDateTime: now,
                                  onDateTimeChanged: (value) {
                                    setState(() {
                                      tanggalController.text = dateFormattedYearAndMonth(time: value);                                
                                    });
                                    trackingController.getListDonatur(date: tanggalController.text, ruteID: ruteID.value).then((result){
                                      if(result){
                                        showDataTable(true);
                                      }else{
                                        showDataTable(false);
                                      }
                                    });
                                  },
                                  maximumYear: now.year,
                                  minimumYear: now.year - 10,
                                )
                              );
                            } : (){
                              Get.snackbar("Gagal", "Mohon pilih rute terlebih dahulu", backgroundColor: Colors.red, colorText: Colors.white);
                            },
                            controller: tanggalController,
                            style: const TextStyle(color: GlobalVariable.secondaryColor, fontSize: 13, fontWeight: FontWeight.bold),
                            decoration: InputDecoration(
                              hintText: "Pilih tanggal",
                              hintStyle: TextStyle(color: GlobalVariable.secondaryColor.withOpacity(0.5), fontSize: 13),
                              suffixIconConstraints: const BoxConstraints(
                                maxHeight:double.infinity
                              ),
                              contentPadding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                              suffixIcon: const Icon(Icons.keyboard_arrow_down_rounded, color: GlobalVariable.secondaryColor),
                              disabledBorder: const UnderlineInputBorder(borderSide: BorderSide(color: GlobalVariable.secondaryColor, width: 2)),
                              border: const UnderlineInputBorder(borderSide: BorderSide(color: GlobalVariable.secondaryColor, width: 2)),
                              enabledBorder: const UnderlineInputBorder(borderSide: BorderSide(color: GlobalVariable.secondaryColor, width: 2)),
                              focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: GlobalVariable.secondaryColor, width: 2))
                            ),
                          ),
                        ) : Container(),
                        )
                        // DefaultDropdownButton(
                        //   listContentDropDown: list2,
                        // ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("Tipe"),
                        Obx(() => enableSelection.value
                          ? Obx(() => dropdownTipe.value != "" ? DefaultDropdownButton(
                              listContentDropDown: list2,
                              dropdown: dropdownTipe.value,
                              onChanged: (value) {
                                dropdownTipe(value);
                                trackingController.getListDonatur(date: tanggalController.text, ruteID: ruteID.value).then((result){
                                  if(result){
                                    showDataTable(true);
                                  }else{
                                    showDataTable(false);
                                  }
                                });
                              },
                            ) : Container(),
                          )
                          : Container(),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 20),
                  const Spacer()
                ],
              ),
        
              const SizedBox(height: 20),

              Obx(() {
                if(showDataTable.value){
                  return Column(
                    children: [
                      const Text("Daftar Jadwal", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),),
                      const SizedBox(height: 10),
                      DataTable(
                        columnSpacing: 10,
                        headingRowColor: const WidgetStatePropertyAll(GlobalVariable.secondaryColor),
                        border: const TableBorder(
                          left: BorderSide(color: Colors.black26),
                          right: BorderSide(color: Colors.black26),
                          bottom: BorderSide(color: Colors.black26),
                          top: BorderSide(color: Colors.black26),
                        ),
                        columns: const <DataColumn>[
                          DataColumn(
                            label: Expanded(
                              child: Text(
                                'Kode',
                                style: TextStyle(fontStyle: FontStyle.italic, fontWeight: FontWeight.bold, color: Colors.white),
                              ),
                            ),
                          ),
                          DataColumn(
                            label: Expanded(
                              child: Text(
                                'Name',
                                style: TextStyle(fontStyle: FontStyle.italic, fontWeight: FontWeight.bold, color: Colors.white),
                              ),
                            ),
                          ),
                          DataColumn(
                            label: Expanded(
                              child: Text(
                                'Alamat',
                                style: TextStyle(fontStyle: FontStyle.italic, fontWeight: FontWeight.bold, color: Colors.white),
                              ),
                            ),
                          ),
                          DataColumn(
                            label: Expanded(
                              child: Text(
                                'Nomor HP',
                                style: TextStyle(fontStyle: FontStyle.italic, fontWeight: FontWeight.bold, color: Colors.white),
                              ),
                            ),
                          ),
                          DataColumn(
                            label: Expanded(
                              child: Text(
                                'Jam',
                                style: TextStyle(fontStyle: FontStyle.italic, fontWeight: FontWeight.bold, color: Colors.white),
                              ),
                            ),
                          ),
                          DataColumn(
                            label: Expanded(
                              child: Text(
                                'Tanggal',
                                style: TextStyle(fontStyle: FontStyle.italic, fontWeight: FontWeight.bold, color: Colors.white),
                              ),
                            ),
                          ),
                          DataColumn(
                            label: Expanded(
                              child: Text(
                                'H',
                                style: TextStyle(fontStyle: FontStyle.italic, fontWeight: FontWeight.bold, color: Colors.white),
                              ),
                            ),
                          ),
                          DataColumn(
                            label: Expanded(
                              child: Text(
                                'H-1',
                                style: TextStyle(fontStyle: FontStyle.italic, fontWeight: FontWeight.bold, color: Colors.white),
                              ),
                            ),
                          ),
                          DataColumn(
                            label: Expanded(
                              child: Text(
                                'H-2',
                                style: TextStyle(fontStyle: FontStyle.italic, fontWeight: FontWeight.bold, color: Colors.white),
                              ),
                            ),
                          ),
                          DataColumn(
                            label: Expanded(
                              child: Text(
                                'Rapel',
                                style: TextStyle(fontStyle: FontStyle.italic, fontWeight: FontWeight.bold, color: Colors.white),
                              ),
                            ),
                          ),
                          DataColumn(
                            label: Expanded(
                              child: Text(
                                'Jadwal Rapel',
                                style: TextStyle(fontStyle: FontStyle.italic, fontWeight: FontWeight.bold, color: Colors.white),
                              ),
                            ),
                          ),
                          DataColumn(
                            label: Expanded(
                              child: Text(
                                'Status Pengambilan',
                                style: TextStyle(fontStyle: FontStyle.italic, fontWeight: FontWeight.bold, color: Colors.white),
                              ),
                            ),
                          ),
                        ],
                        rows: List.generate(trackingController.daftarDonatur.value?.data.length ?? 0, (i){
                          return DataRow(
                            cells: <DataCell>[
                              // Kode
                              DataCell(Text(trackingController.daftarDonatur.value?.data[i].id ?? i.toString())),
                              // Name
                              DataCell(Text(trackingController.daftarDonatur.value?.data[i].name ?? i.toString())),
                              // Alamat
                              DataCell(Text(trackingController.daftarDonatur.value?.data[i].alamat ?? i.toString())),
                              // Phone
                              DataCell(Text(trackingController.daftarDonatur.value?.data[i].noHp ?? i.toString())),
                              //Jam
                              DataCell(Text(trackingController.daftarDonatur.value?.data[i].jam ?? i.toString())),
                              // Tanggal
                              DataCell(Obx(() => GestureDetector(
                                onTap: trackingController.isLoading.value ? null : (){
                                  _showDialog(
                                    CupertinoDatePicker(
                                      mode: CupertinoDatePickerMode.date,
                                      initialDateTime: now,
                                      onDateTimeChanged: (value) {
                                        setState(() {
                                          trackingController.daftarDonatur.value?.data[i].tanggal = dateFormatted(time: value);
                                        });
                                      },
                                      maximumYear: now.year,
                                      minimumYear: now.year - 10,
                                    )
                                  );
                                },
                                child: Text(trackingController.daftarDonatur.value?.data[i].tanggal ?? '00:00:0000')),
                              )),
                              // H
                              DataCell(
                                CupertinoButton(
                                  padding: EdgeInsets.zero,
                                  onPressed: (){},
                                  child: Icon(trackingController.daftarDonatur.value?.data[i].h == true ? Icons.notifications_active : Icons.notifications_active_outlined, color: GlobalVariable.secondaryColor)
                                )
                              ),
                              // H-1
                              DataCell(
                                CupertinoButton(
                                  padding: EdgeInsets.zero,
                                  onPressed: (){},
                                  child: Icon(trackingController.daftarDonatur.value?.data[i].h1 == true ? Icons.notifications_active : Icons.notifications_active_outlined, color: GlobalVariable.secondaryColor)
                                )
                              ),
                              // H-2
                              DataCell(
                                CupertinoButton(
                                  padding: EdgeInsets.zero,
                                  onPressed: (){},
                                  child: Icon(trackingController.daftarDonatur.value?.data[i].h2 == true ? Icons.notifications_active : Icons.notifications_active_outlined, color: GlobalVariable.secondaryColor)
                                )
                              ),
                              // Rapel
                              DataCell(
                                CupertinoButton(
                                  padding: EdgeInsets.zero,
                                  onPressed: (){},
                                  child: Icon(trackingController.daftarDonatur.value?.data[i].rapel == true ? Icons.notifications_active : Icons.notifications_active_outlined, color: GlobalVariable.secondaryColor)
                                )
                              ),
                              DataCell(
                                CupertinoButton(
                                  padding: EdgeInsets.zero,
                                  onPressed: (){},
                                  child: Icon(trackingController.daftarDonatur.value?.data[i].jadwalRapel == true ? Icons.notifications_active : Icons.notifications_active_outlined, color: GlobalVariable.secondaryColor)
                                )
                              ),
                              DataCell(
                                CupertinoButton(
                                  padding: EdgeInsets.zero,
                                  onPressed: (){},
                                  child: Icon(trackingController.daftarDonatur.value?.data[i].statusPengambilan == true ? Icons.notifications_active : Icons.notifications_active_outlined, color: GlobalVariable.secondaryColor)
                                )
                              )
                            ],
                          );
                        }
                        )
                      )
                    ],
                  );
                }
                return Container();
              })
            ],
          ),
        ),
      )
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