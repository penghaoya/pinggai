import 'dart:async';
import 'dart:convert';
export 'tool/perm_util.dart' show PermUtil;
export 'tool/log_util.dart' show LogUtil;

/// 防抖函数
Function debounce(Function fn, [int t = 30]) {
  Timer? debounceTimer;
  return (data) {
    if (debounceTimer?.isActive ?? false) debounceTimer?.cancel();

    debounceTimer = Timer(Duration(milliseconds: t), () {
      fn(data);
    });
  };
}

/// 是否是手机号
bool isPhone(String value) {
  return RegExp(r"^1(3|4|5|7|8)\d{9}$").hasMatch(value);
}

/// 版本号比较，version1 大于 version2时返回true
bool compareVersion(String version1, String version2) {
  num toNum(String vStr) {
    List<String> c = vStr.trim().split('.');
    if (c.length < 3) c.add('0');
    const r = ['0000', '000', '00', '0', ''];
    for (var i = 0; i < c.length; i++) {
      int len = c[i].length;
      c[i] = r[len] + c[i];
    }
    return int.parse(c.join(''));
  }

  num newVersion1 = toNum(version1);
  num newVersion2 = toNum(version2);
  return newVersion1 > newVersion2;
}

String decodeBase64(String base64String) {
  try {
    // 解码 Base64 字符串
    // base64Decode 将 Base64 编码的字符串解码为字节列表
    List<int> bytes = base64Decode(base64String);

    // utf8.decode 将字节列表转换为 UTF-8 编码的字符串
    return utf8.decode(bytes);
  } catch (e) {
    // 如果解码过程中发生错误，返回一个空字符串或抛出异常
    print('解码错误: $e');
    return '';
  }
}
