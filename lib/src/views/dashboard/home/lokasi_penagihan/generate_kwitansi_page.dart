import 'dart:io';
import 'package:asb_app/src/components/global/index.dart';
import 'package:asb_app/src/components/textformfield/rounded_rectangle_text_field.dart';
import 'package:asb_app/src/controllers/utilities/cupertino_dialogs.dart';
import 'package:asb_app/src/controllers/wilayah/wilayah_controller.dart';
import 'package:asb_app/src/helpers/currency_formator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cached_pdfview/flutter_cached_pdfview.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:get/get.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:intl/intl.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class GenerateKwitansiPage extends StatefulWidget {
  const GenerateKwitansiPage({super.key, this.fromTableView, this.jadwalID});

  final bool? fromTableView;
  final String? jadwalID;

  @override
  State<GenerateKwitansiPage> createState() => _GenerateKwitansiPageState();
}

class _GenerateKwitansiPageState extends State<GenerateKwitansiPage> {
  TextEditingController name = TextEditingController();
  TextEditingController jumlah = TextEditingController();
  TextEditingController jumlahDalamBahasa = TextEditingController();
  TextEditingController program = TextEditingController();
  TextEditingController tanggalPembuatanKwitansi = TextEditingController();
  TextEditingController namaPengesahKwitansi = TextEditingController();

  WilayahController wilayahController = Get.put(WilayahController());
  final _formKey = GlobalKey<FormState>();

  RxBool isLoading = false.obs;
  RxString pengurusID = ''.obs;

  RxString jadwalIDForShortcut = "".obs;
  
  RxBool showPDFPreview = false.obs;

  RxBool showTablePerolehan = false.obs;

  RxString selectedDate = ''.obs;
  DateTime now = DateTime.now();

  RxList<String> programList = ["Semua"].obs;
  RxInt selectedProgram = 0.obs;

  RxList<String> namaList = ["Semua"].obs;
  RxInt selectedNama = 0.obs;

  RxBool sendToDonatur = false.obs;

  String dateFormattedYearAndMonthV2({DateTime? time}){
    return DateFormat('yyyy-MM').format(time ?? now);
  }
  

  @override
  void initState() {
    super.initState();
    selectedDate(dateFormattedYearAndMonthV2(time: now));
    Future.delayed(Duration.zero, (){
      wilayahController.getPengurus().then((result) {
        if(result){
          namaPengesahKwitansi.text = "${wilayahController.pengurusModels.value?.data[0].name} - ${wilayahController.pengurusModels.value?.data[0].jabatan}";
          pengurusID(wilayahController.pengurusModels.value?.data[0].id);
        }
      });
      if(widget.fromTableView != null || widget.fromTableView == true){
        jadwalIDForShortcut(widget.jadwalID);
        wilayahController.getDonaturFinnishedByJadwalID(jadwalID: widget.jadwalID).then((result) {
          if(result){
            showTablePerolehan(true);
            name.text = wilayahController.detailDonaturFinnish.value?.data.nama ?? "Unknown Name";
            program.text = wilayahController.detailDonaturFinnish.value?.data.namaProgram ?? "Unknown Program name";
            jumlah.text = formatCurrencyId.format(wilayahController.detailDonaturFinnish.value?.data.jumlahDonasi ?? 0);
            // if(wilayahController.detailDonaturFinnish.value?.data. != ""){
            //   jumlahDalamBahasa.text = wilayahController.detailDonaturFinnish.value?.data.namaP
            // }
          }
        });
      }
    });
  }

