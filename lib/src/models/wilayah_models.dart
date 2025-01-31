class WilayahModels {
  WilayahModels({
    required this.success,
    required this.message,
    required this.data,
  });
  late final bool success;
  late final String message;
  late final List<Data> data;
  
  WilayahModels.fromJson(Map<String, dynamic> json){
    success = json['success'];
    message = json['message'];
    data = List.from(json['data']).map((e)=>Data.fromJson(e)).toList();
  }
}

class Data {
  Data({
    required this.id,
    required this.nama,
    required this.status,
    required this.lastUpdate,
  });
  late final String id;
  late final String nama;
  late final String status;
  late final String lastUpdate;
  
  Data.fromJson(Map<String, dynamic> json){
    id = json['id'];
    nama = json['nama'];
    status = json['status'];
    lastUpdate = json['last_update'];
  }
}