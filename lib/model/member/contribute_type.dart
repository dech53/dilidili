import 'package:dilidili/http/static/api_string.dart';

enum ContributeType {
  bangumi(ApiString.spaceBangumi);

  const ContributeType(this.api);

  final String api;
}
