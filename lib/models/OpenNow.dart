class OpenNow {
  final bool openNow;

  OpenNow({required this.openNow});

  factory OpenNow.fromJson(Map<dynamic, dynamic> parsedJson) {
    return OpenNow(openNow: parsedJson['open_now']);
  }
}
