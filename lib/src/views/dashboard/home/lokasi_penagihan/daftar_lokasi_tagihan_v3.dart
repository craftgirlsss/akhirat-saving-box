import 'dart:io';
import 'package:asb_app/src/components/global/index.dart';
import 'package:asb_app/src/controllers/tracking/tracking_controller.dart';
import 'package:asb_app/src/controllers/utilities/location_controller.dart';
import 'package:asb_app/src/controllers/wilayah/wilayah_controller.dart';
import 'package:asb_app/src/views/dashboard/home/lokasi_penagihan/detail_lokasi.dart';
import 'package:asb_app/src/views/dashboard/home/lokasi_penagihan/persiapan_berangkat.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

List<String> list2 = <String>['Semua', 'Rapel'];

class DaftarLokasiTagihanv3 extends StatefulWidget {
  const DaftarLokasiTagihanv3({super.key, this.restorationId, this.isReminder});
  final String? restorationId;
  final bool? isReminder;

  @override
  State<DaftarLokasiTagihanv3> createState() => _DaftarLokasiTagihanv3State();
}

class _DaftarLokasiTagihanv3State extends State<DaftarLokasiTagihanv3> {
  LocationController locationController = Get.put(LocationController());
  WilayahController wilayahController = Get.put(WilayahController());
  TrackingController trackingController = Get.find();
  DateTime now = DateTime.now();
  RxBool showDataTable = false.obs;

  // Variable for saving state Rute, Type and Date Selected
  RxString wilayahID = ''.obs;
  RxString selectedType = ''.obs;
  RxString selectedDate = ''.obs;

  RxInt selectedRuteIndex = 0.obs;
  RxInt selectedTipeIndex = 0.obs;
  double kItemExtent = 25;
  RxList<String> daftarRute = <String>[
    'Cari'
  ].obs;

  RxList<String> daftarTipe = <String>[
    'Semua',
    'Rapel'
  ].obs;

  String dateFormatted({DateTime? time}){
    return DateFormat('dd MMM yyyy').format(time ?? now);
  }

  String dateFormattedHMS({DateTime? time}){
    return DateFormat('yyyy-MM-dd hh:mm:ss').format(time ?? now);
  }

  String dateFormattedYearAndMonth({DateTime? time}){
    return DateFormat('yyyy MMMM').format(time ?? now);
  }

