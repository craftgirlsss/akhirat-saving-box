import 'package:asb_app/src/components/alert/alert_success.dart';
import 'package:asb_app/src/components/global/index.dart';
import 'package:asb_app/src/components/textsyle/index.dart';
import 'package:asb_app/src/controllers/utilities/timeline_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class TimelineEditor extends StatefulWidget {
  const TimelineEditor({super.key});

  @override
  State<TimelineEditor> createState() => _TimelineEditorState();
}

class _TimelineEditorState extends State<TimelineEditor> {
  TimelineController timelineController = Get.put(TimelineController());
  TextEditingController namaItem = TextEditingController();
  TextEditingController deskripsiItem = TextEditingController();
  TextEditingController namaProduksi = TextEditingController();
  final globalVariable = GlobalVariable();
  final globalTextStyle = GlobalTextStyle();

  @override
  void dispose() {
    namaProduksi.dispose();
    namaItem.dispose();
    deskripsiItem.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        forceMaterialTransparency: true,
        backgroundColor: Colors.white,
        title: namaProduksi.text != "" ? Text(namaProduksi.text, style: globalTextStyle.defaultTextStyleBold(fontSize: 17)) : Text("Buat Timeline", style: globalTextStyle.defaultTextStyleBold(fontSize: 17)),
        elevation: 0,
        actions: [
          Obx(() => timelineController.temporaryList.isEmpty ? const SizedBox() : CupertinoButton(
              onPressed: timelineController.isLoading.value ? null : (){
                timelineController.daftarPekerjaan.add(NamaPekerjaan(namaPekerjaan: namaProduksi.text, modelItems: List.generate(timelineController.temporaryList.length, (i) => ModelItems(namaBagian: timelineController.temporaryList[i].namaBagian, deskripsi: timelineController.temporaryList[i].deskripsi))));
                alertSuccess(context, title: "Berhasil", content: "Berhasil menyimpan data", onOK: (){
                  Navigator.pop(context);
                });
              },
              child: const Text("Simpan", style: TextStyle(color: GlobalVariable.secondaryColor)),
            ),
          )
        ],
      ),
      body: Obx(() => timelineController.isLoading.value ? 
        SizedBox(
          width: size.width,
          height: size.height,
          child: const Center(
            child: CircularProgressIndicator(),
          ),
        ) : timelineController.temporaryList.isEmpty ? Center(
        child: Container(
          color: Colors.transparent,
          child: const Text(
            'Tidak ada item',
            style: TextStyle(
              fontSize: 40.0,
              fontWeight: FontWeight.bold,
            ),
            ),
          ),
        ) : timelineController.temporaryList.isEmpty ? Center(
        child: Container(
          color: Colors.transparent,
          width: size.width / 3,
          height: size.width,
          child: Column(
            children: [
              Image.network("https://cdn.icon-icons.com/icons2/522/PNG/512/data-add_icon-icons.com_52370.png"),
              const SizedBox(height: 10),
              Text("Tidak ada item", style: globalTextStyle.defaultTextStyleBold())
            ],
          ),
        ),
      ) :
        ReorderableListView(
          proxyDecorator: proxyDecorator,
          padding: const EdgeInsets.only(top: 15),
          onReorderStart: (index) {
            HapticFeedback.vibrate();
            SystemSound.play(SystemSoundType.click);
          },
          onReorder: (oldIndex, newIndex) {
            if(newIndex > oldIndex) newIndex--;
            final item = timelineController.temporaryList.removeAt(oldIndex);
            timelineController.temporaryList.insert(newIndex, item);
            setState(() {
              
            });
          },
          children: List.generate(timelineController.temporaryList.length, (i) {
            return Obx(
              () => timelineController.isLoading.value ? Container() : cardTimelineItem(
                key: i.toString(),
                title: timelineController.temporaryList[i].namaBagian,
                deskripsi: timelineController.temporaryList[i].deskripsi
              ),
              key: ValueKey(i),
            );
          }),
        ),
      ),
      floatingActionButton: Obx(() => FloatingActionButton(
          shape: const CircleBorder(),
          backgroundColor: GlobalVariable.secondaryColor,
          onPressed: timelineController.isLoading.value ? null : (){
            _displayTextInputDialog(context);
          }, 
          child: const Icon(Icons.add, color: Colors.white),
        ),
      ),
    );
  }

  Widget cardTimelineItem({String? key, String? title, String? deskripsi}){
    return CupertinoButton(
      key: ValueKey(key),
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 15),
      onPressed: (){},
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 5
            )
          ]
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(child: Text(title ?? "Tidak ada nama bagian", style: globalTextStyle.defaultTextStyleBold(fontSize: 16, color: Colors.black))),
                IconButton(
                  padding: EdgeInsets.zero,
                  onPressed: (){
                    _showActionSheet(context, title: title);
                  },
                  icon: const Icon(Icons.menu, color: Colors.black, size: 20))
              ],
            ),
            const SizedBox(height: 5),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                children: [
                  Text(deskripsi ?? "Tidak ada deskripsi", style: globalTextStyle.defaultTextStyleMedium(fontSize: 13), maxLines: 3, overflow: TextOverflow.ellipsis),
                ],
              ),
            )
          ],
        ),
      )
    );
  }

  Widget proxyDecorator(Widget child, int index, Animation<double> animation) {
    return AnimatedBuilder(
      animation: animation,
      builder: (BuildContext context, Widget? child) {
        return Material(
          elevation: 0,
          color: Colors.transparent,
          child: child,
        );
      },
      child: child,
    );
  }

  void _showAlertDialog(BuildContext context, {String? title}) {
    showCupertinoDialog<void>(
      context: context,
      builder: (BuildContext context) => CupertinoAlertDialog(
        title: Text('Hapus $title'),
        content: const Text('Apakah anda ingin menghapus item?'),
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

  void _showActionSheet(BuildContext context, {String? title}) {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => CupertinoActionSheet(
        title: const Text('Pilihan'),
        message: Text('Pilih aksi untuk $title'),
        actions: <CupertinoActionSheetAction>[
          CupertinoActionSheetAction(
            isDefaultAction: true,
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text("Edit"),
          ),
          CupertinoActionSheetAction(
            isDestructiveAction: true,
            isDefaultAction: true,
            onPressed: () {
              Navigator.pop(context);
              _showAlertDialog(context, title: title);
            },
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
  }


  Future<void> _displayTextInputDialog(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          elevation: 0,
          title: namaProduksi.text == "" ? const Text('Tambah Timeline', style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)) : const Text('Tambah Item Proses', style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              namaProduksi.text == "" ? TextField(
                maxLines: 2,
                minLines: 1,
                controller: namaProduksi,
                style: globalTextStyle.defaultTextStyleMedium(fontSize: 13),
                decoration: const InputDecoration(hintText: "Nama Produksi", hintStyle: TextStyle(fontSize: 13)),
              ) : const SizedBox(),
              TextField(
                maxLines: 2,
                minLines: 1,
                controller: namaItem,
                style: globalTextStyle.defaultTextStyleMedium(fontSize: 13),
                decoration: const InputDecoration(hintText: "Nama Proses", hintStyle: TextStyle(fontSize: 13)),
              ),
              TextField(
                controller: deskripsiItem,
                maxLines: 5,
                minLines: 1,
                style: globalTextStyle.defaultTextStyleMedium(fontSize: 13),
                decoration: const InputDecoration(hintText: "Deskripsi", hintStyle: TextStyle(fontSize: 13)),
              ),
            ],
          ),
          actions: <Widget>[
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                elevation: 0,
                backgroundColor: GlobalVariable.secondaryColor
              ),
              child: const Text('Batal', style: TextStyle(color: Colors.white)),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            Obx(() => 
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  elevation: 0,
                  backgroundColor: Colors.green
                ),
                onPressed: timelineController.isLoading.value ? null : (){
                  timelineController.temporaryList.add(ModelItems(namaBagian: namaItem.text, deskripsi: deskripsiItem.text));
                  setState(() {});
                  Navigator.pop(context);
                  namaItem.clear();
                  deskripsiItem.clear();
                },
                child: const Text('Simpan', style: TextStyle(color: Colors.white)),
              ),
            ),
          ],
        );
      },
    );
  }
}