  @override
  void dispose() {
    name.dispose();
    jumlah.dispose();
    jumlahDalamBahasa.dispose();
    program.dispose();
    tanggalPembuatanKwitansi.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: (){FocusManager.instance.primaryFocus?.unfocus();},
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          forceMaterialTransparency: true,
          leading: IconButton(
            onPressed: (){
              Navigator.pop(context);
            }, 
            icon: const Icon(Iconsax.arrow_left_2_bold, size: 30)
          ),
          title: const Text("Buat Kuitansi"),
          actions: [
            Obx(() => isLoading.value ? const SizedBox() : widget.fromTableView == null || widget.fromTableView == false ? showPDFPreview.value ? Obx(() {
                if(wilayahController.urlPDFGenerated.value != ""){
                  return CupertinoButton(
                    onPressed: () async {
                      if(await Permission.manageExternalStorage.isGranted){
                        var dir = await getDownloadsDirectory();
                        String? fileName = wilayahController.fileName.value;
                        String? filePath = "/storage/emulated/0/Download/$fileName";
                        bool? isAvailableFile = await File(filePath).exists();
              
                        if(!isAvailableFile){
                          if(dir != null){
                            final taskID = await FlutterDownloader.enqueue(
                              allowCellular: true,
                              url: wilayahController.urlPDFGenerated.value,
                              fileName: fileName,
                              saveInPublicStorage: true,
                              savedDir: "/storage/emulated/0/Download/",
                              showNotification: true,
                            );
                            if(taskID != null){
                              await OpenFile.open(filePath);
                            }else{
                              print("Donwload gagal");
                            }
                          }else{
                            Get.snackbar("Gagal", "Gagal menemukan filepath");  
                          }
                        }else{
                          Get.snackbar("Gagal", "Kwitansi sudah ada di folder Download", backgroundColor: GlobalVariable.secondaryColor, colorText: Colors.white);
                        }
                      }else{
                        await Permission.manageExternalStorage.request();
                      }
                    },
                    child: Obx(() => wilayahController.isLoading.value ? const CupertinoActivityIndicator(color: GlobalVariable.secondaryColor) : const Text("Download File", style: TextStyle(color: GlobalVariable.secondaryColor))),
                  );
                }else{
                  Get.snackbar("Gagal", "Gagal mendownload file karena URL tidak ditemukan", backgroundColor: GlobalVariable.secondaryColor, colorText: Colors.white);
                }
                return Container();
              }) : const SizedBox() : const SizedBox(),
            )
          ],
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
          child: Form(
            key: _formKey,
            child: Column(
                children: [
                  widget.fromTableView == null || widget.fromTableView == false ? const SizedBox() : Container(
                    margin: const EdgeInsets.symmetric(horizontal: 8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.black38, width: 0.5),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        widget.fromTableView == null || widget.fromTableView == false ? const Text('Pilih Tanggal: ') : const SizedBox(),
                         widget.fromTableView == null || widget.fromTableView == false ? Obx(() => CupertinoButton(
                            padding: EdgeInsets.zero,
                            onPressed: wilayahController.isLoading.value || widget.fromTableView != null || widget.fromTableView == true ? null : () {
                              customCupertinoDialogActionSheet(context,
                                child: CupertinoDatePicker(
                                  mode: CupertinoDatePickerMode.monthYear,
                                  initialDateTime: now,
                                  onDateTimeChanged: (value) {
                                    selectedDate.value = dateFormattedYearAndMonthV2(time: value);
                                    wilayahController.getDonaturFinnished(date: selectedDate.value).then((result) {
                                      if(result){
                                        namaList([]); // reset data di list temp
                                        for(int i = 0; i < wilayahController.donaturFinnishedModels.value!.data.length; i++){
                                          namaList.add(wilayahController.donaturFinnishedModels.value?.data[i].nama ?? "Unknown Name");
                                        }
                                        if(namaList.length < 1){
                                          name.text = "";
                                          jumlah.text = "";
                                          program.text = "";
                                          jumlahDalamBahasa.text = "";  
                                        }else{
                                          showTablePerolehan(true);
                                          jadwalIDForShortcut(wilayahController.donaturFinnishedModels.value!.data[0].jadwalID);
                                          name.text = wilayahController.donaturFinnishedModels.value!.data[0].nama;
                                          jumlah.text = wilayahController.donaturFinnishedModels.value!.data[0].jumlahDonasi.toString();
                                          program.text = wilayahController.donaturFinnishedModels.value!.data[0].namaProgram;
                                          jumlahDalamBahasa.text = wilayahController.donaturFinnishedModels.value!.data[0].terbilang!;
                                        }
                                      }else{
                                        namaList([]);
                                        name.text = "";
                                        jumlah.text = "";
                                        program.text = "";
                                        jumlahDalamBahasa.text = "";
                                      }
                                    });
                                  },
                                  maximumYear: now.year,
                                  minimumYear: now.year - 10,
                                )
                              );
                            },
                            child: Obx(() => Text(selectedDate.value, style: const TextStyle(color: GlobalVariable.secondaryColor, fontWeight: FontWeight.bold, fontSize: 14))),
                          ),
                        ) : const SizedBox(),
                      ],
                    ),
                  ),
                  Obx(() => isLoading.value ? const SizedBox() : widget.fromTableView != null || widget.fromTableView == true ? showTablePerolehan.value ? 
                      widget.fromTableView == true ?
                        Column(
                          children: [
                            const Text("Perolehan", style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
                            const SizedBox(height: 5),
                            Container(
                              margin: const EdgeInsets.symmetric(horizontal: 8),
                              width: size.width,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(7),
                                border: Border.all(color: Colors.black26, width: 0.5),
                              ),
                              child: Obx(() => wilayahController.isLoading.value ? const SizedBox() : DataTable(
                                  columns: const <DataColumn>[
                                    DataColumn(
                                      label: Expanded(child: Text('Satuan', style: TextStyle(fontStyle: FontStyle.italic))),
                                    ),
                                    DataColumn(
                                      label: Expanded(child: Text('Jumlah', style: TextStyle(fontStyle: FontStyle.italic))),
                                    ),
                                    DataColumn(
                                      label: Expanded(child: Text('Total', style: TextStyle(fontStyle: FontStyle.italic))),
                                    ),
                                  ],
                                  rows: List.generate(wilayahController.detailDonaturFinnish.value!.data.summary.length, (i) {
                                    return DataRow(
                                      cells: [
                                        DataCell(Text(wilayahController.detailDonaturFinnish.value!.data.summary[i][0].toString())),
                                        DataCell(Text(wilayahController.detailDonaturFinnish.value!.data.summary[i][1].toString())),
                                        DataCell(Text(formatCurrencyId.format(wilayahController.detailDonaturFinnish.value!.data.summary[i][2]))),
                                      ]
                                    );
                                  })
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                            const Divider(height: 0.5),
                            const SizedBox(height: 10),
                          ],
                        ) : wilayahController.donaturFinnishedModels.value?.data.length != 0 ? Column(
                          children: [
                            const Text("Perolehan", style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
                            const SizedBox(height: 5),
                            Container(
                              margin: const EdgeInsets.symmetric(horizontal: 8),
                              width: size.width,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(7),
                                border: Border.all(color: Colors.black26, width: 0.5),
                              ),
                              child: DataTable(
                                columns: const <DataColumn>[
                                  DataColumn(
                                    label: Expanded(child: Text('Satuan', style: TextStyle(fontStyle: FontStyle.italic))),
                                  ),
                                  DataColumn(
                                    label: Expanded(child: Text('Jumlah', style: TextStyle(fontStyle: FontStyle.italic))),
                                  ),
                                  DataColumn(
                                    label: Expanded(child: Text('Total', style: TextStyle(fontStyle: FontStyle.italic))),
                                  ),
                                ],
                                rows: List.generate(wilayahController.donaturFinnishedModels.value!.data[selectedNama.value].summary.length, (i) {
                                  return DataRow(
                                    cells: [
                                      DataCell(Text(wilayahController.donaturFinnishedModels.value!.data[selectedNama.value].summary[i][0].toString())),
                                      DataCell(Text(wilayahController.donaturFinnishedModels.value!.data[selectedNama.value].summary[i][1].toString())),
                                      DataCell(Text(formatCurrencyId.format(wilayahController.donaturFinnishedModels.value!.data[selectedNama.value].summary[i][2]))),
                                    ]
                                  );
                                })
                              ),
                            ),
                            const SizedBox(height: 10),
                            const Divider(height: 0.5),
                            const SizedBox(height: 10),
                          ],
                        ) : const SizedBox() : const SizedBox() : const SizedBox(),
                  ),
                  widget.fromTableView == null || widget.fromTableView == false 
                  ? CustomRoundedTextField(controller: name, label: "Nama", placeholder: "Mohon inputkan nama", keyboardType: TextInputType.name, errorText: "Mohon inputkan nama",)
                  : Obx(() => CustomRoundedTextField(controller: name, label: "Nama", errorText: "Mohon pilih nama", placeholder: wilayahController.isLoading.value ? "Mendapatkan Nama..." : "Pilih", readOnly: true, onTap: widget.fromTableView != null || widget.fromTableView == true ? null : (){
                      customCupertinoDialog(context, child: Obx(() => CupertinoPicker(
                          magnification: 1.22,
                          squeeze: 1.2,
                          useMagnifier: true,
                          itemExtent: 32,
                          scrollController: FixedExtentScrollController(initialItem: selectedNama.value),
                          onSelectedItemChanged: (int selectedItem) {
                            selectedNama.value = selectedItem;
                            name.text = namaList[selectedNama.value];
                            showTablePerolehan(true);
                            if(wilayahController.donaturFinnishedModels.value?.data[selectedNama.value].terbilang != ""){
                              jumlahDalamBahasa.text = wilayahController.donaturFinnishedModels.value!.data[selectedNama.value].terbilang!;
                            }else{
                              jumlahDalamBahasa.text = "";
                            }
                            jadwalIDForShortcut(wilayahController.donaturFinnishedModels.value?.data[selectedNama.value].jadwalID);
                            jumlah.text = wilayahController.donaturFinnishedModels.value?.data[selectedNama.value].jumlahDonasi != null ? formatCurrencyId.format(wilayahController.donaturFinnishedModels.value!.data[selectedNama.value].jumlahDonasi) : "0";
                            program.text = wilayahController.donaturFinnishedModels.value?.data[selectedNama.value].namaProgram != null ? wilayahController.donaturFinnishedModels.value!.data[selectedNama.value].namaProgram : "Unknown Program";
                          },
                          children: List<Widget>.generate(namaList.length, (int index) {
                            return Obx(() => Center(child: Text(namaList[index], style: const TextStyle(fontSize: 14))));
                          }),
                        ),
                      ));
                    }),
                  ),
                  CustomRoundedTextField(controller: jumlah, label: "Jumlah", placeholder: "Inputkan jumlah", keyboardType: TextInputType.number, readOnly: widget.fromTableView == null || widget.fromTableView == false ? false : true, errorText: "Mohon isikan jumlah",),
                  // CustomRoundedTextField(controller: jumlahDalamBahasa, label: "Jumlah dalam kalimat bahasa indonesia", placeholder: "Inputkan jumlah", keyboardType: TextInputType.name, errorText: "Mohon isikan jumlah dalam bahasa indonesia"),
                  CustomRoundedTextField(controller: program, label: "Program", placeholder: "Mohon inputkan nama program", readOnly: widget.fromTableView == null || widget.fromTableView == false ? false : true, errorText: "Mohon isikan program", keyboardType: TextInputType.name),
                  // Pengesah Kwitansi
                  CustomRoundedTextField(controller: namaPengesahKwitansi, label: "Nama Pengesah Kwitansi", placeholder: "Mohon pilih nama pengesah", readOnly: true, errorText: "Mohon isikan nama pengesah", onTap: (){
                    customCupertinoDialog(context, child: Obx(
                      () => CupertinoPicker.builder(
                        itemExtent: 32,
                        childCount: wilayahController.pengurusModels.value?.data.length ?? 0,
                        onSelectedItemChanged: (value) {
                          namaPengesahKwitansi.text = "${wilayahController.pengurusModels.value?.data[value].name} - ${wilayahController.pengurusModels.value?.data[value].jabatan}";
                          pengurusID(wilayahController.pengurusModels.value?.data[value].id);
                        }, 
                        itemBuilder: (context, index) {
                          return Center(child: Text("${wilayahController.pengurusModels.value?.data[index].name} - ${wilayahController.pengurusModels.value?.data[index].jabatan}", style: const TextStyle(fontSize: 14)));
                        },
                      ),
                    ));
                  }),
                  
                  //Preview PDF Manual after post to API
                  widget.fromTableView == null || widget.fromTableView == false 
                    ? Obx(() {
                      if(showPDFPreview.value){
                        return SizedBox(
                          width: size.width,
                          height: size.height / 3,
                          child: const PDF().cachedFromUrl(wilayahController.urlPDFGenerated.value));
                      }
                      return const SizedBox();
                    })
                    : const SizedBox()
                ],
              ),
            ),
          ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          child: Obx(() => 
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: GlobalVariable.secondaryColor,
                elevation: 0,
              ),
              onPressed: wilayahController.isLoading.value || namaList.length < 1 ? null : () async {
                var status = await Permission.storage.status;
                if(status != PermissionStatus.granted){
                  await Permission.storage.request();
                }else if (status == PermissionStatus.permanentlyDenied) {
                  openAppSettings();
                }else{
                  print(status);
                }
                if(_formKey.currentState!.validate()){
                  if(widget.fromTableView == null || widget.fromTableView == false){
                    if(await wilayahController.generateKwitansiManual(
                      name: name.text,
                      jumlah: jumlah.text,
                      program: program.text,
                      pengurusID: pengurusID.value
                    )){
                      showPDFPreview(true);
                    }else{
                      showPDFPreview(false);
                    }
                  }else{
                    if(await wilayahController.generateKwitansi(
                      terbilang: jumlahDalamBahasa.text,
                      jadwalID: jadwalIDForShortcut.value,
                      pengurusID: pengurusID.value
                    )){
                      if(wilayahController.urlPDFGenerated.value != ""){
                        if(await Permission.manageExternalStorage.isGranted){
                          var dir = await getDownloadsDirectory();
                          String? fileName = wilayahController.fileName.value;
                          String? filePath = "/storage/emulated/0/Download/$fileName";
                          bool? isAvailableFile = await File(filePath).exists();

                          if(!isAvailableFile){
                            if(dir != null){
                              final taskID = await FlutterDownloader.enqueue(
                                allowCellular: true,
                                url: wilayahController.urlPDFGenerated.value,
                                fileName: fileName,
                                saveInPublicStorage: true,
                                savedDir: "/storage/emulated/0/Download/",
                                showNotification: true,
                              );
                              if(taskID != null){
                                await OpenFile.open(filePath);
                              }else{
                                print("Donwload gagal");
                              }
                            }else{
                              Get.snackbar("Gagal", "Gagal menemukan filepath");  
                            }
                          }else{
                            Get.snackbar("Gagal", "Kwitansi sudah ada di folder Download", backgroundColor: GlobalVariable.secondaryColor, colorText: Colors.white);
                          }
                        }else{
                          await Permission.manageExternalStorage.request();
                        }
                      }else{
                        Get.snackbar("Gagal", "URL PDF tidak ditemukan", backgroundColor: GlobalVariable.secondaryColor, colorText: Colors.white);
                      }
                    }else{
                      Get.snackbar("Gagal", wilayahController.responseString.value, backgroundColor: Colors.red, colorText: Colors.white);
                    }
                  }
                }
              },
              child: Obx(() => wilayahController.isLoading.value ? const SizedBox(width: 30, height: 30, child: CircularProgressIndicator(color: Colors.black38)) : Text(widget.fromTableView == null || widget.fromTableView == false ? "Lihat Preview Kwitansi" : "Buat Kuitansi", style: const TextStyle(color: Colors.white, fontSize: 15)))
            ),
          ),
        ),
      ),
    );
  }
}