  String dateFormattedYearAndMonthV2({DateTime? time}){
    return DateFormat('yyyy-MM').format(time ?? now);
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
    wilayahController.getWilayah().then((result){
      if(result){
        // daftarRute.value = [];
        // for(int i = 0; i<wilayahController.wilayahModels.value!.data.length; i++){
        //   daftarRute.add(wilayahController.wilayahModels.value!.data[i].nama);
        // }
        // setState(() {});
        selectedDate.value = dateFormattedYearAndMonthV2(time: now);
        wilayahID.value = wilayahController.wilayahModels.value!.data[selectedRuteIndex.value].id;
        selectedType.value = daftarTipe[selectedTipeIndex.value];
        trackingController.getRuteV2(ruteID: wilayahID.value, tanggal: dateFormattedYearAndMonthV2(time: now), type: selectedType.value).then((api){
          if(!api){
            Get.snackbar("Gagal", trackingController.responseMessage.value, backgroundColor: Colors.red, colorText: Colors.white);
          }else{
            if(trackingController.listRuteTerbaru.value != null){
              if(result){
                showDataTable(true);
              }else{
                showDataTable(false);
              }
            }
          }
        });
      }else{
        Get.snackbar("Gagal", wilayahController.responseString.value, backgroundColor: Colors.red, colorText: Colors.white);
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        forceMaterialTransparency: true,
        title: Text(widget.isReminder == null || widget.isReminder == false ? "Daftar Donatur Hari H" : "Reminder", style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        centerTitle: true,
        actions: [
          CupertinoButton(
            onPressed: (){},
            child: const Icon(CupertinoIcons.info)
          )
        ],
      ),
      body: RefreshIndicator(
        backgroundColor: GlobalVariable.secondaryColor,
        color: Colors.white,
        onRefresh: () async {
          await trackingController.getRuteV2(ruteID: wilayahID.value, tanggal: selectedDate.value, type: selectedType.value).then((value){
            if(value){
              showDataTable(true);
            }else{
              showDataTable(false);
            }
          });
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black38, width: 0.5),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    const Text('Pilih Wilayah/Rute: '),
                    Obx(() => CupertinoButton(
                        padding: EdgeInsets.zero,
                        onPressed: wilayahController.isLoading.value ? null : () => _showDialog(
                          CupertinoPicker(
                            magnification: 1.5,
                            squeeze: 1.3,
                            useMagnifier: true,
                            itemExtent: kItemExtent,
                            scrollController: FixedExtentScrollController(
                              initialItem: selectedRuteIndex.value,
                            ),
                            onSelectedItemChanged: (int selectedItem) {
                              selectedRuteIndex.value = selectedItem;
                              if(wilayahController.wilayahModels.value != null){
                                wilayahID.value = wilayahController.wilayahModels.value!.data[selectedRuteIndex.value].id;
                              }
                              trackingController.getRuteV2(ruteID: wilayahID.value, type: daftarTipe[selectedTipeIndex.value], tanggal: selectedDate.value).then((result){
                                print(result);
                              });
                            },
                            children: wilayahController.wilayahModels.value != null ? wilayahController.wilayahModels.value!.data.map((name) => Text(name.nama)).toList() : [],
                          ),
                        ),
                        child: Obx(() => Text(wilayahController.wilayahModels.value?.data[selectedRuteIndex.value].nama ?? "Unknown", style: const TextStyle(color: GlobalVariable.secondaryColor, fontWeight: FontWeight.bold, fontSize: 14))),
                      ),
                    ),
                  ],
                ),
              ),

              Row(
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black38, width: 0.5),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          const Text('Pilih Tipe: '),
                          Obx(() => CupertinoButton(
                              padding: EdgeInsets.zero,
                              onPressed: wilayahController.isLoading.value ? null : () => _showDialog(
                                CupertinoPicker(
                                  magnification: 1.5,
                                  squeeze: 1.3,
                                  useMagnifier: true,
                                  itemExtent: kItemExtent,
                                  scrollController: FixedExtentScrollController(
                                    initialItem: selectedTipeIndex.value,
                                  ),
                                  onSelectedItemChanged: (int selectedItem) {
                                    selectedTipeIndex.value = selectedItem;
                                    trackingController.getRuteV2(ruteID: wilayahID.value, type: daftarTipe[selectedTipeIndex.value], tanggal: selectedDate.value).then((result){
                                      print(result);
                                    });
                                  },
                                  children: List<Widget>.generate(daftarTipe.length, (int index) {
                                    return Center(child: Text(daftarTipe[index], style: const TextStyle(color: GlobalVariable.secondaryColor)));
                                  }),
                                ),
                              ),
                              child: Obx(() => Text(daftarTipe[selectedTipeIndex.value], style: const TextStyle(color: GlobalVariable.secondaryColor, fontWeight: FontWeight.bold, fontSize: 14))),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
              
                  widget.isReminder == null || widget.isReminder == false ? Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black38, width: 0.5),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          const Text('Pilih Tanggal: '),
                          Obx(() => CupertinoButton(
                              padding: EdgeInsets.zero,
                              onPressed: wilayahController.isLoading.value ? null : () => _showDialog(
                                CupertinoDatePicker(
                                  mode: CupertinoDatePickerMode.monthYear,
                                  initialDateTime: now,
                                  onDateTimeChanged: (value) {
                                    selectedDate.value = dateFormattedYearAndMonthV2(time: value);    
                                    trackingController.getRuteV2(ruteID: wilayahID.value, type: daftarTipe[selectedTipeIndex.value], tanggal: selectedDate.value).then((result){
                                      print(result);
                                    });                            
                                  },
                                  maximumYear: now.year,
                                  minimumYear: now.year - 10,
                                )
                              ),
                              child: Obx(() => Text(selectedDate.value, style: const TextStyle(color: GlobalVariable.secondaryColor, fontWeight: FontWeight.bold, fontSize: 14))),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ) : const SizedBox(),
                ],
              ),
        
              const SizedBox(height: 20),

              Obx(() => trackingController.isLoading.value ? const CircularProgressIndicator() : Column(
                    children: [
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            Obx(() => trackingController.listRuteTerbaru.value != null 
                            ? DataTable(
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
                                        'Hari',
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
                                        'H-2',
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
                                        'H',
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
                                ],
                                rows: List.generate(trackingController.listRuteTerbaru.value!.data!.length, (i){
                                  return DataRow(
                                    color: WidgetStatePropertyAll(trackingController.listRuteTerbaru.value?.data?[i].status == "5" ?  Colors.yellow.shade200 : trackingController.listRuteTerbaru.value?.data?[i].status == "3" ? Colors.blue.shade200 : trackingController.listRuteTerbaru.value?.data?[i].status == "4" ? Colors.green.shade200 : Colors.white),
                                    cells: <DataCell>[
                                      // Kode
                                      DataCell(
                                        placeholder: true,
                                        CupertinoButton(
                                          onPressed: widget.isReminder == null || widget.isReminder == false ? (){
                                            Get.to(() => DetailLokasi(
                                              status: trackingController.listRuteTerbaru.value!.data![i].status,
                                              code: trackingController.listRuteTerbaru.value!.data![i].id,
                                              jadwaID: trackingController.listRuteTerbaru.value!.data![i].jadwalID,
                                              latitude: double.parse(trackingController.listRuteTerbaru.value!.data![i].lokasiPenukaran!.lat!),
                                              longitude: double.parse(trackingController.listRuteTerbaru.value!.data![i].lokasiPenukaran!.lng!),
                                              name: trackingController.listRuteTerbaru.value!.data![i].nama,
                                              subtitle: trackingController.listRuteTerbaru.value!.data![i].alamat,
                                            ));
                                          } : null,
                                          padding: EdgeInsets.zero,
                                          child: Text(trackingController.listRuteTerbaru.value?.data?[i].kode ?? i.toString(), style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: GlobalVariable.secondaryColor), textAlign: TextAlign.start)
                                        )
                                      ),
                                      // Name
                                      DataCell(CupertinoButton(
                                        onPressed: widget.isReminder == null || widget.isReminder == false ? (){
                                          Get.to(() => DetailLokasi(
                                            status: trackingController.listRuteTerbaru.value!.data![i].status,
                                            code: trackingController.listRuteTerbaru.value!.data![i].id,
                                            jadwaID: trackingController.listRuteTerbaru.value!.data![i].jadwalID,
                                            latitude: double.parse(trackingController.listRuteTerbaru.value!.data![i].lokasiPenukaran!.lat!),
                                            longitude: double.parse(trackingController.listRuteTerbaru.value!.data![i].lokasiPenukaran!.lng!),
                                            name: trackingController.listRuteTerbaru.value!.data![i].nama,
                                            subtitle: trackingController.listRuteTerbaru.value!.data![i].alamat,
                                          ));
                                        } : null,
                                        padding: EdgeInsets.zero,
                                        child: Text(trackingController.listRuteTerbaru.value?.data?[i].nama ?? i.toString(), style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: GlobalVariable.secondaryColor), textAlign: TextAlign.start))),
                                      // Alamat
                                      DataCell(Text(trackingController.listRuteTerbaru.value?.data?[i].alamat ?? i.toString(), style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold))),
                                      // Phone
                                      DataCell(Text(trackingController.listRuteTerbaru.value?.data?[i].telepon ?? i.toString(), style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold))),
                                      //Jam
                                      DataCell(Obx(() => GestureDetector(
                                        onTap: trackingController.isLoading.value ? null : () async {
                                          print("Ditekan");
                                          _showDialog(
                                            CupertinoDatePicker(
                                              mode: CupertinoDatePickerMode.time,
                                              use24hFormat: true,
                                              initialDateTime: now,
                                              onDateTimeChanged: (value) {
                                                trackingController.listRuteTerbaru.value?.data?[i].jam = dateFormatTime(time: value);
                                              },
                                              maximumYear: now.year,
                                              minimumYear: now.year - 10,
                                            )
                                          );
                                          await trackingController.ubahTanggalRapel(
                                            jam: trackingController.listRuteTerbaru.value?.data?[i].jam,
                                            donaturID: trackingController.listRuteTerbaru.value?.data?[i].id,
                                            tanggal: trackingController.listRuteTerbaru.value?.data?[i].tanggalPengambilan,
                                          ).then((value){
                                            print("Ini result value $value");
                                            trackingController.getRuteV2(tanggal: selectedDate.value, ruteID: wilayahID.value, type: selectedType.value).then((result){
                                              if(result){
                                                Get.snackbar("Berhasil", trackingController.responseMessage.value, backgroundColor: Colors.green, colorText: Colors.white);
                                                showDataTable(true);
                                              }else{
                                                Get.snackbar("Gagal", trackingController.responseMessage.value, backgroundColor: Colors.red, colorText: Colors.white);
                                                showDataTable(false);
                                              }
                                            });
                                          });
                                        },
                                        child: Text(trackingController.listRuteTerbaru.value?.data?[i].jam ?? i.toString(), style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),)))),
                                      // Tanggal
                                      DataCell(Obx(() => GestureDetector(
                                        onTap: trackingController.isLoading.value ? null : () async {},
                                        child: Text(DateFormat('EEEE').format(DateTime.parse(trackingController.listRuteTerbaru.value!.data![i].tanggalPengambilan!)), style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold))
                                        ),
                                      )),
                                              
                                      //Hari
                                      DataCell(Obx(() => GestureDetector(
                                        onTap: trackingController.isLoading.value ? null : () async {
                                          _showDialog(
                                            CupertinoDatePicker(
                                              mode: CupertinoDatePickerMode.date,
                                              use24hFormat: true,
                                              initialDateTime: now,
                                              onDateTimeChanged: (value) {
                                                setState(() {
                                                  trackingController.listRuteTerbaru.value?.data?[i].tanggalPengambilan = dateFormatted(time: value);
                                                });
                                              },
                                              maximumYear: now.year,
                                              minimumYear: now.year - 10,
                                            )
                                          );
                                          await trackingController.ubahTanggalRapel(
                                            jam: trackingController.listRuteTerbaru.value?.data?[i].jam,
                                            donaturID: trackingController.listRuteTerbaru.value?.data?[i].id,
                                            tanggal: trackingController.listRuteTerbaru.value?.data?[i].tanggalPengambilan,
                                          ).then((value){
                                            trackingController.getRuteV2(tanggal: selectedDate.value, ruteID: wilayahController.wilayahModels.value?.data[selectedRuteIndex.value].id, type: selectedType.value).then((result){});
                                          });
                                        },
                                        child: Text(trackingController.listRuteTerbaru.value?.data?[i].tanggalPengambilan ?? i.toString(), style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),)))),
                                              
                                      // H-2
                                      DataCell(
                                        Obx(() => CupertinoButton(
                                            padding: EdgeInsets.zero,
                                            onPressed: trackingController.listRuteTerbaru.value?.data?[i].h2 == true ? (){
                                              Get.snackbar("Gagal", "Anda sudah mengirim notifikasi H-2 sebelumnya pada donatur", backgroundColor: Colors.red, colorText: Colors.white);
                                              } : (){
                                              showAlertDialog(context, content: "Apakah anda yakin mengirim notifikasi status H-2 ke donatur ${trackingController.listRuteTerbaru.value?.data?[i].nama}?", title: "Kirim Notifikasi", onOK: () async {
                                                Navigator.pop(context);
                                                await trackingController.postNotification(donaturID: trackingController.listRuteTerbaru.value?.data?[i].id, jadwaID: trackingController.listRuteTerbaru.value?.data?[i].jadwalID, type: 'h2').then((value){
                                                  if(value){
                                                    Get.snackbar("Berhasil", "Berhasil mengirim notifikasi ke telegram ${trackingController.listRuteTerbaru.value?.data?[i].nama}", backgroundColor: Colors.green, colorText: Colors.white);
                                                    trackingController.getRuteV2(tanggal: selectedDate.value, ruteID: wilayahController.wilayahModels.value?.data[selectedRuteIndex.value].id, type: selectedType.value).then((result){
                                                      if(result){
                                                        showDataTable(true);
                                                      }else{
                                                        showDataTable(false);
                                                      }
                                                    });
                                                  }else{
                                                    Get.snackbar("Gagal", "Gagal mengirim notifikasi ke telegram ${trackingController.listRuteTerbaru.value?.data?[i].nama}", backgroundColor: Colors.red, colorText: Colors.white);
                                                  }
                                                });
                                              });
                                            },
                                            child: Icon(trackingController.listRuteTerbaru.value?.data?[i].h2 == true ? Icons.notifications_active : Icons.notifications_active_outlined, color: GlobalVariable.secondaryColor, size: 19)
                                          ),
                                        )
                                      ),
                                      // H-1
                                      DataCell(
                                        Obx(() => CupertinoButton(
                                            padding: EdgeInsets.zero,
                                            onPressed: trackingController.listRuteTerbaru.value?.data?[i].h1 == true ? (){
                                              Get.snackbar("Gagal", "Anda sudah mengirim notifikasi H-1 sebelumnya pada donatur", backgroundColor: Colors.red, colorText: Colors.white);
                                            } : (){
                                              showAlertDialog(context, content: "Apakah anda yakin mengirim notifikasi status H-1 ke donatur ${trackingController.listRuteTerbaru.value?.data?[i].nama}?", title: "Kirim Notifikasi", onOK: () async {
                                                Navigator.pop(context);
                                                await trackingController.postNotification(donaturID: trackingController.listRuteTerbaru.value?.data?[i].id, jadwaID: trackingController.listRuteTerbaru.value?.data?[i].jadwalID, type: 'h1').then((value){
                                                  if(value){
                                                    Get.snackbar("Berhasil", "Berhasil mengirim notifikasi ke telegram ${trackingController.listRuteTerbaru.value?.data?[i].nama}", backgroundColor: Colors.green, colorText: Colors.white);
                                                    trackingController.getRuteV2(tanggal: selectedDate.value, ruteID: wilayahController.wilayahModels.value?.data[selectedRuteIndex.value].id, type: selectedType.value).then((result){
                                                      if(result){
                                                        showDataTable(true);
                                                      }else{
                                                        showDataTable(false);
                                                      }
                                                    });
                                                  }else{
                                                    Get.snackbar("Gagal", "Gagal mengirim notifikasi ke telegram ${trackingController.listRuteTerbaru.value?.data?[i].nama}", backgroundColor: Colors.red, colorText: Colors.white);
                                                  }
                                                });
                                              });
                                            },
                                            child: Icon(trackingController.listRuteTerbaru.value?.data?[i].h1 == true ? Icons.notifications_active : Icons.notifications_active_outlined, color: GlobalVariable.secondaryColor, size: 19)
                                          ),
                                        )
                                      ),
                                      // H
                                      DataCell(
                                        Obx(() => CupertinoButton(
                                            padding: EdgeInsets.zero,
                                            onPressed: trackingController.listRuteTerbaru.value?.data?[i].h == true ? (){
                                              Get.snackbar("Gagal", "Anda sudah mengirim notifikasi H sebelumnya pada donatur", backgroundColor: Colors.red, colorText: Colors.white);
                                            } : () {
                                              showAlertDialog(context, content: "Apakah anda yakin mengirim notifikasi status H ke donatur ${trackingController.listRuteTerbaru.value?.data?[i].nama}?", title: "Kirim Notifikasi", onOK: () async {
                                                Navigator.pop(context);
                                                await trackingController.postNotification(donaturID: trackingController.listRuteTerbaru.value?.data?[i].id, jadwaID: trackingController.listRuteTerbaru.value?.data?[i].jadwalID, type: 'h').then((value){
                                                  if(value){
                                                    Get.snackbar("Berhasil", "Berhasil mengirim notifikasi ke telegram ${trackingController.listRuteTerbaru.value?.data?[i].nama}", backgroundColor: Colors.green, colorText: Colors.white);
                                                    trackingController.getRuteV2(tanggal: selectedDate.value, ruteID: wilayahController.wilayahModels.value?.data[selectedRuteIndex.value].id, type: selectedType.value).then((result){
                                                      if(result){
                                                        showDataTable(true);
                                                      }else{
                                                        showDataTable(false);
                                                      }
                                                    });
                                                  }else{
                                                    Get.snackbar("Gagal", "${trackingController.responseMessage.value} ${trackingController.listRuteTerbaru.value?.data?[i].nama}", backgroundColor: Colors.red, colorText: Colors.white);
                                                  }
                                                });
                                              });
                                            },
                                            child: Icon(trackingController.listRuteTerbaru.value?.data?[i].h == true ? Icons.notifications_active : Icons.notifications_active_outlined, color: GlobalVariable.secondaryColor, size: 19)
                                          ),
                                        )
                                      ),
                                      // Rapel
                                      DataCell(
                                        Obx(() => CupertinoButton(
                                            padding: EdgeInsets.zero,
                                            onPressed: trackingController.listRuteTerbaru.value?.data?[i].rapel == true ? (){
                                                Get.snackbar("Gagal", "Anda sudah mengirim notifikasi Rapel sebelumnya pada donatur", backgroundColor: Colors.red, colorText: Colors.white);
                                              } : (){
                                              showAlertDialog(context, content: "Apakah anda yakin mengirim notifikasi status Rapel ke donatur ${trackingController.listRuteTerbaru.value?.data?[i].nama}?", title: "Kirim Notifikasi", onOK: () async {
                                                Navigator.pop(context);
                                                await trackingController.postNotification(donaturID: trackingController.listRuteTerbaru.value?.data?[i].id, jadwaID: trackingController.listRuteTerbaru.value?.data?[i].jadwalID, type: 'rapel').then((value){
                                                  if(value){
                                                    Get.snackbar("Berhasil", "Berhasil mengirim notifikasi ke telegram ${trackingController.listRuteTerbaru.value?.data?[i].nama}", backgroundColor: Colors.green, colorText: Colors.white);
                                                    trackingController.getRuteV2(tanggal: selectedDate.value, ruteID: wilayahController.wilayahModels.value?.data[selectedRuteIndex.value].id, type: selectedType.value).then((result){
                                                      if(result){
                                                        showDataTable(true);
                                                      }else{
                                                        showDataTable(false);
                                                      }
                                                    });
                                                  }else{
                                                    Get.snackbar("Gagal", "Gagal mengirim notifikasi ke telegram ${trackingController.listRuteTerbaru.value?.data?[i].nama}", backgroundColor: Colors.red, colorText: Colors.white);
                                                  }
                                                });
                                              });
                                            },
                                            child: Icon(trackingController.listRuteTerbaru.value?.data?[i].rapel == true ? Icons.notifications_active : Icons.notifications_active_outlined, color: GlobalVariable.secondaryColor, size: 19)
                                          ),
                                        )
                                      ),
                                      DataCell(
                                        Obx(() => CupertinoButton(
                                            padding: EdgeInsets.zero,
                                            onPressed: trackingController.listRuteTerbaru.value?.data?[i].jadwalRapel == true ? (){
                                                Get.snackbar("Gagal", "Anda sudah mengirim notifikasi Jadwal Rapel sebelumnya pada donatur", backgroundColor: Colors.red, colorText: Colors.white);
                                              } : (){
                                              showAlertDialog(context, content: "Apakah anda yakin mengirim notifikasi status Konfirmasi Rapel ke donatur ${trackingController.listRuteTerbaru.value?.data?[i].nama}?", title: "Kirim Notifikasi", onOK: () async {
                                                Navigator.pop(context);
                                                await trackingController.postNotification(donaturID: trackingController.listRuteTerbaru.value?.data?[i].id, jadwaID: trackingController.listRuteTerbaru.value?.data?[i].jadwalID, type: 'konfirmasi-rapel').then((value){
                                                  if(value){
                                                    Get.snackbar("Berhasil", "Berhasil mengirim notifikasi ke telegram ${trackingController.listRuteTerbaru.value?.data?[i].nama}", backgroundColor: Colors.green, colorText: Colors.white);
                                                    trackingController.getRuteV2(tanggal: selectedDate.value, ruteID: wilayahController.wilayahModels.value?.data[selectedRuteIndex.value].id, type: selectedType.value).then((result){
                                                      if(result){
                                                        showDataTable(true);
                                                      }else{
                                                        showDataTable(false);
                                                      }
                                                    });
                                                  }else{
                                                    Get.snackbar("Gagal", "Gagal mengirim notifikasi ke telegram ${trackingController.listRuteTerbaru.value?.data?[i].nama}", backgroundColor: Colors.red, colorText: Colors.white);
                                                  }
                                                });
                                              });
                                            },
                                            child: Icon(trackingController.listRuteTerbaru.value?.data?[i].jadwalRapel == true ? Icons.notifications_active : Icons.notifications_active_outlined, color: GlobalVariable.secondaryColor, size: 19)
                                          ),
                                        )
                                      ),
                                    ],
                                  );
                                }
                                )
                              ) : const SizedBox(),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
              ),

              const SizedBox(height: 20),
              Obx(() => showDataTable.value 
                ? Container(
                  color: Colors.transparent,
                  child: Column(
                    children: [
                      const Text("Note :", style: TextStyle(fontSize: 16),),
                      const SizedBox(height: 10),
                      const Row(
                        children: [
                          Icon(Icons.notifications_active_outlined, color: GlobalVariable.secondaryColor),
                          SizedBox(width: 10),
                          Expanded(child: Text("Belum diinformasikan pengambilan kepada donatur"))
                        ],
                      ),
                
                      const Row(
                        children: [
                          Icon(Icons.notifications_active, color: GlobalVariable.secondaryColor),
                          SizedBox(width: 10),
                          Expanded(child: Text("Sudah diinformasikan pengambilan kepada donatur sesuai hari H"))
                        ],
                      ),
                      Row(
                        children: [
                          Container(
                            width: 40,
                            height: 15,
                            color: Colors.blue.shade200,
                          ),
                          const SizedBox(width: 10),
                          const Text("Sudah diambil, belum dihitung")
                        ],
                      ),
                      const SizedBox(height: 5),
                      Row(
                        children: [
                          Container(
                            width: 40,
                            height: 15,
                            color: Colors.green.shade200,
                          ),
                          const SizedBox(width: 10),
                          const Text("Sudah diambil, dan dihitung")
                        ],
                      ),
                      const SizedBox(height: 5),
                
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