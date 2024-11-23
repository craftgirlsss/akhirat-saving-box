import 'package:asb_app/src/components/global/index.dart';
import 'package:asb_app/src/components/textsyle/index.dart';
import 'package:asb_app/src/controllers/utilities/timeline_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:icons_plus/icons_plus.dart';

class TambahTimelineItem extends StatefulWidget {
  const TambahTimelineItem({super.key});

  @override
  State<TambahTimelineItem> createState() => _TambahTimelineItemState();
}

class _TambahTimelineItemState extends State<TambahTimelineItem> {
  final globalTextStyle = GlobalTextStyle();
  final globalVariable = GlobalVariable();
  final _formKey = GlobalKey<FormState>();
  TextEditingController prosesUtamaController = TextEditingController();
  List<TextEditingController> controllersSubProsesUtama = [];
  TimelineController timelineController = Get.find();
  List tempItemSubProses = [];
  int j = 0;

  @override
  void dispose() {
    prosesUtamaController.dispose();
    for (var controller in controllersSubProsesUtama) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text("Tambah Timeline", style: globalTextStyle.defaultTextStyleBold(color: Colors.black)),
          backgroundColor: Colors.white,
        ),
        body: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  onEditingComplete: (){
                    FocusManager.instance.primaryFocus?.unfocus();
                    setState(() {});
                  },
                  controller: prosesUtamaController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Mohon inputkan nama proses utama';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    enabledBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.black)),
                    focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.black)),
                    label: Text("Tambah Proses Utama", style: globalTextStyle.defaultTextStyleMedium(color: Colors.black, fontSize: 14)),
                    prefixIcon: const Icon(MingCute.process_line, color: Colors.black)
                  ),
                ),
                if(controllersSubProsesUtama.length < 4)
                  for(int i = 0; i<controllersSubProsesUtama.length; i++)
                    Padding(
                      padding: const EdgeInsets.only(left: 15),
                      child: TextFormField(
                        autofocus: true,
                        onEditingComplete: (){
                          FocusManager.instance.primaryFocus?.unfocus();
                          setState(() {
                            controllersSubProsesUtama.add(TextEditingController());
                          });
                          if(j == 0){
                            for(int i = 0; i < controllersSubProsesUtama.length; i++){
                              tempItemSubProses.add(controllersSubProsesUtama[i].text);
                            }
                            j += 1;
                          }else{
                            for(j; j < controllersSubProsesUtama.length; j++){
                              tempItemSubProses.add(controllersSubProsesUtama[j].text);
                            }
                            j += 1;
                          }
                        },
                        controller: controllersSubProsesUtama[i],
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Mohon inputkan nama sub proses';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          enabledBorder: const UnderlineInputBorder(borderSide: BorderSide(color: GlobalVariable.secondaryColor)),
                          label: Text("Tambah Sub Proses", style: globalTextStyle.defaultTextStyleMedium(color: GlobalVariable.secondaryColor, fontSize: 16)),
                          prefixIcon: const Icon(MingCute.process_fill, color: GlobalVariable.secondaryColor)
                        ),
                      ),
                    )
                else
                  for(int i = 0; i<controllersSubProsesUtama.length; i++)
                    Padding(
                      padding: const EdgeInsets.only(left: 15),
                      child: TextFormField(
                        autofocus: true,
                        controller: controllersSubProsesUtama[i],
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Mohon inputkan nama sub proses';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          enabledBorder: const UnderlineInputBorder(borderSide: BorderSide(color: GlobalVariable.secondaryColor)),
                          label: Text("Tambah Sub Proses", style: globalTextStyle.defaultTextStyleMedium(color: GlobalVariable.secondaryColor, fontSize: 16)),
                          prefixIcon: const Icon(MingCute.process_fill, color: GlobalVariable.secondaryColor)
                        ),
                      ),
                    ),

                const SizedBox(height: 10),
                SizedBox(
                  height: 30,
                  child: ElevatedButton(
                    onPressed: (){
                      if(controllersSubProsesUtama.length < 4){
                        setState(() {
                          controllersSubProsesUtama.add(TextEditingController());
                        });
                      }
                    }, 
                    style: ElevatedButton.styleFrom(
                      backgroundColor: GlobalVariable.secondaryColor,
                      elevation: 0
                    ),
                    child: Text("Tambah Sub Proses", style: globalTextStyle.defaultTextStyleMedium(color: Colors.white))
                  ),
                )
              ],
            ),
          ),
        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(20),
          child: Obx(() =>  ElevatedButton(
              onPressed: timelineController.isLoading.value ? null : (){
                // print(tempItemSubProses);
                // print(j);
              }, 
              style: ElevatedButton.styleFrom(
                backgroundColor: GlobalVariable.secondaryColor,
                elevation: 0
              ),
              child: Text("Simpan", style: globalTextStyle.defaultTextStyleBold(color: Colors.white))
            ),
          ),
        ),
      ),
    );
  }
}