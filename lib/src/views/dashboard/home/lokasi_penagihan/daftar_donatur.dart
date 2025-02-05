import 'package:asb_app/src/components/global/index.dart';
import 'package:asb_app/src/controllers/tracking/tracking_controller.dart';
import 'package:asb_app/src/controllers/wilayah/wilayah_controller.dart';
import 'package:asb_app/src/views/dashboard/home/lokasi_penagihan/detail_lokasi.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class DaftarDonaturH extends StatefulWidget {
  const DaftarDonaturH({super.key});

  @override
  State<DaftarDonaturH> createState() => _DaftarDonaturHState();
}

class _DaftarDonaturHState extends State<DaftarDonaturH> {
  final ScrollController _firstController = ScrollController();
  WilayahController wilayahController = Get.put(WilayahController());
  TrackingController trackingController = Get.find();
  RxString wilayahID = ''.obs;
  DateTime now = DateTime.now();
  RxString selectedDate = ''.obs;

  RxInt selectedRute = 0.obs;
  RxInt selectedTipe = 0.obs;
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

  List<DonaturClass> donaturClass = <DonaturClass>[];
  DonaturDataSource? donaturDataSource;

  @override
  void initState() {
    super.initState();
    wilayahController.getWilayah().then((result){
      if(result){
        daftarRute.value = [];
        for(int i = 0; i<wilayahController.wilayahModels.value!.data.length; i++){
          daftarRute.add(wilayahController.wilayahModels.value!.data[i].nama);
        }
        setState(() {});
        selectedDate.value = dateFormattedYearAndMonth(time: now);
        wilayahID.value = wilayahController.wilayahModels.value!.data[0].id;
        trackingController.getRuteV2(ruteID: wilayahID.value, tanggal: dateFormattedYearAndMonthV2(time: now)).then((api){
          print("ini result API => $api");
          if(!api){
            Get.snackbar("Gagal", trackingController.responseMessage.value, backgroundColor: Colors.red, colorText: Colors.white);
          }else{
            if(trackingController.listRuteTerbaru.value != null){
              donaturClass = List.generate(trackingController.listRuteTerbaru.value?.data?.length ?? 0, (i) {
                return DonaturClass(
                  idDonatur: trackingController.listRuteTerbaru.value?.data?[i].id,
                  id: trackingController.listRuteTerbaru.value?.data?[i].kode,
                  name: trackingController.listRuteTerbaru.value?.data?[i].nama,
                  nohp: trackingController.listRuteTerbaru.value?.data?[i].telepon,
                  alamat: trackingController.listRuteTerbaru.value?.data?[i].alamat,
                  catatanKhusus: trackingController.listRuteTerbaru.value?.data?[i].catatanKhusus == null || trackingController.listRuteTerbaru.value?.data?[i].catatanKhusus == "" ? "Kosong" : trackingController.listRuteTerbaru.value?.data?[i].catatanKhusus,
                  jam: trackingController.listRuteTerbaru.value?.data?[i].jam,
                  h1: trackingController.listRuteTerbaru.value?.data?[i].h1,
                  h2: trackingController.listRuteTerbaru.value?.data?[i].h2,
                  h: trackingController.listRuteTerbaru.value?.data?[i].h,
                  rapel: trackingController.listRuteTerbaru.value?.data?[i].rapel,
                  jadwalRapel: trackingController.listRuteTerbaru.value?.data?[i].rapel,
                  tanggal: trackingController.listRuteTerbaru.value?.data?[i].tanggalPengambilan,
                );
              });
              setState(() {
                donaturDataSource = DonaturDataSource(employeeData: donaturClass);
              });
            }
          }
        });
        /*
        wilayahController.getDonaturByWilayahID(wilayahID: wilayahID.value).then((value){
          if(!result){
            Get.snackbar("Gagal", wilayahController.responseString.value, backgroundColor: Colors.red, colorText: Colors.white);
          }else{
            if(wilayahController.daftarDonatur.value != null){
              donaturClass = List.generate(wilayahController.daftarDonatur.value?.data.length ?? 0, (i) {
                return DonaturClass(
                  idDonatur: wilayahController.daftarDonatur.value?.data[i].id,
                  id: wilayahController.daftarDonatur.value?.data[i].kode,
                  name: wilayahController.daftarDonatur.value?.data[i].nama,
                  nohp: wilayahController.daftarDonatur.value?.data[i].telepon
                );
              });
              donaturDataSource = DonaturDataSource(employeeData: donaturClass);
            }
          }
        });
        */
      }else{
        Get.snackbar("Gagal", wilayahController.responseString.value, backgroundColor: Colors.red, colorText: Colors.white);
      }
    });
  }


  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
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
        title: const Text("Daftar Donatur", style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            child: SizedBox(
              height: 35,
              child: Obx(() => ElevatedButton.icon(
                onPressed: wilayahController.isLoading.value ? null : (){},
                style: ElevatedButton.styleFrom(
                  backgroundColor: GlobalVariable.secondaryColor,
                  elevation: 0
                ),
                label: const Text("Selesai", style: TextStyle(color: Colors.white)),
                icon: const Icon(Icons.done, color: Colors.white), 
                ),
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: RawScrollbar(
          thumbVisibility: true,
          thickness: 15,
          radius: const Radius.circular(10),
          controller: _firstController,
          child: ListView(
            controller: _firstController,
            children: [
              const SizedBox(height: 10),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
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
                              initialItem: selectedRute.value,
                            ),
                            onSelectedItemChanged: (int selectedItem) {
                                selectedRute.value = selectedItem;
                            },
                            children: List<Widget>.generate(daftarRute.length, (int index) {
                              return Center(child: Text(daftarRute[index], style: const TextStyle(color: GlobalVariable.secondaryColor)));
                            }),
                          ),
                        ),
                        child: Obx(() => Text(daftarRute[selectedRute.value], style: const TextStyle(color: GlobalVariable.secondaryColor, fontWeight: FontWeight.bold, fontSize: 14))),
                      ),
                    ),
                  ],
                ),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
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
                                      initialItem: selectedTipe.value,
                                    ),
                                    onSelectedItemChanged: (int selectedItem) {
                                      selectedTipe.value = selectedItem;
                                    },
                                    children: List<Widget>.generate(daftarTipe.length, (int index) {
                                      return Center(child: Text(daftarTipe[index], style: const TextStyle(color: GlobalVariable.secondaryColor)));
                                    }),
                                  ),
                                ),
                                child: Obx(() => Text(daftarTipe[selectedTipe.value], style: const TextStyle(color: GlobalVariable.secondaryColor, fontWeight: FontWeight.bold, fontSize: 14))),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                
                    Expanded(
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
                                      selectedDate.value = dateFormattedYearAndMonth(time: value);                                
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
                    ),
                  ],
                ),
              ),
        
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Obx(() => wilayahController.isLoading.value ? SizedBox(
                  width: size.width,
                  height: size.height / 1.2,
                  child: const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(color: GlobalVariable.secondaryColor),
                      SizedBox(height: 10),
                      Text("Mendapatkan Donatur...")
                        ],
                      ),
                    ) : Obx(() => wilayahController.daftarDonatur.value?.data.length == 0 ? SizedBox(
                      width: size.width,
                      height: size.height / 1.2,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Image.asset('assets/images/no_data.png', width: size.width / 2),
                          const SizedBox(height: 10),
                          const Text("Tidak ada donatur")
                        ],
                      ),
                    ) : Container(
                      height: size.height/1.3,
                      width: size.width,
                      decoration: const BoxDecoration(
                        border: Border(right: BorderSide(color: Colors.black12), bottom: BorderSide(color: Colors.black12))
                      ),
                      child: donaturDataSource == null ? const SizedBox() : SfDataGrid(
                        allowSorting: true,
                        sortingGestureType: SortingGestureType.tap,
                        source: donaturDataSource!,
                        frozenColumnsCount: 2,
                        onCellTap: (details) {
                          if(details.rowColumnIndex.rowIndex != 0) {
                            // int selectedRowIndex = details.rowColumnIndex.rowIndex - 1;
                            // var row = donaturDataSource?.effectiveRows.elementAt(selectedRowIndex);
                            // print(donaturClass[details.rowColumnIndex.rowIndex].idDonatur);
                          }
                        },
                        columns: <GridColumn>[
                          GridColumn(
                            columnName: 'id',
                            label: Container(
                              padding: const EdgeInsets.all(16.0),
                              alignment: Alignment.center,
                              child: const Text('Kode', style: TextStyle(fontWeight: FontWeight.bold))
                            )
                          ),
                          GridColumn(
                            columnName: 'name',
                            label: Container(
                              padding: const EdgeInsets.all(8.0),
                              alignment: Alignment.center,
                              child: const Text('Nama', style: TextStyle(fontWeight: FontWeight.bold))
                            )
                          ),
                          GridColumn(
                            columnName: 'alamat',
                            label: Container(
                              padding: const EdgeInsets.all(8.0),
                              alignment: Alignment.center,
                              child: const Text('Alamat', overflow: TextOverflow.ellipsis, style: TextStyle(fontWeight: FontWeight.bold))
                            )
                          ),
                          GridColumn(
                            columnName: 'nohp',
                            label: Container(
                              padding: const EdgeInsets.all(8.0),
                              alignment: Alignment.center,
                              child: const Text('No. HP', style: TextStyle(fontWeight: FontWeight.bold))
                            )
                          ),
                          GridColumn(
                            columnName: 'jam',
                            label: Container(
                              padding: const EdgeInsets.all(8.0),
                              alignment: Alignment.center,
                              child: const Text('Jam', style: TextStyle(fontWeight: FontWeight.bold))
                            )
                          ),
                              
                          GridColumn(
                            columnName: 'hari',
                            label: Container(
                              padding: const EdgeInsets.all(8.0),
                              alignment: Alignment.center,
                              child: const Text('Hari', style: TextStyle(fontWeight: FontWeight.bold))
                            )
                          ),
                          GridColumn(
                            columnName: 'tanggal',
                            label: Container(
                              padding: const EdgeInsets.all(8.0),
                              alignment: Alignment.center,
                              child: const Text('Tanggal', style: TextStyle(fontWeight: FontWeight.bold))
                            )
                          ),
                              
                          GridColumn(
                            columnName: 'h2',
                            label: Container(
                              padding: const EdgeInsets.all(8.0),
                              alignment: Alignment.center,
                              child: const Text('H-2', style: TextStyle(fontWeight: FontWeight.bold))
                            )
                          ),
                          GridColumn(
                            columnName: 'h1',
                            label: Container(
                              padding: const EdgeInsets.all(8.0),
                              alignment: Alignment.center,
                              child: const Text('H-1', style: TextStyle(fontWeight: FontWeight.bold))
                            )
                          ),
                              
                          GridColumn(
                            columnName: 'h',
                            label: Container(
                              padding: const EdgeInsets.all(8.0),
                              alignment: Alignment.center,
                              child: const Text('H', style: TextStyle(fontWeight: FontWeight.bold))
                            )
                          ),
                          GridColumn(
                            columnName: 'rapel',
                            label: Container(
                              padding: const EdgeInsets.all(8.0),
                              alignment: Alignment.center,
                              child: const Text('Rapel', style: TextStyle(fontWeight: FontWeight.bold))
                            )
                          ),
                
                          GridColumn(
                            columnName: 'jadwal_rapel',
                            label: Container(
                              padding: const EdgeInsets.all(8.0),
                              alignment: Alignment.center,
                              child: const Text('Jadwal Rapel', style: TextStyle(fontWeight: FontWeight.bold))
                            )
                          ),
                
                          GridColumn(
                            columnName: 'foto_penukaran',
                            label: Container(
                              padding: const EdgeInsets.all(8.0),
                              alignment: Alignment.center,
                              child: const Text('Foto Penukaran', style: TextStyle(fontWeight: FontWeight.bold))
                            )
                          ),
                
                          GridColumn(
                            columnName: 'lokasi_terakhir',
                            label: Container(
                              padding: const EdgeInsets.all(8.0),
                              alignment: Alignment.center,
                              child: const Text('Lokasi Terakhir', style: TextStyle(fontWeight: FontWeight.bold))
                            )
                          ),
                
                          GridColumn(
                            columnName: 'catatan_khusus',
                            label: Container(
                              padding: const EdgeInsets.all(8.0),
                              alignment: Alignment.center,
                              child: const Text('Catatan Khusus', style: TextStyle(fontWeight: FontWeight.bold))
                            )
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


class DonaturClass {
  DonaturClass({this.id, this.name, this.alamat, this.nohp, this.jam, this.hari, this.tanggal, this.h2, this.h1, this.h, this.rapel, this.idDonatur, this.jadwalRapel, this.fotoPenukaran, this.lokasiTerakhir, this.catatanKhusus});
  final String? id;
  final String? idDonatur;
  final String? name;
  final String? alamat;
  final String? nohp;
  final String? jam;
  final String? hari;
  final String? tanggal;
  final bool? h2;
  final bool? h1;
  final bool? h;
  final bool? rapel;
  final bool? jadwalRapel;
  final String? fotoPenukaran;
  final String? lokasiTerakhir;
  final String? catatanKhusus;
}

class DonaturDataSource extends DataGridSource {
  
  DonaturDataSource({required List<DonaturClass> employeeData}) {
    _employeeData = employeeData.map<DataGridRow>((e) => DataGridRow(
      cells: [
        DataGridCell<String>(columnName: 'id', value: e.id),
        DataGridCell<String>(columnName: 'name', value: e.name),
        DataGridCell<String>(columnName: 'alamat', value: e.alamat),
        DataGridCell<String>(columnName: 'nohp', value: e.nohp),
        DataGridCell<String>(columnName: 'jam', value: e.jam),
        DataGridCell<String>(columnName: 'hari', value: e.hari),
        DataGridCell<String>(columnName: 'tanggal', value: e.tanggal),
        DataGridCell<bool>(columnName: 'h2', value: e.h2),
        DataGridCell<bool>(columnName: 'h1', value: e.h1),
        DataGridCell<bool>(columnName: 'h', value: e.h),
        DataGridCell<bool>(columnName: 'rapel', value: e.rapel),
        DataGridCell<bool>(columnName: 'jadwal_rapel', value: e.jadwalRapel),
        DataGridCell<String>(columnName: 'foto_penukaran', value: e.fotoPenukaran),
        DataGridCell<String>(columnName: 'lokasi_terakhir', value: e.lokasiTerakhir),
        DataGridCell<String>(columnName: 'catatan_khusus', value: e.catatanKhusus),
      ]))
    .toList();
  }

  List<DataGridRow> _employeeData = [];

  @override
  List<DataGridRow> get rows => _employeeData;

  @override
  DataGridRowAdapter? buildRow(DataGridRow row) {
    return DataGridRowAdapter(
      cells: row.getCells().map<Widget>((e) {
        if(e.columnName == 'id' || e.columnName == "name"){
          return LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
            return CupertinoButton(
              onPressed: (){
                Get.to(() => const DetailLokasi());
              },
              padding: EdgeInsets.zero,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const SizedBox(width: 10),
                  Expanded(child: Text(e.value.toString(), style: const TextStyle(color: GlobalVariable.secondaryColor, fontWeight: FontWeight.bold, fontSize: 13), textAlign: TextAlign.start, maxLines: 2)),
                ],
              ));
            }
          );
        }
        if(e.columnName == 'h2'){
          return CupertinoButton(
            onPressed: (){
              print("Lonceng H2 ditekan dengan row ${row.getCells()[0].value}");
            },
            padding: EdgeInsets.zero,
            child: const Icon(EvaIcons.bell_outline, color: GlobalVariable.secondaryColor));
        }

        if(e.columnName == 'h1'){
          return CupertinoButton(
            onPressed: (){
              print("Lonceng H1 ditekan dengan row ${row.getCells()[0].value}");
            },
            padding: EdgeInsets.zero,
            child: const Icon(EvaIcons.bell_outline, color: GlobalVariable.secondaryColor));
        }
        
        if(e.columnName == 'h'){
          return CupertinoButton(
            onPressed: (){
              print("Lonceng H ditekan dengan row ${row.getCells()[0].value}");
            },
            padding: EdgeInsets.zero,
            child: const Icon(EvaIcons.bell_outline, color: GlobalVariable.secondaryColor));
        }

        if(e.columnName == 'rapel'){
          return CupertinoButton(
            onPressed: (){
              print("Lonceng rapel ditekan dengan row ${row.getCells()[0].value}");
            },
            padding: EdgeInsets.zero,
            child: const Icon(EvaIcons.bell_outline, color: GlobalVariable.secondaryColor));
        }
        
        if(e.columnName == 'jadwal_rapel'){
          return CupertinoButton(
            onPressed: (){
              print("Lonceng Jadwal Rapel ditekan dengan row ${row.getCells()[0].value}");
            },
            padding: EdgeInsets.zero,
            child: const Icon(EvaIcons.bell_outline, color: GlobalVariable.secondaryColor));
        }
        return Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.all(8),
          child: Text(e.value.toString()));
    }).toList());
  }

  @override
  Widget? buildGroupCaptionCellWidget(RowColumnIndex rowColumnIndex, String summaryValue) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 15),
      child: Text(summaryValue)
    );
  }
}
