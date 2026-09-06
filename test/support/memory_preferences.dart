import 'dart:async';

import 'package:shared_preferences/shared_preferences.dart';

/// Fake only the platform boundary; tests exercise the real JSON repository.
// Mutable failure controls deliberately simulate the immutable plugin boundary.
// ignore: must_be_immutable
class MemoryPreferences implements SharedPreferencesAsync {
  final values = <String, String>{};
  bool failRead = false;
  bool failWrite = false;
  Completer<void>? writeGate;
  @override
  Future<String?> getString(String key) async {
    if (failRead) throw StateError('Read unavailable');
    return values[key];
  }

  @override
  Future<void> setString(String key, String value) async {
    await writeGate?.future;
    if (failWrite) throw StateError('Write unavailable');
    values[key] = value;
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
