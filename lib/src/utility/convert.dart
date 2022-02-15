class Convert {
  static String enumTostring<T>(Iterable<T> values, T value, T Function() orElse) {
    final firstVal = values.firstWhere((type) => type == value, orElse: orElse);
    return firstVal.toString().split(".").last;
  }

  static T stringToenum<T>(Iterable<T> values, String value, T Function() orElse) {
    return values.firstWhere((type) => type.toString().split(".").last == value,
        orElse: orElse);
  }
}
