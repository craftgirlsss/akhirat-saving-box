class KabupatenModels {
  KabupatenModels({
    required this.rajaongkir,
  });
  late final Rajaongkir rajaongkir;

  KabupatenModels.fromJson(Map<String, dynamic> json) {
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
  });
  late final String province;

  Query.fromJson(Map<String, dynamic> json) {
    province = json['province'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['province'] = province;
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
    required this.cityId,
    required this.provinceId,
    required this.province,
    required this.type,
    required this.cityName,
    required this.postalCode,
  });
  late final String cityId;
  late final String provinceId;
  late final String province;
  late final String type;
  late final String cityName;
  late final String postalCode;

  Results.fromJson(Map<String, dynamic> json) {
    cityId = json['city_id'];
    provinceId = json['province_id'];
    province = json['province'];
    type = json['type'];
    cityName = json['city_name'];
    postalCode = json['postal_code'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['city_id'] = cityId;
    data['province_id'] = provinceId;
    data['province'] = province;
    data['type'] = type;
    data['city_name'] = cityName;
    data['postal_code'] = postalCode;
    return data;
  }
}