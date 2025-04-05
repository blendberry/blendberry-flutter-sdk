/// Defines the supported environments used for fetching remote configurations.
///
/// These environments represent different stages of the development and deployment lifecycle.
enum Environment {

  /// Local environment for personal or isolated developer testing.
  local,

  /// Development environment for internal testing and iteration.
  dev,

  /// Automated testing or QA environment.
  test,

  /// Pre-production or integration testing environment.
  staging,

  /// Production environment used by real end users.
  prod;

  /// Returns the string value associated with the enum.
  String get value => name;
}