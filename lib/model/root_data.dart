class Rootdata<T> {
  int code;
  String message;
  int ttl;
  T data;

  Rootdata({
    required this.code,
    required this.message,
    required this.ttl,
    required this.data,
  });

  factory Rootdata.fromJson(
      Map<String, dynamic> json, T Function(dynamic) fromJsonT) {
    return Rootdata(
      code: json['code'] ?? 0,
      message: json['message'] ?? '',
      ttl: json['ttl'] ?? 0,
      data: fromJsonT(json['data']),
    );
  }
}
