import 'dart:io';
import 'package:asb_app/src/components/alert/alert_success.dart';
import 'package:asb_app/src/components/global/index.dart';
import 'package:asb_app/src/components/textformfield/rounded_rectangle_text_field.dart';
import 'package:asb_app/src/controllers/tracking/tracking_controller.dart';
import 'package:asb_app/src/helpers/currency_formator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

class PerhitunganPerolehan extends StatefulWidget {
  final String? ruteName;
  final String? jadwaID;
  const PerhitunganPerolehan({super.key, this.ruteName, this.jadwaID});

  @override
  State<PerhitunganPerolehan> createState() => _PerhitunganPerolehanState();
}

class _PerhitunganPerolehanState extends State<PerhitunganPerolehan> {
  RxList imageProof = [].obs;
  RxInt total = 0.obs;
  RxBool isLoading = false.obs;
  TrackingController trackingController = Get.find();
  TextEditingController counterReceh = TextEditingController(text: '0');
  TextEditingController counter500 = TextEditingController(text: '0');
  TextEditingController counter1000 = TextEditingController(text: '0');
  TextEditingController counter2000 = TextEditingController(text: '0');
  TextEditingController counter5000 = TextEditingController(text: '0');
  TextEditingController counter10000 = TextEditingController(text: '0');
  TextEditingController counter20000 = TextEditingController(text: '0');
  TextEditingController counter50000 = TextEditingController(text: '0');
  TextEditingController counter100000 = TextEditingController(text: '0');

  int getTotal(){
     total.value = int.parse(counterReceh.text)
    + int.parse(counter500.text) 
    + int.parse(counter1000.text) 
    + int.parse(counter2000.text) 
    + int.parse(counter5000.text)
    + int.parse(counter10000.text) 
    + int.parse(counter20000.text) 
    + int.parse(counter50000.text)
    + int.parse(counter100000.text);
    return total.value;
  }

