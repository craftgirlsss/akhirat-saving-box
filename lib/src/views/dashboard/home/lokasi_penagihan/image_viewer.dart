import 'package:asb_app/src/views/dashboard/home/lokasi_penagihan/detail_lokasi.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ImageViewer extends StatefulWidget {
  final List<dynamic>? listPhoto;
  final String? name;
  final String? kodeASB;
  const ImageViewer({super.key, this.name, this.listPhoto, this.kodeASB});

  @override
  State<ImageViewer> createState() => _ImageViewerState();
}

class _ImageViewerState extends State<ImageViewer> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          children: [
            Text(widget.name ?? "Tidak ada Nama", style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            Text(widget.kodeASB ?? "Tidak ada Kode", style: const TextStyle(fontSize: 13, color: Colors.black45)),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Wrap(
              children: List.generate(widget.listPhoto?.length ?? 0, (i){
                return CupertinoButton(
                  padding: EdgeInsets.zero,
                  onPressed: (){
                    ImageDialog(urlImage: widget.listPhoto?[i]);
                  },
                  child: Container(
                    width: 70,
                    height: 70,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black38),
                      image: DecorationImage(
                        image: NetworkImage(widget.listPhoto![i]), 
                        onError: (exception, stackTrace) => const Center(child: Icon(Icons.image_not_supported_outlined),
                        )
                      )
                    ),
                  ),
                );
              }),
            )
          ],
        ),
      ),
    );
  }
}