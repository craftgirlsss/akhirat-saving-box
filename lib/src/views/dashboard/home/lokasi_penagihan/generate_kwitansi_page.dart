import 'package:asb_app/src/components/global/index.dart';
import 'package:asb_app/src/components/textformfield/rounded_rectangle_text_field.dart';
import 'package:asb_app/src/controllers/utilities/cupertino_dialogs.dart';
import 'package:asb_app/src/controllers/wilayah/wilayah_controller.dart';
import 'package:asb_app/src/helpers/currency_formator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:intl/intl.dart';

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

  WilayahController wilayahController = Get.put(WilayahController());
  final _formKey = GlobalKey<FormState>();

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
    Future.delayed(const Duration(seconds: 1), (){
      if(widget.fromTableView != null || widget.fromTableView == true){
        wilayahController.getDonaturFinnishedByJadwalID(jadwalID: widget.jadwalID).then((result) {
          if(result){
            showTablePerolehan(true);
            name.text = wilayahController.detailDonaturFinnish.value?.data.nama ?? "Unknown Name";
            program.text = wilayahController.detailDonaturFinnish.value?.data.namaProgram ?? "Unknown Program name";
            jumlah.text = formatCurrencyId.format(wilayahController.detailDonaturFinnish.value?.data.jumlahDonasi ?? 0);
          }
        });
      }else{
        wilayahController.getDonaturFinnished(date: selectedDate.value).then((result) {
          if(result){
            namaList([]); // reset data di list temp
            for(int i = 0; i < wilayahController.donaturFinnishedModels.value!.data.length; i++){
              namaList.add(wilayahController.donaturFinnishedModels.value?.data[i].nama ?? "Unknown Name");
            }
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
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
          child: Form(
            key: _formKey,
            child: Obx(() => Column(
                children: [
                  showTablePerolehan.value ? 
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
                      ) : const SizedBox() : const SizedBox(),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.black38, width: 0.5),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        const Text('Pilih Tanggal: '),
                        Obx(() => CupertinoButton(
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
                        ),
                      ],
                    ),
                  ),
                  Obx(() => CustomRoundedTextField(controller: name, label: "Nama", errorText: "Mohon isikan nama", placeholder: wilayahController.isLoading.value ? "Mendapatkan Nama..." : "Pilih", readOnly: true, onTap: widget.fromTableView != null || widget.fromTableView == true ? null : (){
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
                            jumlah.text = wilayahController.donaturFinnishedModels.value?.data[selectedNama.value].jumlahDonasi != null ? formatCurrencyId.format(wilayahController.donaturFinnishedModels.value!.data[selectedNama.value].jumlahDonasi) : "0";
                            program.text = wilayahController.donaturFinnishedModels.value?.data[selectedNama.value].namaProgram != null ? wilayahController.donaturFinnishedModels.value!.data[selectedNama.value].namaProgram : "Unknown Program";
                          },
                          children: List<Widget>.generate(namaList.length, (int index) {
                            return Obx(() => Center(child: Text(namaList[index])));
                          }),
                        ),
                      ));
                    }),
                  ),
                  CustomRoundedTextField(controller: jumlah, label: "Jumlah", placeholder: "Inputkan jumlah", keyboardType: TextInputType.number, readOnly: true, errorText: "Mohon isikan jumlah",),
                  CustomRoundedTextField(controller: jumlahDalamBahasa, label: "Jumlah dalam kalimat bahasa indonesia", placeholder: "Inputkan jumlah", keyboardType: TextInputType.name, errorText: "Mohon isikan jumlah dalam bahasa indonesia"),
                  CustomRoundedTextField(controller: program, label: "Program", placeholder: "Pilih Donatur", readOnly: true, onTap: (){}, errorText: "Mohon isikan program"),
                  Row(
                    children: [
                      Obx(() => CupertinoCheckbox(
                          activeColor: GlobalVariable.secondaryColor,
                          shape: const CircleBorder(),
                          value: sendToDonatur.value, 
                          onChanged: (value){
                            sendToDonatur.value = !sendToDonatur.value;
                          }
                        ),
                      ),
                      const Text("Kirim ke donatur", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black38))
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          child: Obx(() => ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: GlobalVariable.secondaryColor,
                elevation: 0,
              ),
              onPressed: wilayahController.isLoading.value || namaList.length < 1 ? null : (){
                if(_formKey.currentState!.validate()){
                  print("Form validated");
                }
              },
              child: Obx(() => wilayahController.isLoading.value ? const SizedBox(width: 30, height: 30, child: CircularProgressIndicator(color: Colors.black38)) : const Text("Buat Kuitansi", style: TextStyle(color: Colors.white, fontSize: 15)))
            ),
          ),
        ),
      ),
    );
  }
}