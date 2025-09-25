// master_model.dart

class MasterItem {
  final String id;
  final String name;

  MasterItem({required this.id, required this.name});

  factory MasterItem.fromJson(Map<String, dynamic> json, String nameKey) {
    return MasterItem(
      id: json["id"],
      name: json[nameKey],
    );
  }
}

// Model untuk menampung respons list
class MasterListResponse {
  final bool success;
  final String message;
  final List<MasterItem> data;

  MasterListResponse({required this.success, required this.message, required this.data});

  factory MasterListResponse.fromJson(Map<String, dynamic> json, String nameKey) => MasterListResponse(
    success: json["success"] ?? false,
    message: json["message"] ?? 'Error',
    data: List<MasterItem>.from(json["data"]?.map((x) => MasterItem.fromJson(x, nameKey)) ?? []),
  );
}