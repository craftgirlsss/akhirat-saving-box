import 'dart:io';
import 'package:asb_app/src/components/global/index.dart';
import 'package:asb_app/src/controllers/tracking/tracking_controller.dart';
import 'package:asb_app/src/controllers/utilities/cupertino_dialogs.dart';
import 'package:asb_app/src/controllers/utilities/location_controller.dart';
import 'package:asb_app/src/controllers/wilayah/wilayah_controller.dart';
import 'package:asb_app/src/views/dashboard/home/lokasi_penagihan/cek_map_terakhir.dart';
import 'package:asb_app/src/views/dashboard/home/lokasi_penagihan/detail_lokasi.dart';
import 'package:asb_app/src/views/dashboard/home/lokasi_penagihan/generate_kwitansi_page.dart';
import 'package:asb_app/src/views/dashboard/home/lokasi_penagihan/image_viewer.dart';
import 'package:asb_app/src/views/dashboard/home/lokasi_penagihan/persiapan_berangkat.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

List<String> list2 = <String>['Semua', 'Rapel'];

class DaftarLokasiTagihanv2 extends StatefulWidget {
  const DaftarLokasiTagihanv2({super.key, this.restorationId, this.isReminder});
  final String? restorationId;
  final bool? isReminder;

  @override
  State<DaftarLokasiTagihanv2> createState() => _DaftarLokasiTagihanv2State();
}

class _DaftarLokasiTagihanv2State extends State<DaftarLokasiTagihanv2> {
  LocationController locationController = Get.put(LocationController());
  WilayahController wilayahController = Get.put(WilayahController());
  TrackingController trackingController = Get.find();
  DateTime now = DateTime.now();
  RxBool showDataTable = true.obs;

  RxList listDataColumn = ["Kode","Name","Alamat","Nomor HP", "Jam", "Hari", "Tanggal", "H-2", "H-1", "H", "Rapel", "Jadwal Rapel", "Lokasi Terakhir", "Foto Pengambilan", "Catatan Khusus"].obs;

  // Variable for saving state Rute, Type and Date Selected
  RxString wilayahID = ''.obs;
  RxString selectedType = ''.obs;
  RxString selectedDate = ''.obs;

  RxBool isLoading = false.obs;

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

  TextEditingController catatanDefault = TextEditingController();
  TextEditingController catatanKhusus = TextEditingController();

