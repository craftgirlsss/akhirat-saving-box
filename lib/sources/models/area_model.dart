class AreaModel {
    final String id;
    final String nama;

    AreaModel({required this.id, required this.nama});

    factory AreaModel.fromJson(Map<String, dynamic> json) {
        return AreaModel(
            id: json['id'] as String,
            nama: json['nama'] as String,
        );
    }
}