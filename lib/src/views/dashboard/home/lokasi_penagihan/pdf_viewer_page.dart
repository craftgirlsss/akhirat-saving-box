import 'package:asb_app/src/components/global/index.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';

class PdfViewerPage extends StatefulWidget {
  const PdfViewerPage({super.key, this.name, this.program, this.jumlah, this.jumlahBahasa});
  final String? name;
  final String? program;
  final String? jumlah;
  final String? jumlahBahasa;


  @override
  State<PdfViewerPage> createState() => _PdfViewerPageState();
}

class _PdfViewerPageState extends State<PdfViewerPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("PDF Preview"),
        leading: IconButton(
          onPressed: (){
            Navigator.pop(context);
          }, 
          icon: const Icon(Iconsax.arrow_left_2_bold, size: 30,)
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {}, 
        backgroundColor: GlobalVariable.secondaryColor,
        child: const Icon(CupertinoIcons.share, color: Colors.white), 
      )
    );
  }
}