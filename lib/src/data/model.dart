import 'package:blendberry_flutter_sdk/src/data/serializable.dart';
import 'package:meta/meta.dart';

/// Represents a remote configuration model fetched from or persisted to
/// the remote config API.
///
/// This model includes configuration metadata such as environment,
/// version, and last modification date, as well as the actual configuration
/// values.
///
/// It is also responsible for (de)serialization and basic transformation.
@immutable
class RemoteConfigModel implements Serializable {
  /// Unique identifier for the app this config belongs to.
  final String appId;

  /// Environment label (e.g., "dev", "staging", "production").
  final String env;

  /// Semantic version of the configuration (e.g., "1.0.0").
  final String version;

  /// A flexible map of key-value pairs representing the actual configuration data.
  ///
  /// The structure of this map is dynamic and defined by the backend.
  /// It may contain any type of configuration values required by the app.
  final Map<String, dynamic> configs;

  /// Last modification date of the configuration in UTC.
  final DateTime lastModDate;

  /// Creates an immutable [RemoteConfigModel].
  const RemoteConfigModel({
    required this.appId,
    required this.env,
    required this.version,
    required this.configs,
    required this.lastModDate,
  });

  /// Factory constructor to create a [RemoteConfigModel] from a JSON map.
  ///
  /// The [lastModDate] field must be in ISO 8601 format.
  factory RemoteConfigModel.fromJson(Map<String, dynamic> json) {
    return RemoteConfigModel(
      appId: json["appId"],
      env: json["env"],
      version: json["version"],
      configs: json["configs"],
      lastModDate: DateTime.parse(json['lastModDate']).toUtc(),
    );
  }

  /// Serializes the [RemoteConfigModel] into a JSON-compatible map.
  ///
  /// Dates are serialized as ISO 8601 UTC strings.
  @override
  Map<String, dynamic> toJson() {
    return {
      "appId": appId,
      "env": env,
      "version": version,
      "configs": configs,
      "lastModDate": lastModDate.toUtc().toIso8601String(),
    };
  }

  /// Extracts only the metadata from this configuration into a separate object.
  RemoteConfigMetadata extractMetadata() => RemoteConfigMetadata(
    appId: appId,
    env: env,
    version: version,
    lastModDate: lastModDate,
  );

  /// Returns only the configuration values.
  Map<String, dynamic> extractConfigs() => configs;
}

/// Represents the metadata portion of a remote configuration.
///
/// Useful for version checks or shallow comparison without loading
/// the full configuration set.
@immutable
class RemoteConfigMetadata {
  final String appId;
  final String env;
  final String version;
  final DateTime lastModDate;

  /// Creates an immutable [RemoteConfigMetadata] instance.
  const RemoteConfigMetadata({
    required this.appId,
    required this.env,
    required this.version,
    required this.lastModDate,
  });
}