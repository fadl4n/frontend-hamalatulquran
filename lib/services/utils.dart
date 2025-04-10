class Utils {
  static String fixLocalhostURL(String? url) {
    if (url == null || url.isEmpty || url == "null") return "null";

    if (url.contains("127.0.0.1")) {
      url = url.replaceFirst("127.0.0.1", "10.0.2.2");
    }

    print("✅ Sesudah Fix: $url");
    return url;
  }
}
