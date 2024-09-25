class NewVersionData {
  late String version;
  late List<String> info;

  NewVersionData({required this.version, required this.info});

  NewVersionData.fromJson(Map<String, dynamic> json) {
    version = json['version'];
    info = json['info'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['version'] = version;
    data['info'] = info;
    return data;
  }
}

class NewVersionRes {
  String? code;
  String? message;
  NewVersionData? data;

  NewVersionRes({this.code, this.message, this.data});

  NewVersionRes.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    message = json['message'];
    data = json['data'] != null ? NewVersionData.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['code'] = code;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

Future<NewVersionData> getNewVersion() async {
  // TODO: 替换为你的真实请求接口，并返回数据，此处演示直接返回数据
  // var res = await Request.get(
  //   '/api',
  //   queryParameters: {'key': 'value'},
  // ).catchError((e) => resData);
  var resData = NewVersionRes.fromJson({
    "code": "0",
    "message": "success",
    "data": {
      "version": "1.2.1",
      "info": ["修复bug提升性能", "增加彩蛋有趣的功能页面", "测试功能"]
    }
  });
  return (resData.data ?? {}) as NewVersionData;
}