  @override
  void dispose() {
    counterReceh.dispose();
    counter500.dispose();
    counter1000.dispose();
    counter2000.dispose();
    counter5000.dispose();
    counter100000.dispose();
    counter10000.dispose();
    counter50000.dispose();
    counter20000.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          forceMaterialTransparency: true,
          backgroundColor: Colors.white,
          title: const Text("Hitung Pendapatan"),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              // Container(
              //   color: Colors.transparent,
              //   height: size.height / 3,
              //   child: SingleChildScrollView(
              //     physics: const BouncingScrollPhysics(),
              //     scrollDirection: Axis.horizontal,
              //     child: Row(
              //       children: List.generate(imageProof.length + 1, (i) {
              //         if(i != imageProof.length){
              //           return Container(
              //             width: 200,
              //             height: 200,
              //             clipBehavior: Clip.hardEdge,
              //             margin: const EdgeInsets.symmetric(horizontal: 5),
              //             decoration: BoxDecoration(
              //               color: Colors.transparent,
              //               border: Border.all(color: Colors.black45),
              //               borderRadius: BorderRadius.circular(5),
              //             ),
              //             child: Image.file(File(imageProof[i]), fit: BoxFit.cover,),
              //           );
              //         }
              //         return CupertinoButton(
              //           padding: EdgeInsets.zero,
              //           onPressed: (){
              //             pickImageFromCamera();
              //           },
              //           child: Container(
              //             width: 200,
              //             height: 200,
              //             padding: const EdgeInsets.all(15),
              //             decoration: BoxDecoration(
              //               color: Colors.transparent,
              //               border: Border.all(color: Colors.black26),
              //               borderRadius: BorderRadius.circular(5)
              //             ),
              //             child: const Icon(Icons.add_a_photo, color: Colors.black45),
              //           ),
              //         );
              //       }),
              //     ),
              //   ),
              // ),
              const Divider(),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Table(
                  columnWidths: const {
                    0: FlexColumnWidth(2),
                    1: FlexColumnWidth(4),
                    2: FlexColumnWidth(4),
                  },
                  children: [
                    TableRow(
                      children: [  
                        Column(children:[Text('Kelipatan', style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.red))]),
                        Column(children:[Text('Jumlah', style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.red))]),
                        Column(children:[Text('Total', style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.red))]),
                      ]), 
                  ],
                ),
              ),
              PriceCounter(kelipatanUang: "500", controller: counter500),
              PriceCounter(kelipatanUang: "1.000", controller: counter1000),
              PriceCounter(kelipatanUang: "2.000", controller: counter2000),
              PriceCounter(kelipatanUang: "5.000", controller: counter5000),
              PriceCounter(kelipatanUang: "10.000", controller: counter10000),
              PriceCounter(kelipatanUang: "20.000", controller: counter20000),
              PriceCounter(kelipatanUang: "50.000", controller: counter50000),
              PriceCounter(kelipatanUang: "100.000", controller: counter100000),
              CustomRoundedTextField(
                controller: counterReceh,
                keyboardType: TextInputType.number,
                label: "Receh",
                placeholder: "Inputkan total receh",
                errorText: "Inputkan 0 jika tidak ada",
              ),
              const SizedBox(height: 5),
              const Divider(),
              const SizedBox(height: 5),
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Table(
                  defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                  children: [
                    TableRow(
                      children: [  
                        Column(
                          children:[
                            OutlinedButton(
                              style: OutlinedButton.styleFrom(
                                side: const BorderSide(color: GlobalVariable.secondaryColor)
                              ),
                              onPressed: () => getTotal(),
                              child: Text('Hitung', style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.red)))]),
                        Column(children:[Obx(() => Text(formatCurrencyId.format(total.value), style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.bold))),]),
                      ]), 
                  ],
                ),
              ),
              const SizedBox(height: 20),
              
              const SizedBox(height: 30),
            ],
          ),
        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(15),
          child: Obx(() => CupertinoButton(
            color: GlobalVariable.secondaryColor,
            onPressed: trackingController.isLoading.value ? null : (){
              showAlertDialog(
                context,
                title: "Konfirmasi Perhitungan",
                content: "Apaka anda yakin mengkonfirmasi perhitungan perolehan kotak amal ${widget.ruteName}?",
                onOK: (){
                  Navigator.pop(context);
                  trackingController.hitungPerolehan(
                    jadwalID: widget.jadwaID,
                    perolehan: {
                      "receh" : int.parse(counterReceh.text),
                      "500": int.parse(counter500.text) / 500,
                      "1000": int.parse(counter1000.text) / 1000,
                      "2000": int.parse(counter2000.text) / 2000,
                      "5000": int.parse(counter5000.text) / 5000,
                      "10000": int.parse(counter10000.text) / 1000,
                      "20000": int.parse(counter20000.text) / 20000,
                      "50000": int.parse(counter50000.text) / 50000,
                      "100000": int.parse(counter100000.text) / 100000
                    } 
                  ).then((result) async {
                    if(result){
                      await trackingController.getRute();
                      alertSuccess(context, title: "Berhasil", content: trackingController.responseMessage.value, onOK: (){
                        Navigator.of(context)..pop()..pop()..pop();
                      });
                    }else{
                      Get.snackbar("Gagal", trackingController.responseMessage.value, backgroundColor: Colors.red, colorText: Colors.white);
                    }
                  });
                }
              );
            },
            child: Obx(() => trackingController.isLoading.value ? const SizedBox(height: 20, child: CircularProgressIndicator(color: Colors.white)) : const Text("Submit")), 
            ),
          ),
        ),
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
            isDestructiveAction: true,
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Tidak'),
          ),
          CupertinoDialogAction(
            isDefaultAction: true,
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
    final XFile? imagePicked = await picker.pickImage(source: ImageSource.camera, imageQuality: 50);
    if(imagePicked != null){
      setState(() {
        imageCamera = File(imagePicked.path);
        imagePath = imagePicked.path;
        imageProof.add(imagePath);
      });
    }else{
      debugPrint("Image kosong");
    }
  }
}


class PriceCounter extends StatefulWidget {
  final String? kelipatanUang;
  final TextEditingController? controller;
  final int? jumlah;
  const PriceCounter({super.key, this.kelipatanUang, this.controller, this.jumlah});

  @override
  State<PriceCounter> createState() => _PriceCounterState();
}

class _PriceCounterState extends State<PriceCounter> {
  RxInt count = 0.obs;
  RxBool isLoading = false.obs;
  RxInt result = 0.obs;
  String? removeKoma;
  TextEditingController counter = TextEditingController(text: '0');

  @override
  void initState() {
    removeKoma = widget.kelipatanUang!.replaceAll('.', '');
    super.initState();
  }
  

  @override
  void dispose() {
    counter.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Table(
        defaultVerticalAlignment: TableCellVerticalAlignment.middle,
        children: [
          TableRow( 
            children: [  
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children:[
                Text("Rp.${widget.kelipatanUang ?? 0} x ", style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.bold, textBaseline: TextBaseline.ideographic), textAlign: TextAlign.center),
              ]
            ),  
            Column(
              children:[
                TextFormField(
                  controller: counter,
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(fontWeight: FontWeight.bold, color: Colors.green),
                  onChanged: (value) {
                    if(value.isNotEmpty || value != ""){
                      count.value = int.parse(value);
                      result.value = int.parse(value) * int.parse(removeKoma!);
                      widget.controller?.text = result.value.toString();
                    }
                  },
                  decoration: const InputDecoration(
                    hintText: "0",
                    hintStyle: TextStyle(color: Colors.black38)
                  ),
                ),
              ]
            ),  
            Column(children:[Text("=", style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.bold), textAlign: TextAlign.center)]),
            Column(children:[Obx(() => Text(formatCurrencyId.format(result.value), style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.bold), textAlign: TextAlign.center))]),
          ]),    
        ],  
      ),
    );
  }
}