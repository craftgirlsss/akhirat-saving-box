import 'package:asb_app/src/components/global/index.dart';
import 'package:asb_app/src/components/textsyle/index.dart';
import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';

class AddTimelines extends StatefulWidget {
  const AddTimelines({super.key});

  @override
  State<AddTimelines> createState() => _AddTimelinesState();
}

class _AddTimelinesState extends State<AddTimelines> {
  List<TextEditingController> controllersProsesUtama = [TextEditingController()];
  List<TextEditingController> controllersSubProsesUtama = [TextEditingController()];

  final globalTextStyle = GlobalTextStyle();
  final globalVariable = GlobalVariable();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    for (var controller in controllersProsesUtama) {
      controller.dispose();
    }

    for (var controller in controllersSubProsesUtama) {
      controller.dispose();
    }
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
          iconTheme: const IconThemeData(color: Colors.white),
          title: Text("Tambah Timeline", style: globalTextStyle.defaultTextStyleBold(color: Colors.white)),
          backgroundColor: GlobalVariable.secondaryColor,
        ),
        body: SizedBox(
          width: size.width,
          height: size.height,
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(15),
                margin: const EdgeInsets.all(10),
                width: size.height / 2,
                height: size.height / 3,
                constraints: BoxConstraints(
                  maxHeight: size.height / 3,
                  maxWidth: size.width / 2
                ),
                decoration: BoxDecoration(
                  boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 20)],
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10)
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: List.generate(controllersProsesUtama.length, (i){
                    return Column(
                      children: [
                        Text(controllersProsesUtama[i].text.toUpperCase(), style: const TextStyle(fontSize: 10, color: Colors.black)),
                        if(controllersSubProsesUtama.length > 0)
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: List.generate(controllersSubProsesUtama.length, (j){
                                return Text(controllersSubProsesUtama[j].text.toLowerCase(), style: const TextStyle(fontSize: 10));
                              }),
                            ),
                          )
                      ],
                    );
                  })
                ),
              ),
              const Divider(),
              Expanded(
                child: Container(
                  color: Colors.white,
                  child: Form(
                    key: _formKey,
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: controllersProsesUtama.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: TextFormField(
                                      onEditingComplete: (){
                                        FocusManager.instance.primaryFocus?.unfocus();
                                        setState(() {});
                                      },
                                      controller: controllersProsesUtama[index],
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Mohon inputkan nama proses utama';
                                        }
                                        return null;
                                      },
                                      decoration: InputDecoration(
                                        enabledBorder: const UnderlineInputBorder(borderSide: BorderSide(color: GlobalVariable.secondaryColor)),
                                        label: Text("Tambah Proses Utama", style: globalTextStyle.defaultTextStyleMedium(color: GlobalVariable.secondaryColor, fontSize: 16)),
                                        prefixIcon: const Icon(MingCute.process_line, color: GlobalVariable.secondaryColor)
                                      ),
                                    ),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.remove_circle_outline, color: GlobalVariable.secondaryColor),
                                    onPressed: () {
                                      if(controllersProsesUtama.length < 2){
                                        ScaffoldMessenger.of(context).showSnackBar(snackBarMinimum);
                                      }else{
                                        setState(() {
                                          controllersProsesUtama.removeAt(index).dispose();
                                        });
                                      }
                                    },
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              if(controllersSubProsesUtama.length > 0)
                                SizedBox(
                                  width: size.width / 1.5,
                                  child: Column(
                                    children: List.generate(controllersSubProsesUtama.length, (j){
                                      return TextFormField(
                                        onEditingComplete: (){
                                          FocusManager.instance.primaryFocus?.unfocus();
                                          setState(() {});
                                        },
                                        controller: controllersSubProsesUtama[j],
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
                                      );
                                    })
                                  ),
                                ),
                              const SizedBox(height: 10),
                              SizedBox(
                                height: 30,
                                child: ElevatedButton(
                                  onPressed: (){
                                    setState(() {
                                      controllersSubProsesUtama.add(TextEditingController());
                                    });
                                  }, 
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: GlobalVariable.secondaryColor,
                                    elevation: 0
                                  ),
                                  child: const Text("Tambah Sub Proses", style: TextStyle(fontSize: 10, color: Colors.white))
                                ),
                              )
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton.small(
          backgroundColor: GlobalVariable.secondaryColor,
          onPressed: (){
            if(controllersProsesUtama.length > 8){
              ScaffoldMessenger.of(context).showSnackBar(snackBarFull);
            }else{
              if(_formKey.currentState!.validate()){
                setState(() {
                  controllersProsesUtama.add(TextEditingController());
                });
              }
            }
          }, 
          child: const Icon(Icons.add, color: Colors.white),
        ),
      ),
    );
  }

  final snackBarFull = const SnackBar(content: Text('Proses utama melebihi batas maksimum'));
  final snackBarMinimum = const SnackBar(content: Text('Proses utama kurang dari batas minimum'));
}