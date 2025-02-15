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
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Column(
          children: [
            Text("Foto Pengambilan ${widget.name}", style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
            const SizedBox(height: 3),
            Text(widget.kodeASB ?? "Tidak ada Kode", style: const TextStyle(fontSize: 13, color: Colors.black45)),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        child: Column(
          children: [
            Wrap(
              children: List.generate(widget.listPhoto?.length ?? 0, (i){
                return CupertinoButton(
                  padding: EdgeInsets.zero,
                  onPressed: (){
                    showDialog(
                      context: context, 
                      builder: (context) => ImageDialog(urlImage: widget.listPhoto?[i])
                    );
                  },
                  child: Container(
                    width: 120,
                    height: 120,
                    margin: const EdgeInsets.only(right: 5),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.white54,
                      border: Border.all(color: Colors.black12, width: 0.5),
                      boxShadow: const [BoxShadow(color: Colors.black26, offset: Offset(1, 2), blurRadius: 5)],
                      image: DecorationImage(
                        image: NetworkImage(widget.listPhoto![i]),
                        fit: BoxFit.cover, 
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