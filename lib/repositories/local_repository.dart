import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../app_config.dart';
import '../models/local_state.dart';

abstract interface class LocalRepository {
  Future<LocalState?> load();
  Future<void> save(LocalState state);
}

/// Small, non-encrypted prototype storage. No credentials or entitlements.
/// Keep behind this interface so the journal can move to a database later.
class PreferencesLocalRepository implements LocalRepository {
  PreferencesLocalRepository({SharedPreferencesAsync? storage})
    : _storage = storage ?? SharedPreferencesAsync();
  final SharedPreferencesAsync _storage;

  @override
  Future<LocalState?> load() async {
    final raw = await _storage.getString(AppConfig.localStateKey);
    if (raw == null) return null;
    // Do not silently replace unreadable data with an empty journal.
    return LocalState.fromJson(jsonDecode(raw) as Map<String, dynamic>);
  }

  @override
  Future<void> save(LocalState state) =>
      _storage.setString(AppConfig.localStateKey, jsonEncode(state.toJson()));
}
