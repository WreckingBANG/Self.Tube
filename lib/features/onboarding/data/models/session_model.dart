class SessionResponseModel {
  final String sessionToken;
  final String csrfToken;

  SessionResponseModel({
    required this.sessionToken,
    required this.csrfToken,
  });

  factory SessionResponseModel.fromCookies(String setCookieHeader) {
    final sessionMatch = RegExp(r'sessionid=([^;]+)').firstMatch(setCookieHeader);
    final csrfMatch = RegExp(r'csrftoken=([^;]+)').firstMatch(setCookieHeader);

    return SessionResponseModel(
      sessionToken: sessionMatch?.group(1) ?? '',
      csrfToken: csrfMatch?.group(1) ?? '',
    );
  }
}
