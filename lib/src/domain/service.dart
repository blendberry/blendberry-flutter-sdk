import 'dart:convert';
import 'package:blendberry_flutter_sdk/src/data/model.dart';
import 'package:http/http.dart' as http;

/// Defines the contract for interacting with a remote configuration backend.
///
/// [RemoteConfigService] exposes methods for retrieving remote configuration data
/// and checking whether an update is required, based on the current version and
/// last known modification timestamp.
///
/// This interface is designed to be implemented with customizable behavior, particularly
/// around the [_baseUrl] used to contact the remote server. This enables consumers
/// of the API to plug in their own backend instances.
///
/// The default implementation, [RemoteConfigServiceImpl], targets a local development server,
/// but can be overridden to suit any deployment scenario.
///
/// Example usage:
/// ```dart
/// final service = RemoteConfigServiceImpl("https://yourdomain/configs");
/// final config = await service.fetchConfig("prod", "1.0.0");
/// ```
///
/// See also:
/// - [RemoteConfigModel] for the data model returned by [fetchConfig].
/// - [LookupResponse] for the possible states returned by [lookupRemotely].
abstract class RemoteConfigService {

  /// The base URL of the remote configuration service.
  ///
  /// This should point to the root endpoint where the remote configuration backend is hosted.
  /// Implementors are expected to override this to match their deployment environment.
  final String _baseUrl;

  RemoteConfigService(this._baseUrl);

  /// Fetches the full configuration for a given environment and optional version (this means the latest version of
  /// that environment will be fetched).
  ///
  /// Returns a [RemoteConfigModel] if the server responds with a 200 OK and valid data,
  /// or `null` otherwise.
  Future<RemoteConfigModel?> fetchConfig(String env, String? version) async {
    final url = Uri.parse('$_baseUrl/$env').replace(queryParameters: {
      "version": version ?? "latest"
    });
    final response = await http.get(url);
    if (response.statusCode == 200) {
      return RemoteConfigModel.fromJson(jsonDecode(response.body));
    } else {
      return null;
    }
  }

  /// Performs a lightweight lookup to check if a configuration update is needed.
  ///
  /// This method compares the local `lastModDate` with the remote one, without retrieving
  /// the entire config payload.
  ///
  /// Returns one of the values defined in [LookupResponse], or `null` on failure.
  Future<String?> lookupRemotely(String env, String version, DateTime lastModDate) async {
    final url = Uri.parse('$_baseUrl/lookup').replace(queryParameters: {
      "env": env,
      "version": version,
      "lastModDate": lastModDate.toUtc().toIso8601String(),
    });

    final response = await http.get(url);
    if (response.statusCode == 200) {
      return response.body;
    } else {
      return null;
    }
  }
}

/// Represents the possible results of a remote configuration lookup operation.
///
/// This enum defines the possible string responses returned by the backend
/// when performing a version comparison via [RemoteConfigService.lookupRemotely].
///
/// These values help determine whether the local configuration is up-to-date,
/// needs to be refreshed, or doesn't exist remotely.
///
/// - [upToDate]: The local config matches the server's.
/// - [needsToUpdate]: The server has a newer version.
/// - [notFound]: No matching configuration exists on the server.
enum LookupResponse {

  upToDate("UP_TO_DATE"),
  needsToUpdate("NEEDS_TO_UPDATE"),
  notFound("NOT_FOUND");

  const LookupResponse(this.value);

  final String value;
}