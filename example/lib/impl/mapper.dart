import 'package:blendberry_flutter_sdk/blendberry_flutter_sdk.dart';
import 'package:example/impl/entity.dart';

class CustomMapper implements RemoteConfigMapper<CustomRemoteConfig> {

  @override
  CustomRemoteConfig map(Map<String, dynamic> map) => CustomRemoteConfig(map["useDarkTheme"]);
}