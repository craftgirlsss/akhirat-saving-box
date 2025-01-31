class KecamatanModels {
  KecamatanModels({
    required this.rajaongkir,
  });
  late final Rajaongkir rajaongkir;

  KecamatanModels.fromJson(Map<String, dynamic> json) {
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
  late final Query query;
  late final Status status;
  late final List<Results> results;

  Rajaongkir.fromJson(Map<String, dynamic> json) {
    query = Query.fromJson(json['query']);
    status = Status.fromJson(json['status']);
    results =
        List.from(json['results']).map((e) => Results.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['query'] = query.toJson();
    data['status'] = status.toJson();
    data['results'] = results.map((e) => e.toJson()).toList();
    return data;
  }
}

class Query {
  Query({
    required this.province,
    required this.city,
  });
  late final String province;
  late final String city;

  Query.fromJson(Map<String, dynamic> json) {
    province = json['province'];
    city = json['city'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['province'] = province;
    data['city'] = city;
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
    required this.subdistrictId,
    required this.provinceId,
    required this.province,
    required this.cityId,
    required this.city,
    required this.type,
    required this.subdistrictName,
  });
  late final String subdistrictId;
  late final String provinceId;
  late final String province;
  late final String cityId;
  late final String city;
  late final String type;
  late final String subdistrictName;

  Results.fromJson(Map<String, dynamic> json) {
    subdistrictId = json['subdistrict_id'];
    provinceId = json['province_id'];
    province = json['province'];
    cityId = json['city_id'];
    city = json['city'];
    type = json['type'];
    subdistrictName = json['subdistrict_name'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['subdistrict_id'] = subdistrictId;
    data['province_id'] = provinceId;
    data['province'] = province;
    data['city_id'] = cityId;
    data['city'] = city;
    data['type'] = type;
    data['subdistrict_name'] = subdistrictName;
    return data;
  }
}