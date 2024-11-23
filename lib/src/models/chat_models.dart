class ChatsModels {
  ChatsModels({
    required this.status,
    required this.message,
    required this.response,
  });
  late final String status;
  late final String message;
  late final List<Response> response;

  ChatsModels.fromJson(Map<String, dynamic> json){
    status = json['status'];
    message = json['message'];
    response = List.from(json['response']).map((e)=>Response.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    data['response'] = response.map((e)=>e.toJson()).toList();
    return data;
  }
}

class Response {
  Response({
    required this.id,
    this.file,
    required this.content,
    required this.sts,
    required this.msgType,
    required this.datetime,
  });
  late final String id;
  late final String? file;
  late final String content;
  late final String sts;
  late final String msgType;
  late final String datetime;

  Response.fromJson(Map<String, dynamic> json){
    id = json['id'];
    file = null;
    content = json['content'];
    sts = json['sts'];
    msgType = json['msg_type'];
    datetime = json['datetime'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['file'] = file;
    data['content'] = content;
    data['sts'] = sts;
    data['msg_type'] = msgType;
    data['datetime'] = datetime;
    return data;
  }
}