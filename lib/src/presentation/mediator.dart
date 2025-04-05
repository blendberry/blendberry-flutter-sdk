import 'package:blendberry_flutter_sdk/src/data/repository.dart';
import 'package:blendberry_flutter_sdk/src/domain/entity.dart';
import 'package:blendberry_flutter_sdk/src/domain/mapper.dart';
import 'package:blendberry_flutter_sdk/src/domain/service.dart';
import 'package:blendberry_flutter_sdk/src/presentation/dispatcher.dart';

/// Acts as the central orchestrator for managing and delivering remote configurations.
///
/// [RemoteConfigMediator] handles the logic of determining whether to use cached
/// configurations or fetch new ones from the backend service. It guarantees that the
/// returned configuration is up-to-date (based on metadata such as environment,
/// version, and last modification date).
///
/// It also serves as a dispatcher that maps raw configuration data into runtime-ready
/// [RemoteConfig] entities, abstracting away the underlying persistence or networking logic.
///
/// The standard flow is:
/// 1. Check for local data.
/// 2. If available, verify freshness with the backend.
/// 3. If fresh, reuse; otherwise fetch and update.
/// 4. If no local data, fetch from remote and cache.
/// 5. Finally, expose the config through the `dispatch` method.
///
/// This class is typically initialized at app startup and should be kept as a singleton.
///
/// Example usage:
/// ```dart
/// final mediator = RemoteConfigMediatorImpl(Environment.staging.value);
/// await mediator.loadConfigs();
/// final config = mediator.dispatch(ThemeConfigMapper());
/// if (config.useDarkTheme) {
///   enableDarkTheme();
/// }
/// ```
abstract class RemoteConfigMediator implements RemoteConfigDispatcher {

  // The remote service responsible for fetching and checking configuration data.
  final RemoteConfigService _remoteService;

  // The local repository used for reading and saving persisted configuration data.
  final LocalConfigRepository _localRepository;

  /// Creates a [RemoteConfigMediator] with explicit dependencies for remote and local configuration services.
  ///
  /// This constructor enables full decoupling from specific implementations, making it easier to test,
  /// swap, or mock dependencies, especially in layered architectures or during unit testing.
  ///
  /// [remoteService] The service responsible for fetching and validating remote configuration data.
  /// [localRepository] The local repository used to cache and retrieve persisted configuration data.
  RemoteConfigMediator(this._remoteService, this._localRepository);

  // Holds the configurations to be dispatched.
  late Map<String, dynamic> _configs;

  /// Loads and prepares the latest configuration data for dispatching.
  ///
  /// This method checks for a locally cached configuration. If found, it verifies
  /// with the backend whether the data is up-to-date. If not found or outdated,
  /// it fetches the latest configuration from the remote server.
  ///
  /// The [env] parameter specifies the environment context (e.g., "dev", "staging", "prod").
  /// This parameter is required and used to identify the correct configuration set.
  ///
  /// The optional [version] parameter can be used to request a specific version of
  /// the configuration. If `null`, the backend will resolve and return the latest
  /// available version for the given environment.
  ///
  /// Must be called once before invoking [dispatch].
  Future<void> loadConfigs(String env, [String? version]) async {

   if(_localRepository.hasData()) {

     final env = _localRepository.getMetadata().env;
     final version = _localRepository.getMetadata().version;
     final lastModDate  = _localRepository.getMetadata().lastModDate;

     final response = await _remoteService.lookupRemotely(env, version, lastModDate);
     assert(response != null, "Error looking up remotely");
     assert(response != LookupResponse.notFound.value, 'No configuration found with env: $env and version: $version');

     if(response == LookupResponse.upToDate.value) {
       _configs = _localRepository.getConfigs();
     }
     else {
       final configModel = await _remoteService.fetchConfig(env, version);
       assert(configModel != null, "Error fetching configs");
       _configs = configModel!.extractConfigs();
       _localRepository.saveConfig(configModel);
     }
   }
   else {
     final configModel = await _remoteService.fetchConfig(env, version);
     assert(configModel != null, "Error fetching configs");
     _configs = configModel!.extractConfigs();
     _localRepository.saveConfig(configModel);
   }
  }

  /// Maps the raw configuration into a domain-specific [RemoteConfig] using the given [mapper].
  ///
  /// This method must be called after [loadConfigs] has successfully completed.
  @override
  T dispatch<T extends RemoteConfig>(RemoteConfigMapper<T> mapper) => mapper.map(_configs);
}