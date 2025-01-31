class ProvinceModels {
  ProvinceModels({
    required this.rajaongkir,
  });
  late final Rajaongkir rajaongkir;

  ProvinceModels.fromJson(Map<String, dynamic> json) {
    rajaongkir = Rajaongkir.fromJson(json['rajaongkir']);
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['rajaongkir'] = rajaongkir.toJson();
    return data;
  }
}

class Rajaongkir {
  Rajaongkir({
    required this.query,
    required this.status,
    required this.results,
  });
  late final List<dynamic> query;
  late final Status status;
  late final List<Results> results;

  Rajaongkir.fromJson(Map<String, dynamic> json) {
    query = List.castFrom<dynamic, dynamic>(json['query']);
    status = Status.fromJson(json['status']);
    results =
        List.from(json['results']).map((e) => Results.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['query'] = query;
    data['status'] = status.toJson();
    data['results'] = results.map((e) => e.toJson()).toList();
    return data;
  }
}

class Status {
  Status({
    required this.code,
    required this.description,
  });
  late final int code;
  late final String description;

  Status.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    description = json['description'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['code'] = code;
    data['description'] = description;
    return data;
  }
}

class Results {
  Results({
    required this.provinceId,
    required this.province,
  });
  late final String provinceId;
  late final String province;

  Results.fromJson(Map<String, dynamic> json) {
    provinceId = json['province_id'];
    province = json['province'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['province_id'] = provinceId;
    data['province'] = province;
    return data;
  }
}