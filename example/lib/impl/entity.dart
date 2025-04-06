import 'package:blendberry_flutter_sdk/blendberry_flutter_sdk.dart';
import 'package:meta/meta.dart';

@immutable
class CustomRemoteConfig implements RemoteConfig {

  static CustomRemoteConfig? _instance;

  final bool useDarkTheme;

  const CustomRemoteConfig._(this.useDarkTheme);

  factory CustomRemoteConfig(bool useDarkTheme) {
    return _instance ?? CustomRemoteConfig._(useDarkTheme);
  }
}