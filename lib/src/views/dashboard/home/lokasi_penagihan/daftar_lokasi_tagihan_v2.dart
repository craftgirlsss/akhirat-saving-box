import 'dart:io';
import 'package:asb_app/src/components/dropdown/default_dropdown.dart';
import 'package:asb_app/src/components/global/index.dart';
import 'package:asb_app/src/controllers/tracking/tracking_controller.dart';
import 'package:asb_app/src/controllers/utilities/location_controller.dart';
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
  RxDouble latitudeRute = 0.0.obs;
  RxDouble longitudeRute = 0.0.obs;
  RxList<String> listRute = ['Pilihan'].obs;

  String dateFormatted({DateTime? time}){
    return DateFormat('dd MMM yyyy').format(time ?? now);
  }

  String dateFormattedYearAndMonth({DateTime? time}){
    return DateFormat('yyyy MMMM').format(time ?? now);
  }

  String dateFormatTime({DateTime? time}){
    return DateFormat('hh:mm:ss').format(time ?? now);
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
            latitudeRute(double.parse(trackingController.ruteModels.value!.data[0].lat!));
            longitudeRute(double.parse(trackingController.ruteModels.value!.data[0].lng!));
            trackingController.getListDonatur(date: tanggalController.text, ruteID: ruteID.value, type: "semua").then((result){
              if(result){
                showDataTable(true);
              }else{
                showDataTable(false);
              }
            });
            enableSelection(true);
          }else{
            enableSelection(false);
            Get.snackbar("Gagal", "Data rute kosong", backgroundColor: Colors.red, colorText: Colors.white);
          }
        }
      });
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
                trackingController.getListDonatur(date: tanggalController.text, ruteID: ruteID.value, type: dropdownTipe.value).then((result){
                  if(result){
                    showDataTable(true);
                  }else{
                    showDataTable(false);
                  }
                });
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
                                for(int i = 0; i < trackingController.ruteModels.value!.data.length; i++){
                                  if(trackingController.ruteModels.value!.data[i].name == value){
                                    ruteID(trackingController.ruteModels.value!.data[i].id);
                                    latitudeRute(double.parse(trackingController.ruteModels.value!.data[i].lat!));
                                    longitudeRute(double.parse(trackingController.ruteModels.value!.data[i].lng!));
                                  }
                                }
                                trackingController.getListDonatur(date: tanggalController.text, ruteID: ruteID.value, type: dropdownTipe.value.toLowerCase()).then((result){
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
                                    trackingController.getListDonatur(date: tanggalController.text, ruteID: ruteID.value, type: dropdownTipe.value.toLowerCase()).then((result){
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
                                trackingController.getListDonatur(date: tanggalController.text, ruteID: ruteID.value, type: dropdownTipe.value.toLowerCase()).then((result){
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
                                style: TextStyle(fontStyle: FontStyle.italic, fontWeight: FontWeight.bold, color: Colors.white, fontSize: 11),
                              ),
                            ),
                          ),
                          DataColumn(
                            label: Expanded(
                              child: Text(
                                'Name',
                                style: TextStyle(fontStyle: FontStyle.italic, fontWeight: FontWeight.bold, color: Colors.white, fontSize: 11),
                              ),
                            ),
                          ),
                          DataColumn(
                            label: Expanded(
                              child: Text(
                                'Alamat',
                                style: TextStyle(fontStyle: FontStyle.italic, fontWeight: FontWeight.bold, color: Colors.white, fontSize: 11),
                              ),
                            ),
                          ),
                          DataColumn(
                            label: Expanded(
                              child: Text(
                                'Nomor HP',
                                style: TextStyle(fontStyle: FontStyle.italic, fontWeight: FontWeight.bold, color: Colors.white, fontSize: 11),
                              ),
                            ),
                          ),
                          DataColumn(
                            label: Expanded(
                              child: Text(
                                'Jam',
                                style: TextStyle(fontStyle: FontStyle.italic, fontWeight: FontWeight.bold, color: Colors.white, fontSize: 11),
                              ),
                            ),
                          ),
                          DataColumn(
                            label: Expanded(
                              child: Text(
                                'Tanggal',
                                style: TextStyle(fontStyle: FontStyle.italic, fontWeight: FontWeight.bold, color: Colors.white, fontSize: 11),
                              ),
                            ),
                          ),
                          DataColumn(
                            label: Expanded(
                              child: Text(
                                'H',
                                style: TextStyle(fontStyle: FontStyle.italic, fontWeight: FontWeight.bold, color: Colors.white, fontSize: 11),
                              ),
                            ),
                          ),
                          DataColumn(
                            label: Expanded(
                              child: Text(
                                'H-1',
                                style: TextStyle(fontStyle: FontStyle.italic, fontWeight: FontWeight.bold, color: Colors.white, fontSize: 11),
                              ),
                            ),
                          ),
                          DataColumn(
                            label: Expanded(
                              child: Text(
                                'H-2',
                                style: TextStyle(fontStyle: FontStyle.italic, fontWeight: FontWeight.bold, color: Colors.white, fontSize: 11),
                              ),
                            ),
                          ),
                          DataColumn(
                            label: Expanded(
                              child: Text(
                                'Rapel',
                                style: TextStyle(fontStyle: FontStyle.italic, fontWeight: FontWeight.bold, color: Colors.white, fontSize: 11),
                              ),
                            ),
                          ),
                          DataColumn(
                            label: Expanded(
                              child: Text(
                                'Jadwal Rapel',
                                style: TextStyle(fontStyle: FontStyle.italic, fontWeight: FontWeight.bold, color: Colors.white, fontSize: 11),
                              ),
                            ),
                          ),
                          DataColumn(
                            label: Expanded(
                              child: Text(
                                'Status Pengambilan',
                                style: TextStyle(fontStyle: FontStyle.italic, fontWeight: FontWeight.bold, color: Colors.white, fontSize: 11),
                              ),
                            ),
                          ),
                          DataColumn(
                            label: Expanded(
                              child: Text(
                                'Lihat Halaman',
                                style: TextStyle(fontStyle: FontStyle.italic, fontWeight: FontWeight.bold, color: Colors.white, fontSize: 11),
                              ),
                            ),
                          ),
                        ],
                        rows: List.generate(trackingController.daftarDonatur.value?.data.length ?? 0, (i){
                          return DataRow(
                            color: WidgetStatePropertyAll(trackingController.daftarDonatur.value?.data[i].status == "5" ?  Colors.yellow : Colors.white),
                            cells: <DataCell>[
                              // Kode
                              DataCell(Text(trackingController.daftarDonatur.value?.data[i].id ?? i.toString(), style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),)),
                              // Name
                              DataCell(Text(trackingController.daftarDonatur.value?.data[i].name ?? i.toString(), style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),)),
                              // Alamat
                              DataCell(Text(trackingController.daftarDonatur.value?.data[i].alamat ?? i.toString(), style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),)),
                              // Phone
                              DataCell(Text(trackingController.daftarDonatur.value?.data[i].noHp ?? i.toString(), style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),)),
                              //Jam
                              DataCell(Obx(() => GestureDetector(
                                onTap: trackingController.isLoading.value ? null : () async {
                                  _showDialog(
                                    CupertinoDatePicker(
                                      mode: CupertinoDatePickerMode.time,
                                      use24hFormat: true,
                                      initialDateTime: now,
                                      onDateTimeChanged: (value) {
                                        setState(() {
                                          trackingController.daftarDonatur.value?.data[i].jam = dateFormatTime(time: value);
                                        });
                                      },
                                      maximumYear: now.year,
                                      minimumYear: now.year - 10,
                                    )
                                  );
                                  await trackingController.ubahTanggalRapel(
                                    jadwalID: trackingController.daftarDonatur.value?.data[i].jadwal,
                                    jam: trackingController.daftarDonatur.value?.data[i].jam,
                                    tanggal: trackingController.daftarDonatur.value?.data[i].tanggal,
                                  ).then((value){
                                    trackingController.getListDonatur(date: tanggalController.text, ruteID: ruteID.value, type: dropdownTipe.value.toLowerCase()).then((result){
                                      if(result){
                                        showDataTable(true);
                                      }else{
                                        showDataTable(false);
                                      }
                                    });
                                  });
                                },
                                child: Text(trackingController.daftarDonatur.value?.data[i].jam ?? i.toString(), style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),)))),
                              // Tanggal
                              DataCell(Obx(() => GestureDetector(
                                onTap: trackingController.isLoading.value ? null : () async {
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
                                  await trackingController.ubahTanggalRapel(
                                    jadwalID: trackingController.daftarDonatur.value?.data[i].jadwal,
                                    jam: trackingController.daftarDonatur.value?.data[i].jam,
                                    tanggal: trackingController.daftarDonatur.value?.data[i].tanggal,
                                  ).then((value){
                                    trackingController.getListDonatur(date: tanggalController.text, ruteID: ruteID.value, type: dropdownTipe.value.toLowerCase()).then((result){
                                      if(result){
                                        showDataTable(true);
                                      }else{
                                        showDataTable(false);
                                      }
                                    });
                                  });
                                },
                                child: Text(trackingController.daftarDonatur.value?.data[i].tanggal ?? '00:00:0000', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold))
                                ),
                              )),
                              // H
                              DataCell(
                                Obx(() => CupertinoButton(
                                    padding: EdgeInsets.zero,
                                    onPressed: trackingController.daftarDonatur.value?.data[i].h == true ? (){
                                      Get.snackbar("Gagal", "Anda sudah mengirim notifikasi H sebelumnya pada donatur", backgroundColor: Colors.red, colorText: Colors.white);
                                    } : () {
                                      showAlertDialog(context, content: "Apakah anda yakin mengirim notifikasi status H ke donatur ${trackingController.daftarDonatur.value?.data[i].name}?", title: "Kirim Notifikasi", onOK: () async {
                                        Navigator.pop(context);
                                        await trackingController.postNotification(donaturID: trackingController.daftarDonatur.value?.data[i].id, jadwaID: trackingController.daftarDonatur.value?.data[i].jadwal, type: 'h').then((value){
                                          if(value){
                                            Get.snackbar("Berhasil", "Berhasil mengirim notifikasi ke telegram ${trackingController.daftarDonatur.value?.data[i].name}", backgroundColor: Colors.green, colorText: Colors.white);
                                            trackingController.getListDonatur(date: tanggalController.text, ruteID: ruteID.value, type: dropdownTipe.value.toLowerCase()).then((result){
                                              if(result){
                                                showDataTable(true);
                                              }else{
                                                showDataTable(false);
                                              }
                                            });
                                          }else{
                                            Get.snackbar("Gagal", "${trackingController.responseMessage.value} ${trackingController.daftarDonatur.value?.data[i].name}", backgroundColor: Colors.red, colorText: Colors.white);
                                          }
                                        });
                                      });
                                    },
                                    child: Icon(trackingController.daftarDonatur.value?.data[i].h == true ? Icons.notifications_active : Icons.notifications_active_outlined, color: GlobalVariable.secondaryColor, size: 19)
                                  ),
                                )
                              ),
                              // H-1
                              DataCell(
                                Obx(() => CupertinoButton(
                                    padding: EdgeInsets.zero,
                                    onPressed: trackingController.daftarDonatur.value?.data[i].h1 == true ? (){
                                      Get.snackbar("Gagal", "Anda sudah mengirim notifikasi H-1 sebelumnya pada donatur", backgroundColor: Colors.red, colorText: Colors.white);
                                    } : (){
                                      showAlertDialog(context, content: "Apakah anda yakin mengirim notifikasi status H-1 ke donatur ${trackingController.daftarDonatur.value?.data[i].name}?", title: "Kirim Notifikasi", onOK: () async {
                                        Navigator.pop(context);
                                        await trackingController.postNotification(donaturID: trackingController.daftarDonatur.value?.data[i].id, jadwaID: trackingController.daftarDonatur.value?.data[i].jadwal, type: 'h1').then((value){
                                          if(value){
                                            Get.snackbar("Berhasil", "Berhasil mengirim notifikasi ke telegram ${trackingController.daftarDonatur.value?.data[i].name}", backgroundColor: Colors.green, colorText: Colors.white);
                                            trackingController.getListDonatur(date: tanggalController.text, ruteID: ruteID.value, type: dropdownTipe.value.toLowerCase()).then((result){
                                              if(result){
                                                showDataTable(true);
                                              }else{
                                                showDataTable(false);
                                              }
                                            });
                                          }else{
                                            Get.snackbar("Gagal", "Gagal mengirim notifikasi ke telegram ${trackingController.daftarDonatur.value?.data[i].name}", backgroundColor: Colors.red, colorText: Colors.white);
                                          }
                                        });
                                      });
                                    },
                                    child: Icon(trackingController.daftarDonatur.value?.data[i].h1 == true ? Icons.notifications_active : Icons.notifications_active_outlined, color: GlobalVariable.secondaryColor, size: 19)
                                  ),
                                )
                              ),
                              // H-2
                              DataCell(
                                Obx(() => CupertinoButton(
                                    padding: EdgeInsets.zero,
                                    onPressed: trackingController.daftarDonatur.value?.data[i].h2 == true ? (){
                                      Get.snackbar("Gagal", "Anda sudah mengirim notifikasi H-2 sebelumnya pada donatur", backgroundColor: Colors.red, colorText: Colors.white);
                                      } : (){
                                      showAlertDialog(context, content: "Apakah anda yakin mengirim notifikasi status H-2 ke donatur ${trackingController.daftarDonatur.value?.data[i].name}?", title: "Kirim Notifikasi", onOK: () async {
                                        Navigator.pop(context);
                                        await trackingController.postNotification(donaturID: trackingController.daftarDonatur.value?.data[i].id, jadwaID: trackingController.daftarDonatur.value?.data[i].jadwal, type: 'h2').then((value){
                                          if(value){
                                            Get.snackbar("Berhasil", "Berhasil mengirim notifikasi ke telegram ${trackingController.daftarDonatur.value?.data[i].name}", backgroundColor: Colors.green, colorText: Colors.white);
                                            trackingController.getListDonatur(date: tanggalController.text, ruteID: ruteID.value, type: dropdownTipe.value.toLowerCase()).then((result){
                                              if(result){
                                                showDataTable(true);
                                              }else{
                                                showDataTable(false);
                                              }
                                            });
                                          }else{
                                            Get.snackbar("Gagal", "Gagal mengirim notifikasi ke telegram ${trackingController.daftarDonatur.value?.data[i].name}", backgroundColor: Colors.red, colorText: Colors.white);
                                          }
                                        });
                                      });
                                    },
                                    child: Icon(trackingController.daftarDonatur.value?.data[i].h2 == true ? Icons.notifications_active : Icons.notifications_active_outlined, color: GlobalVariable.secondaryColor, size: 19)
                                  ),
                                )
                              ),
                              // Rapel
                              DataCell(
                                Obx(() => CupertinoButton(
                                    padding: EdgeInsets.zero,
                                    onPressed: trackingController.daftarDonatur.value?.data[i].rapel == true ? (){
                                        Get.snackbar("Gagal", "Anda sudah mengirim notifikasi Rapel sebelumnya pada donatur", backgroundColor: Colors.red, colorText: Colors.white);
                                      } : (){
                                      showAlertDialog(context, content: "Apakah anda yakin mengirim notifikasi status Rapel ke donatur ${trackingController.daftarDonatur.value?.data[i].name}?", title: "Kirim Notifikasi", onOK: () async {
                                        Navigator.pop(context);
                                        await trackingController.postNotification(donaturID: trackingController.daftarDonatur.value?.data[i].id, jadwaID: trackingController.daftarDonatur.value?.data[i].jadwal, type: 'rapel').then((value){
                                          if(value){
                                            Get.snackbar("Berhasil", "Berhasil mengirim notifikasi ke telegram ${trackingController.daftarDonatur.value?.data[i].name}", backgroundColor: Colors.green, colorText: Colors.white);
                                            trackingController.getListDonatur(date: tanggalController.text, ruteID: ruteID.value, type: dropdownTipe.value.toLowerCase()).then((result){
                                              if(result){
                                                showDataTable(true);
                                              }else{
                                                showDataTable(false);
                                              }
                                            });
                                          }else{
                                            Get.snackbar("Gagal", "Gagal mengirim notifikasi ke telegram ${trackingController.daftarDonatur.value?.data[i].name}", backgroundColor: Colors.red, colorText: Colors.white);
                                          }
                                        });
                                      });
                                    },
                                    child: Icon(trackingController.daftarDonatur.value?.data[i].rapel == true ? Icons.notifications_active : Icons.notifications_active_outlined, color: GlobalVariable.secondaryColor, size: 19)
                                  ),
                                )
                              ),
                              DataCell(
                                Obx(() => CupertinoButton(
                                    padding: EdgeInsets.zero,
                                    onPressed: trackingController.daftarDonatur.value?.data[i].jadwalRapel == true ? (){
                                        Get.snackbar("Gagal", "Anda sudah mengirim notifikasi Jadwal Rapel sebelumnya pada donatur", backgroundColor: Colors.red, colorText: Colors.white);
                                      } : (){
                                      showAlertDialog(context, content: "Apakah anda yakin mengirim notifikasi status Konfirmasi Rapel ke donatur ${trackingController.daftarDonatur.value?.data[i].name}?", title: "Kirim Notifikasi", onOK: () async {
                                        Navigator.pop(context);
                                        await trackingController.postNotification(donaturID: trackingController.daftarDonatur.value?.data[i].id, jadwaID: trackingController.daftarDonatur.value?.data[i].jadwal, type: 'konfirmasi-rapel').then((value){
                                          if(value){
                                            Get.snackbar("Berhasil", "Berhasil mengirim notifikasi ke telegram ${trackingController.daftarDonatur.value?.data[i].name}", backgroundColor: Colors.green, colorText: Colors.white);
                                            trackingController.getListDonatur(date: tanggalController.text, ruteID: ruteID.value, type: dropdownTipe.value.toLowerCase()).then((result){
                                              if(result){
                                                showDataTable(true);
                                              }else{
                                                showDataTable(false);
                                              }
                                            });
                                          }else{
                                            Get.snackbar("Gagal", "Gagal mengirim notifikasi ke telegram ${trackingController.daftarDonatur.value?.data[i].name}", backgroundColor: Colors.red, colorText: Colors.white);
                                          }
                                        });
                                      });
                                    },
                                    child: Icon(trackingController.daftarDonatur.value?.data[i].jadwalRapel == true ? Icons.notifications_active : Icons.notifications_active_outlined, color: GlobalVariable.secondaryColor, size: 19)
                                  ),
                                )
                              ),
                              DataCell(
                                Obx(() => CupertinoButton(
                                    padding: EdgeInsets.zero,
                                    onPressed: trackingController.daftarDonatur.value?.data[i].statusPengambilan == true ? (){
                                        Get.snackbar("Gagal", "Anda sudah mengirim notifikasi Status Pengambilan sebelumnya pada donatur", backgroundColor: Colors.red, colorText: Colors.white);
                                      } : (){
                                      showAlertDialog(context, content: "Apakah anda yakin mengirim notifikasi status Konfirmasi Penukaran ke donatur ${trackingController.daftarDonatur.value?.data[i].name}?", title: "Kirim Notifikasi", onOK: () async {
                                        Navigator.pop(context);
                                        await trackingController.postNotification(donaturID: trackingController.daftarDonatur.value?.data[i].id, jadwaID: trackingController.daftarDonatur.value?.data[i].jadwal, type: 'konfirmasi-penukaran').then((value){
                                          if(value){
                                            Get.snackbar("Berhasil", "Berhasil mengirim notifikasi ke telegram ${trackingController.daftarDonatur.value?.data[i].name}", backgroundColor: Colors.green, colorText: Colors.white);
                                          }else{
                                            Get.snackbar("Gagal", "Gagal mengirim notifikasi ke telegram ${trackingController.daftarDonatur.value?.data[i].name}", backgroundColor: Colors.red, colorText: Colors.white);
                                          }
                                        });
                                      });
                                    },
                                    child: Icon(trackingController.daftarDonatur.value?.data[i].statusPengambilan == true ? Icons.notifications_active : Icons.notifications_active_outlined, color: GlobalVariable.secondaryColor, size: 19)
                                  ),
                                )
                              ),
                              DataCell(
                                SizedBox(
                                  height: 30,
                                  child: Obx(() => ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: trackingController.daftarDonatur.value?.data[i].h == false && trackingController.daftarDonatur.value?.data[i].status != "4" ? Colors.grey : GlobalVariable.secondaryColor,
                                        elevation: 0
                                      ),
                                      onPressed: trackingController.daftarDonatur.value?.data[i].h == false || trackingController.daftarDonatur.value?.data[i].status == "4" ? (){
                                        Get.snackbar("Gagal", "Anda belum mengirim notifikasi hari H kepada donatur untuk memberitahu bahwa akan ada jadwal pengambilan pada hari ini", backgroundColor: Colors.red, colorText: Colors.white);
                                      } : (){
                                        SystemChrome.setPreferredOrientations([
                                          DeviceOrientation.portraitUp,
                                          DeviceOrientation.portraitDown
                                        ]);
                                        Get.to(() => DetailLokasi(
                                          code: ruteID.value,
                                          jadwaID: trackingController.daftarDonatur.value?.data[i].jadwal,
                                          name: dropdownRute.value,
                                          status: trackingController.daftarDonatur.value?.data[i].status,
                                          latitude: latitudeRute.value,
                                          longitude: longitudeRute.value,
                                        ));
                                      },
                                      child: Text("Lihat", style: TextStyle(color: trackingController.daftarDonatur.value?.data[i].h == false ? Colors.black : Colors.white))
                                    ),
                                  ),
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
              }),

              const SizedBox(height: 20),
              Obx(() => showDataTable.value 
                ? Container(
                  color: Colors.transparent,
                  child: Column(
                    children: [
                      const Row(
                        children: [
                          Icon(Icons.notifications_active_outlined, color: GlobalVariable.secondaryColor),
                          SizedBox(width: 10),
                          Text("Belum diinformasikan pengambilan kepada donatur")
                        ],
                      ),
                
                      const Row(
                        children: [
                          Icon(Icons.notifications_active, color: GlobalVariable.secondaryColor),
                          SizedBox(width: 10),
                          Text("Sudah diinformasikan pengambilan kepada donatur sesuai hari H")
                        ],
                      ),
                
                      Row(
                        children: [
                          Container(
                            width: 40,
                            height: 15,
                            color: Colors.yellow,
                          ),
                          const SizedBox(width: 10),
                          const Text("Status Rapel")
                        ],
                      ),
                    ],
                  ),
                ) 
                : const SizedBox(),
              )
            ],
          ),
        ),
      )
    );
  }

  void showAlertDialog(BuildContext contex, {String? title, String? content, Function()? onOK}) {
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
            onPressed: onOK,
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