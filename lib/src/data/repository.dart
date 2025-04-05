import 'package:blendberry_flutter_sdk/src/data/model.dart';

/// Provides an abstract contract for accessing and storing remote configuration data locally.
///
/// Implementations of this interface are responsible for handling local
/// persistence of the configuration model, typically using solutions such as
/// `SharedPreferences`, secure storage, or local databases.
///
/// This abstraction allows you to swap the underlying storage mechanism
/// without affecting business logic.
abstract interface class LocalConfigRepository {

  /// Checks if any configuration data is currently stored locally.
  bool hasData();

  /// Retrieves the stored configuration metadata, including environment,
  /// version, and last modification date.
  ///
  /// This can be used to validate the current local config against a remote one.
  RemoteConfigMetadata getMetadata();

  /// Returns the stored configuration key-value pairs.
  ///
  /// These values represent the actual runtime configuration used by the app.
  Map<String, dynamic> getConfigs();

  /// Saves a complete remote configuration model to local storage.
  ///
  /// This includes both metadata and configuration values.
  Future<void> saveConfig(RemoteConfigModel model);
}