  TextEditingController latitude = TextEditingController();
  TextEditingController longitude = TextEditingController();
  TextEditingController keteranganEdit = TextEditingController();

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
          }
        });
      }else{
        Get.snackbar("Gagal", wilayahController.responseString.value, backgroundColor: Colors.red, colorText: Colors.white);
      }
    });
  }

  @override
  void dispose() {
    latitude.dispose();
    longitude.dispose();
    catatanDefault.dispose();
    catatanKhusus.dispose();
    keteranganEdit.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Obx(() => isLoading.value ? const SizedBox() : RefreshIndicator(
        backgroundColor: GlobalVariable.secondaryColor,
          color: Colors.white,
          onRefresh: () async {
            trackingController.getRuteV2(ruteID: wilayahID.value, tanggal: selectedDate.value, type: selectedType.value).then<Null>((value){
              if(value){
                showDataTable(true);
              }else{
                showDataTable(false);
              }
            });
          },
        child: Stack(
          children: [
            Scaffold(
              backgroundColor: Colors.white,
              appBar: AppBar(
                backgroundColor: Colors.white,
                forceMaterialTransparency: true,
                title: Text(widget.isReminder == null || widget.isReminder == false ? "Daftar Donatur Hari H" : "Reminder", style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                centerTitle: true,
                actions: [
                  CupertinoButton(
                    onPressed: () async {
                      trackingController.getRuteV2(ruteID: wilayahID.value, tanggal: selectedDate.value, type: selectedType.value);
                    },
                    child: const Icon(CupertinoIcons.refresh, color: GlobalVariable.secondaryColor)
                  )
                ],
              ),
              body: SingleChildScrollView(
                padding: const EdgeInsets.all(10),
                child: Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black38, width: 0.5),
                        borderRadius: const BorderRadius.only(topLeft: Radius.circular(7), topRight: Radius.circular(7))
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          const Text('Pilih Wilayah/Rute: '),
                          Obx(() => CupertinoButton(
                              padding: EdgeInsets.zero,
                              onPressed: wilayahController.isLoading.value ? null : () => customCupertinoDialog(context,
                                child: CupertinoPicker(
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
                              borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(7))
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                const Text('Pilih Tipe: '),
                                Obx(() => CupertinoButton(
                                    padding: EdgeInsets.zero,
                                    onPressed: wilayahController.isLoading.value ? null : () => customCupertinoDialog(context,
                                        child: CupertinoPicker(
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
                              borderRadius: const BorderRadius.only(bottomRight: Radius.circular(7))
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                const Text('Pilih Tanggal: '),
                                Obx(() => CupertinoButton(
                                    padding: EdgeInsets.zero,
                                    onPressed: wilayahController.isLoading.value ? null : () => customCupertinoDialog(context,
                                      child: CupertinoDatePicker(
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
                    
                    Column(
                      children: <Widget>[
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: <Widget>[
                              Obx(() => trackingController.listRuteTerbaru.value != null 
                              ? Container(
                                clipBehavior: Clip.hardEdge,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(13),
                                  border: Border.all(color: Colors.black26, width: 1)
                                ),
                                child: DataTable(
                                    columnSpacing: 10,
                                    horizontalMargin: 10,
                                    headingRowColor: const WidgetStatePropertyAll(GlobalVariable.secondaryColor),
                                    // border: const TableBorder(
                                    //   left: BorderSide(color: Colors.black26),
                                    //   right: BorderSide(color: Colors.black26),
                                    //   bottom: BorderSide(color: Colors.black26),
                                    //   top: BorderSide(color: Colors.black26),
                                    // ),
                                    columns: List<DataColumn>.generate(listDataColumn.length, (i) => DataColumn(label: Text(listDataColumn[i], style: const TextStyle(fontStyle: FontStyle.italic, fontWeight: FontWeight.bold, color: Colors.white, fontSize: 11)))),
                                    rows: List<DataRow>.generate(trackingController.listRuteTerbaru.value!.data!.length, (i){
                                      Color? colorRow;
                                      if(trackingController.listRuteTerbaru.value?.data?[i].status == "1"){
                                        colorRow = Colors.white;
                                      }else if(trackingController.listRuteTerbaru.value?.data?[i].status == "3"){
                                        colorRow = Colors.blue.shade100;
                                      }else if(trackingController.listRuteTerbaru.value?.data?[i].status == "4"){
                                        colorRow = Colors.green.shade100;
                                      }else if(trackingController.listRuteTerbaru.value?.data?[i].status == "5"){
                                        colorRow = Colors.yellow.shade100;
                                      }else if(trackingController.listRuteTerbaru.value?.data?[i].status == "6"){
                                        colorRow = Colors.red.shade100;
                                      }else if(trackingController.listRuteTerbaru.value?.data?[i].status == "7"){
                                        colorRow = Colors.red.shade100;
                                      }else if(trackingController.listRuteTerbaru.value?.data?[i].status == "8"){
                                        colorRow = Colors.red.shade100;
                                      }else{
                                        colorRow = Colors.black12;
                                      }
                                      return DataRow(
                                        color: WidgetStatePropertyAll<Color?>(colorRow),
                                        cells: <DataCell>[
                                          // Kode
                                          DataCell(
                                            placeholder: true,
                                            CupertinoButton(
                                              onPressed: (){
                                                if(trackingController.listRuteTerbaru.value?.data?[i].status == "4"){
                                                  Get.to(() => GenerateKwitansiPage(fromTableView: true, jadwalID: trackingController.listRuteTerbaru.value?.data?[i].jadwalID));
                                                }else{
                                                  Get.snackbar("Gagal", "Tim distribusi belum menyelesaikan penghitungan perolehan", backgroundColor: GlobalVariable.secondaryColor, colorText: Colors.white);
                                                }
                                              },
                                              padding: EdgeInsets.zero,
                                              child: Text(trackingController.listRuteTerbaru.value?.data?[i].kode ?? i.toString(), style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: GlobalVariable.secondaryColor), textAlign: TextAlign.start)
                                            )
                                          ),
                                          // Name
                                          DataCell(CupertinoButton(
                                            onPressed: (){
                                              catatanDefault.text = trackingController.listRuteTerbaru.value?.data?[i].catatanDefault ?? ""; // tolong ini diperbaiki
                                              _showAlertDialogEditCatatanDefault(context, name: trackingController.listRuteTerbaru.value?.data?[i].nama, donaturCode: trackingController.listRuteTerbaru.value?.data?[i].kode);
                                            },
                                            padding: EdgeInsets.zero,
                                            child: SizedBox(
                                              width: size.width * .3,
                                              child: Row(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                children: <Widget>[
                                                  Expanded(child: Text(trackingController.listRuteTerbaru.value?.data?[i].nama ?? i.toString(), style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: GlobalVariable.secondaryColor), textAlign: TextAlign.start, maxLines: 2, overflow: TextOverflow.fade)),
                                                  trackingController.listRuteTerbaru.value?.data?[i].catatanDefault != null ? const Icon(Icons.message, size: 15, color: Colors.black45) : const SizedBox()
                                                ],
                                              )))),
                                          // Alamat
                                          DataCell(CupertinoButton(
                                            padding: EdgeInsets.zero,
                                            onPressed: (){
                                              if(trackingController.listRuteTerbaru.value?.data?[i].lokasiPenukaran?.lat == "" || trackingController.listRuteTerbaru.value?.data?[i].lokasiPenukaran?.lng == ""){
                                                wilayahController.getDonatrurLokasiByDonaturKode(donaturKode: trackingController.listRuteTerbaru.value?.data?[i].kode).then((result){
                                                  if(result){
                                                    _showAlertDialogEditLatLongKosong(context, name: trackingController.listRuteTerbaru.value?.data?[i].nama, lokasiID: wilayahController.lokasiDonaturModels.value?.data[0].id);
                                                  }else{
                                                    Navigator.pop(context);
                                                    Get.snackbar("Gagal", wilayahController.responseString.value, backgroundColor: Colors.red, colorText: Colors.white);
                                                  }
                                                });
                                              }else{
                                                Get.to<dynamic>(() => DetailLokasi(
                                                  kodeASB: trackingController.listRuteTerbaru.value!.data![i].kode,
                                                  status: trackingController.listRuteTerbaru.value!.data![i].status,
                                                  code: trackingController.listRuteTerbaru.value!.data![i].id,
                                                  jadwaID: trackingController.listRuteTerbaru.value!.data![i].jadwalID,
                                                  latitude: double.parse(trackingController.listRuteTerbaru.value!.data![i].lokasiPenukaran!.lat!),
                                                  longitude: double.parse(trackingController.listRuteTerbaru.value!.data![i].lokasiPenukaran!.lng!),
                                                  name: trackingController.listRuteTerbaru.value!.data![i].nama,
                                                  subtitle: trackingController.listRuteTerbaru.value!.data![i].alamat,
                                                ));
                                              }
                                            },
                                            child: SizedBox(
                                              width: size.width * .4,
                                              child: Text(trackingController.listRuteTerbaru.value?.data?[i].alamat ?? i.toString(), style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: GlobalVariable.secondaryColor))),
                                          )),
                                          // Phone
                                          DataCell(Text(trackingController.listRuteTerbaru.value?.data?[i].telepon ?? i.toString(), style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold))),
                                          //Jam
                                          DataCell(Obx(() => GestureDetector(
                                            onTap: trackingController.isLoading.value ? null : () async {

                                              /*
                                              customCupertinoDialog(context,
                                                child: CupertinoDatePicker(
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
                                              ).then<Null>((bool value){
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
                                              */
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
                                              /*
                                              customCupertinoDialog(context,
                                                child: CupertinoDatePicker(
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
                                              */
                                            },
                                            child: Text(trackingController.listRuteTerbaru.value?.data?[i].tanggalPengambilan ?? i.toString(), style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),)))),
                
                                          // INI AWAL
                                            DataCell(
                                            Obx(() => CupertinoButton(
                                                padding: EdgeInsets.zero,
                                                onPressed: trackingController.listRuteTerbaru.value?.data?[i].h2 == true ? (){
                                                  Get.snackbar("Gagal", "Anda sudah mengirim notifikasi H-2 sebelumnya pada donatur", backgroundColor: Colors.red, colorText: Colors.white);
                                                  } : (){
                                                  showAlertDialog(context, content: "Apakah anda yakin mengirim notifikasi status H-2 ke donatur ${trackingController.listRuteTerbaru.value?.data?[i].nama}?", title: "Kirim Notifikasi", onOK: () async {
                                                    Navigator.pop<Object?>(context);
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
                                                    Navigator.pop<Object?>(context);
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
                                          // INI AKHIR
                                                  
                                          DataCell(
                                            Obx(() => CupertinoButton(
                                                padding: EdgeInsets.zero,
                                                onPressed: trackingController.listRuteTerbaru.value?.data?[i].lokasiTerakhir?.lat == null || trackingController.listRuteTerbaru.value?.data?[i].lokasiTerakhir?.lat == "" ? (){
                                                  Get.snackbar("Gagal", "Data lokasi terakhir belum tersedia", backgroundColor: Colors.red, colorText: Colors.white);
                                                } : (){
                                                  Get.to(() => CekMapTerakhir(latitude: double.parse(trackingController.listRuteTerbaru.value!.data![i].lokasiTerakhir!.lat!), longitude: double.parse(trackingController.listRuteTerbaru.value!.data![i].lokasiTerakhir!.lng!)));
                                                },
                                                child: Icon(trackingController.listRuteTerbaru.value?.data?[i].lokasiTerakhir?.lat != null ? CupertinoIcons.location : CupertinoIcons.location_slash, color: GlobalVariable.secondaryColor, size: 19)
                                              ),
                                            )
                                          ),
                                          DataCell(
                                            Obx(() => CupertinoButton(
                                                padding: EdgeInsets.zero,
                                                onPressed: trackingController.listRuteTerbaru.value?.data?[i].fotoPenukaran == null || trackingController.listRuteTerbaru.value?.data?[i].fotoPenukaran?.length == 0 ? (){
                                                    Get.snackbar("Gagal", "Data foto terakhir belum tersedia", backgroundColor: Colors.red, colorText: Colors.white);
                                                  } : (){
                                                    print(trackingController.listRuteTerbaru.value?.data?[i].fotoPenukaran);
                                                    Get.to(() => ImageViewer(listPhoto: trackingController.listRuteTerbaru.value!.data![i].fotoPenukaran!, name: trackingController.listRuteTerbaru.value?.data?[i].nama, kodeASB: trackingController.listRuteTerbaru.value?.data?[i].kode));
                                                  },
                                                child: Icon(trackingController.listRuteTerbaru.value?.data?[i].fotoPenukaran?.length == 0 ? Clarity.eye_hide_solid : CupertinoIcons.photo_on_rectangle, color: GlobalVariable.secondaryColor, size: 19)
                                              ),
                                            )
                                          ),
                                          DataCell(
                                            onTap: trackingController.listRuteTerbaru.value?.data?[i].catatanKhusus == null ? (){
                                              Get.snackbar("Gagal", "Tim distribusi belum melakukan pengambilan kotak amal, mohon selesaikan terlebih dahulu", backgroundColor: GlobalVariable.secondaryColor, colorText: Colors.white, duration: const Duration(seconds: 2));
                                            } : (){
                                              catatanKhusus.text = trackingController.listRuteTerbaru.value?.data?[i].catatanKhusus ?? "";
                                              _showAlertDialogEditCatatanKhusus(context, name: trackingController.listRuteTerbaru.value?.data?[i].nama, jadwaID: trackingController.listRuteTerbaru.value?.data?[i].jadwalID);
                                            },
                                            trackingController.listRuteTerbaru.value?.data?[i].catatanKhusus == null ? const Icon(CupertinoIcons.envelope, color: GlobalVariable.secondaryColor, size: 18) : const Icon(CupertinoIcons.envelope_badge, color: GlobalVariable.secondaryColor, size: 18)
                                          ),
                                        ],
                                      );
                                    }
                                    )
                                  ),
                              ) : const SizedBox(),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                    
                    const SizedBox(height: 20),
                    Obx(() => showDataTable.value 
                      ? Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black26, width: 0.5),
                          borderRadius: BorderRadius.circular(10)
                        ),
                        child: Column(
                          children: [
                            const Text("Notes :", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),),
                            const SizedBox(height: 10),
                            const Row(
                              children: [
                                Icon(Icons.message, color: Colors.black45),
                                SizedBox(width: 10),
                                Expanded(child: Text("Pesan default donatur, tidak akan berubah dan hilang jika tidak dirubah"))
                              ],
                            ),
                            const Divider(),
                            const Row(
                              children: [
                                Icon(CupertinoIcons.envelope_badge, color: GlobalVariable.secondaryColor),
                                SizedBox(width: 10),
                                Expanded(child: Text("Terdapat catatan khusus dari donatur untuk bulan terkait."))
                              ],
                            ),
                            const Divider(),
                            const Row(
                              children: [
                                Icon(CupertinoIcons.location_slash, color: GlobalVariable.secondaryColor),
                                SizedBox(width: 10),
                                Expanded(child: Text("Lokasi terakhi belum ada"))
                              ],
                            ),
                            const Divider(),
                            const Row(
                              children: [
                                Icon(Icons.notifications_active_outlined, color: GlobalVariable.secondaryColor),
                                SizedBox(width: 10),
                                Expanded(child: Text("Belum diinformasikan pengambilan kepada donatur"))
                              ],
                            ),
                            const Divider(),
                            const Row(
                              children: [
                                Icon(Icons.notifications_active, color: GlobalVariable.secondaryColor),
                                SizedBox(width: 10),
                                Expanded(child: Text("Sudah diinformasikan pengambilan kepada donatur sesuai hari H"))
                              ],
                            ),
                            const Divider(),
                            Row(
                              children: [
                                Container(
                                  width: 40,
                                  height: 15,
                                  color: Colors.blue.shade100,
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
                                  color: Colors.green.shade100,
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
                                  color: Colors.red.shade100,
                                ),
                                const SizedBox(width: 10),
                                const Text("Dibatalkan oleh donatur")
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
            ),
      
            //Loading
              Positioned(
                top: 0,
                right: 0,
                bottom: 0,
                left: 0,
                child: Obx(() => trackingController.isLoading.value || wilayahController.isLoading.value ? 
                  Container(
                    width: size.width,
                    height: size.height,
                    decoration: const BoxDecoration(
                      color: Colors.black26,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset('assets/images/search.gif', width: 100)
                      ],
                    ),
                  ) : const SizedBox(),
                )
              )
          ],
        ),
      ),
    );
  }

  void _showAlertDialogEditCatatanDefault(BuildContext context, {String? name = "Donatur", String? donaturCode}) {
    showCupertinoDialog<void>(
      context: context,
      builder: (BuildContext context) => CupertinoAlertDialog(
        title: const Text('Catatan Default'),
        content: Column(
          children: [
            Text('Beri catatan default khusus untuk $name. Catatan ini tidak akan tereset setiap bulan nya.'),
            const SizedBox(height: 5),
            CupertinoTextField(
              placeholder: "Catatan Khusus",
              placeholderStyle: const TextStyle(fontSize: 12, color: Colors.black26),
              controller: catatanDefault,
            )
          ],
        ),
        actions: <CupertinoDialogAction>[
          CupertinoDialogAction(
            isDefaultAction: true,
            onPressed: () {
              catatanDefault.clear();
              Navigator.pop(context);
            },
            child: const Text('No'),
          ),
          CupertinoDialogAction(
            isDestructiveAction: true,
            onPressed: () async {
              Navigator.pop(context);
              wilayahController.updateCatatanDefaultDonatur(donaturCode: donaturCode, note: catatanDefault.text).then<dynamic>((bool value) async {
                if(value){
                  await trackingController.getRuteV2(ruteID: wilayahID.value, tanggal: selectedDate.value, type: selectedType.value).then<Null>((value){
                    if(value){
                      showDataTable(true);
                    }else{
                      showDataTable(false);
                    }
                  });
                  Get.snackbar("Berhasil", "Berhasil menambah catatan default", backgroundColor: Colors.green, colorText: Colors.white);
                }else{
                  Get.snackbar("Gagal", wilayahController.responseString.value, backgroundColor: Colors.red, colorText: Colors.white);
                }
                catatanDefault.clear();
              });
            },
            child: const Text('Yes'),
          ),
        ],
      ),
    );
  }

  void _showAlertDialogEditCatatanKhusus(BuildContext context, {String? name = "Donatur", String? jadwaID}) {
    showCupertinoDialog<void>(
      context: context,
      builder: (BuildContext context) => CupertinoAlertDialog(
        title: const Text('Catatan Khusus'),
        content: Column(
          children: [
            Text('Beri catatan khusus untuk $name. Catatan ini akan tereset setiap bulan nya.'),
            const SizedBox(height: 5),
            CupertinoTextField(
              placeholder: "Catatan Khusus",
              placeholderStyle: const TextStyle(fontSize: 12, color: Colors.black26),
              controller: catatanKhusus,
            )
          ],
        ),
        actions: <CupertinoDialogAction>[
          CupertinoDialogAction(
            isDefaultAction: true,
            onPressed: () {
              catatanKhusus.clear();
              Navigator.pop(context);
            },
            child: const Text('No'),
          ),
          CupertinoDialogAction(
            isDestructiveAction: true,
            onPressed: () {
              Navigator.pop(context);
              wilayahController.updateCatatanKhususDonatur(jadwaID: jadwaID, note: catatanKhusus.text).then<dynamic>((bool value) async {
                if(value){
                  await trackingController.getRuteV2(ruteID: wilayahID.value, tanggal: selectedDate.value, type: selectedType.value).then<Null>((value){
                    if(value){
                      showDataTable(true);
                    }else{
                      showDataTable(false);
                    }
                  });
                  Get.snackbar("Berhasil", "Berhasil menambah catatan khusus", backgroundColor: Colors.green, colorText: Colors.white);
                }else{
                  Get.snackbar("Gagal", wilayahController.responseString.value, backgroundColor: Colors.red, colorText: Colors.white);
                }
                catatanKhusus.clear();
              });
            },
            child: const Text('Yes'),
          ),
        ],
      ),
    );
  }

  // Edit Lat Long yang kosong
  void _showAlertDialogEditLatLongKosong(BuildContext context, {String? name = "Donatur", String? lokasiID}) {
    showCupertinoDialog<void>(
      context: context,
      builder: (BuildContext context) => CupertinoAlertDialog(
        title: const Text('Input Lokasi Donatur'),
        content: Column(
          children: [
            Text('Lokasi donatur belum ada, mohon untuk isi point Latitude dan Longitude donatur $name'),
            const SizedBox(height: 5),
            CupertinoTextField(
              placeholder: "Latitude",
              placeholderStyle: const TextStyle(fontSize: 12, color: Colors.black26),
              controller: latitude,
            ),
            const SizedBox(height: 5),
            CupertinoTextField(
              placeholder: "Longitude",
              placeholderStyle: const TextStyle(fontSize: 12, color: Colors.black26),
              controller: longitude,
            ),
            const SizedBox(height: 5),
            CupertinoTextField(
              placeholder: "Keterangan",
              placeholderStyle: const TextStyle(fontSize: 12, color: Colors.black26),
              controller: keteranganEdit,
            ),
            const SizedBox(height: 5),
            CupertinoButton(
              padding: EdgeInsets.zero,
              child: const Row(
                children: [
                  Icon(CupertinoIcons.location, size: 20),
                  SizedBox(width: 5),
                  Expanded(child: Text("Dapatkan dari lokasi saya saat ini?", textAlign: TextAlign.start, style: TextStyle(fontSize: 12)))
                ],
              ), 
              onPressed: (){
                locationController.getLatLongMe().then((result){
                  latitude.text = locationController.latMe.value.toString();
                  longitude.text = locationController.longMe.value.toString();
                });
              }
            )
          ],
        ),
        actions: <CupertinoDialogAction>[
          CupertinoDialogAction(
            isDefaultAction: true,
            onPressed: () {
              latitude.clear();
              longitude.clear();
              Navigator.pop(context);
            },
            child: const Text('No'),
          ),
          CupertinoDialogAction(
            isDestructiveAction: true,
            onPressed: () async {
              wilayahController.editLokasiDonaturByIdLokasi(
                keterangan: keteranganEdit.text,
                lat: latitude.text,
                long: longitude.text,
                lokasiID: lokasiID
              ).then((result) {
                Navigator.pop(context);
                if(result){
                  latitude.clear();
                  longitude.clear();
                  Get.snackbar("Berhasil", wilayahController.responseString.value, backgroundColor: Colors.green, colorText: Colors.white);
                  Future.delayed(const Duration(seconds: 1), (){
                    trackingController.getRuteV2(ruteID: wilayahID.value, tanggal: selectedDate.value, type: selectedType.value);
                  });
                }else{
                  latitude.clear();
                  longitude.clear();
                  Navigator.pop(context);
                  Get.snackbar("Gagal", wilayahController.responseString.value, backgroundColor: Colors.red, colorText: Colors.white);
                }
              });
            },
            child: const Text('Yes'),
          ),
        ],
      ),
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