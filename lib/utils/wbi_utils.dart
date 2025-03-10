import 'package:dilidili/http/dio_instance.dart';
import 'package:dilidili/http/static/api_string.dart';
import 'package:dio/dio.dart';

class WbiUtils {
  static final mixinKeyEncTab = [
    46,
    47,
    18,
    2,
    53,
    8,
    23,
    32,
    15,
    50,
    10,
    31,
    58,
    3,
    45,
    35,
    27,
    43,
    5,
    49,
    33,
    9,
    42,
    19,
    29,
    28,
    14,
    39,
    12,
    38,
    41,
    13,
    37,
    48,
    7,
    16,
    24,
    55,
    40,
    61,
    26,
    17,
    0,
    1,
    60,
    51,
    30,
    4,
    22,
    25,
    54,
    21,
    56,
    59,
    6,
    63,
    57,
    62,
    11,
    36,
    20,
    34,
    44,
    52,
  ];
  static const sessdata =
      "abef0fb0%2C1755697101%2C80866%2A21CjBKt-C_cXxgM2eDjrjQodwT84PkzMhUQrwetqN7dfa9Oc14m1InqehdDzQnDvGwOVMSVl9rZTRTc2pkMEc1LS04YzF6UENDMm12VmRaYjktc2k2TE1za0lCWXhIWlB5cGlsa09MVG54R2F4bHdPU2JPUUItd25JYzlLV2NfYWZXbGlKMmI0Z3BRIIEC";
  static getWbi() async {
    Response res =
        await DioInstance.instance().get(path: ApiString.navInterface);
        print(res.data);
  }
}
