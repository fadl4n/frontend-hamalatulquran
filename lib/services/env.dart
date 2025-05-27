class Environment {
  static const bool isProduction = false;

  static String get baseUrl {
    String url = isProduction
        ? "https://your-production-api.com/api"
        : "http://127.0.0.1:8000/api";

    return _fixLocalhostURL(url);
  }

  static const Duration requestTimeout = Duration(seconds: 5);

  static String _fixLocalhostURL(String url) {
    if (url.contains("127.0.0.1")) {
      return url.replaceFirst("127.0.0.1", "10.0.2.2");
    }
    return url;
  }

  /// ✅ Fungsi tambahan buat full URL gambar (dan auto-fix localhost)
  static String buildImageUrl(String relativePath) {
    String fullUrl = relativePath.startsWith("http")
        ? relativePath
        : "$baseUrl/$relativePath";
    return _fixLocalhostURL(fullUrl);
  }
}
