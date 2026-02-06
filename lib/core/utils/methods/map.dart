import 'dart:convert';

import 'package:eshops/core/utils/methods/conversion.dart';

extension MapX on Map {
  T getValue<T>(String key, {required T defaultValue}) {
    final value = this[key];
    switch (value) {
      case T():
        return value;
      default:
        return defaultValue;
    }
  }

  R getValueAs<T, R>(
    T key, {
    required R defaultValue,
    required R Function(T e) parseValue,
  }) {
    final value = this[key];
    switch (value) {
      case T():
        return parseValue(value);
      case R():
        return value;
      default:
        return defaultValue;
    }
  }

  List<T> parseList<T>(
    String key, {
    required T Function(Object? e) parseItem,
  }) {
    final value = this[key];

    switch (value) {
      case List():
        final List<T> l = [];
        for (var e in value) {
          l.add(parseItem(e));
        }
        return l;
    }

    return <T>[];
  }
}

extension MapExtensions on Map<String, dynamic> {
  bool getBool(
    String key, {
    bool defaultValue = false,
  }) {
    if (containsKey(key)) {
      if (this[key] is bool) {
        return this[key] as bool;
      }
    }

    return defaultValue;
  }

  int getInt(
    String key, {
    int defaultValue = 0,
  }) {
    if (containsKey(key)) {
      return toInt(this[key] ?? defaultValue);
    }

    return defaultValue;
  }

  num getNum(String key, {num defaultValue = 0}) {
    final value = this[key];
    if (value == null) {
      return defaultValue;
    }

    if (value is num) {
      return value;
    }

    if (value is String) {
      return num.tryParse(value) ?? defaultValue;
    }

    return defaultValue;
  }

  double getDouble(
    String key, {
    double defaultValue = 0.0,
  }) {
    if (containsKey(key)) {
      return toDouble(this[key] ?? defaultValue);
    }

    return defaultValue;
  }

  String getString(
    String key, {
    String defaultValue = '',
  }) {
    if (containsKey(key)) {
      return this[key]?.toString() ?? defaultValue;
    }

    return defaultValue;
  }

  DateTime? getDateTime(String key) {
    var dateTimeString = getString(key);
    var rawDateTime = DateTime.tryParse(dateTimeString);

    if (rawDateTime?.isUtc == true) {
      return rawDateTime?.toLocal();
    } else {
      return rawDateTime?.add(DateTime.now().timeZoneOffset);
    }
  }

  List getList(String key) {
    if (containsKey(key)) {
      if (this[key] is List) {
        return List.from(this[key] as List);
      }
    }

    return [];
  }

  Map<String, dynamic> getMap(
    String key, {
    Map<String, dynamic> defaultValue = const {},
  }) {
    if (containsKey(key)) {
      if (this[key] is Map) {
        return Map<String, dynamic>.from(this[key] as Map);
      }
    }

    return defaultValue;
  }

  String toPretty() {
    JsonEncoder encoder = const JsonEncoder.withIndent('  ', toEncodable);

    return encoder.convert(this);
  }

  String toJson() {
    JsonEncoder encoder = const JsonEncoder();

    return encoder.convert(this);
  }
}

dynamic toEncodable(object) {
  if (object is String ||
      object is num ||
      object is Map ||
      object is List ||
      object is bool) {
    return object;
  }

  return '$object';
}
