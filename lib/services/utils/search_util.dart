typedef SearchFilter<T> = bool Function(T item, String keyword);

class SearchUtil {
  /// [list] = data original
  /// [keyword] = input dari search bar
  /// [filter] = logic buat nyocokin item sama keyword
  static List<T> filterList<T>(
    List<T> list,
    String keyword,
    SearchFilter<T> filter,
  ) {
    if (keyword.isEmpty) return list;

    return list.where((item) => filter(item, keyword)).toList();
  }
}
