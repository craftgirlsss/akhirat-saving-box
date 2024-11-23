import 'package:get/get.dart';

class TimelineController extends GetxController {
  var isLoading = false.obs;
  var temporaryList = [].obs;
  var daftarPekerjaan = <NamaPekerjaan>[].obs;
}


class NamaPekerjaan {
  NamaPekerjaan({
    required this.namaPekerjaan,
    required this.modelItems,
  });
  String? namaPekerjaan;
  List<ModelItems>? modelItems;
  
  NamaPekerjaan.fromJson(Map<String, dynamic> json){
    namaPekerjaan = json['nama_pekerjaan'];
    modelItems = List.from(json['sub_proses']).map((e)=> ModelItems.fromJson(e)).toList();
  }
}

class ModelItems {
  ModelItems({
    required this.namaBagian,
    required this.deskripsi,
  });
  String? namaBagian;
  String? deskripsi;
  
  ModelItems.fromJson(Map<String, dynamic> json){
    namaBagian = json['nama_bagian'];
    deskripsi = json['deskripsi'];
  }
}