class DaftarPengurusModels {
  DaftarPengurusModels({
    required this.success,
    required this.message,
    required this.data,
  });
  late final bool success;
  late final String message;
  late final List<Data> data;
  
  DaftarPengurusModels.fromJson(Map<String, dynamic> json){
    success = json['success'];
    message = json['message'];
    data = List.from(json['data']).map((e)=>Data.fromJson(e)).toList();
  }
}

class Data {
  Data({
    this.id,
    this.name,
    this.jabatan,
  });
  String? id;
  String? name;
  String? jabatan;
  
  Data.fromJson(Map<String, dynamic> json){
    id = json['id'];
    name = json['name'];
    jabatan = json['jabatan'];
  }
}