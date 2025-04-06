import 'package:blendberry_flutter_sdk/blendberry_flutter_sdk.dart';
import 'package:example/impl/repository.dart';
import 'package:example/impl/service.dart';

class RemoteConfigMediatorImpl extends RemoteConfigMediator {

  static RemoteConfigMediatorImpl? _instance;

  factory RemoteConfigMediatorImpl() {
    return _instance ??= RemoteConfigMediatorImpl._internal(
      RemoteConfigServiceImpl("http://10.0.2.2:8080/configs"),
      LocalConfigRepositoryImpl(),
    );
  }

  RemoteConfigMediatorImpl._internal(super.remoteService, super.localRepository);
}