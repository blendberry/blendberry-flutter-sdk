import 'dart:convert';
import 'package:blendberry_flutter_sdk/blendberry_flutter_sdk.dart';
import 'package:example/util/pref_manager.dart';

class LocalConfigRepositoryImpl implements LocalConfigRepository {

  final _prefsManager = SharedPrefsManager();

  @override
  bool hasData() => _prefsManager.getString("config_json") != null;

  @override
  RemoteConfigMetadata getMetadata() {
    final configJson = _prefsManager.getString("config_json");
    final configData = RemoteConfigModel.fromJson(jsonDecode(configJson!));
    return configData.extractMetadata();
  }

  @override
  Map<String, dynamic> getConfigs() {
    final configJson = _prefsManager.getString("config_json");
    final configData = RemoteConfigModel.fromJson(jsonDecode(configJson!));
    return configData.extractConfigs();
  }

  @override
  Future<void> saveConfig(RemoteConfigModel model) async =>
      await _prefsManager.setString("config_json", jsonEncode(model.toJson()));
}