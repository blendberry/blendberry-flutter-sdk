---

## Overview

BlendBerry is a flexible remote configuration system that allows mobile applications to fetch and update configurations dynamically from a backend service. It simplifies the process of managing app configurations, enabling teams to adjust app behavior, UI themes, features, and more remotely.

## Table of Contents

- [Overview](#overview)
- [Key Features](#key-features)
- [Architecture](#architecture)
- [Installation](#installation)
- [Usage](#usage)
- [Example App](#example-app)
- [API Reference](#api-reference)
- [Contributing](#contributing)
- [License](#license)

---

# BlendBerry SDK for Flutter

The **BlendBerry SDK for Flutter** provides a simple and efficient way to fetch and store remote configurations 
locally in your app. It integrates with the **BlendBerry Backend API** and allows automatic synchronization of 
configurations between the app and the backend server.

- **Remote Configurations**: Fetch configurations based on app environment and version.
- **Local Storage**: Cache configurations locally using any storage delegate implementation for offline usage.
- **Efficient Sync**: Automatically checks for updates and fetches new configurations when necessary.

---

## Key Features

- **Automatic Configuration Sync**: Fetch the latest configurations or use cached data if up-to-date.
- **Flexible Configuration Storage**: Store and manage configurations locally in an organized way.
- **Environment & Version Support**: Allows fetching configurations based on the environment and version.
- **Easy Integration**: Integrates seamlessly with existing Flutter projects.
- **Customizable Configurations**: Supports various configuration types (e.g., theme, feature flags, user settings).

---

## Architecture

The SDK follows a clean architecture structure that divides the app's functionality into layers:

- **Data Layer**: Handles remote fetching and local storage of configurations.
- **Domain Layer**: Contains business logic and maps data to relevant entities.
- **Presentation Layer**: Dispatches configurations to relevant parts of the application.

Here’s a simple flow of how configurations are managed:

1. **Local Config Check**: Check if there is a locally stored configuration.
2. **Remote Config Lookup**: If no local data, fetch configurations from the backend.
3. **Sync Check**: Check if the local configuration is up-to-date with the backend using versioning.
4. **Save and Use Configurations**: If an update is available, fetch the new configuration and store it locally for future use.

---

## Installation

To integrate **BlendBerry SDK** into your Flutter app, follow these steps:

### 1. Add Dependency in `pubspec.yaml`

```yaml
dependencies:
  blendberry_flutter_sdk:
    git:
      url: git://github.com/blendberry/blendberry-flutter-sdk.git
      ref: main # or a specific branch/tag
```

### 2. Install Dependencies

Run the following command to install the SDK:

```bash
flutter pub get
```

---

## Usage

Here’s how you can use the BlendBerry SDK to fetch and use configurations in your Flutter app.

### 1. Initialize the Remote Config

Before using the configurations, you need to load them:

```dart
final configMediator = RemoteConfigMediatorImpl();
await configMediator.loadConfigs(Environment.staging.value); // Specify the environment (e.g., 'staging')
```

This will either fetch the configurations from the backend or use the local cached version if it’s up-to-date.

### 2. Dispatch Configurations

Once the configurations are loaded, you can dispatch them using a mapper:

```dart
final themeConfig = configMediator.dispatch(CustomMapper());
print('Should use dark theme: ${themeConfig.useDarkTheme}');
```

### 3. Error Handling

Make sure to handle connection errors properly as this package only focuses on remote configurations.

```dart
try {
  await configMediator.loadConfigs(Environment.staging.value);
} catch (e) {
  print('Error loading configurations: $e');
}
```

---

## Example App

A working example is available in the `/example` directory.  
This is a minimal Flutter application that demonstrates how to implement:
It serves two main purposes:

1. **Real-World Integration Test** – To validate that the SDK works correctly within a Flutter environment.
2. **Usage Guide for Developers** – To provide a working example of how to integrate and use the SDK in their own apps.

To run the example:

```bash
cd example
flutter pub get
flutter run
```

> ℹ️ Dependencies such as `shared_preferences` used in `/example` are **not required** by the SDK itself. This ensures the core package remains lightweight and platform-agnostic.

---

## API Reference

- **`RemoteConfigService`**: Interface to communicate with the backend for fetching configurations.
    - **`fetchConfig(String env, String? version)`**: Fetches the configuration based on environment and optional version.
    - **`lookupRemotely(String env, String version, DateTime lastModDate)`**: Checks if the remote configuration is up-to-date based on the last modification date.

- **`RemoteConfigMediator`**: Manages the configuration fetching logic and dispatching configurations to the app.
    - **`loadConfigs(String env, [String? version])`**: Loads the configuration either from the local cache or remotely.
    - **`dispatch<T extends RemoteConfig>(Mapper<T> mapper)`**: Dispatches the configuration using a specified mapper.

---

## Contributing

We welcome contributions from the community! If you want to contribute to the **BlendBerry SDK for Flutter**, please follow these steps:

### 1. Fork the Repository

Click the **Fork** button in the top-right corner of this page to create a copy of the repository under your own GitHub account.

### 2. Clone Your Fork

Clone the repository to your local machine:

```bash
git clone https://github.com/blendberry/blendberry-flutter-sdk.git
```

### 3. Create a New Branch

Create a new branch to work on your changes:

```bash
git checkout -b feature/your-feature
```

### 4. Commit Your Changes

Commit your changes with a clear message:

```bash
git commit -am 'Add your feature'
```

### 5. Push Your Changes

Push your changes to your fork:

```bash
git push origin feature/your-feature
```

### 6. Open a Pull Request

Open a pull request on the original repository with a description of your changes.

---

## License

The **BlendBerry SDK for Flutter** is licensed under the [MIT License](LICENSE).

---
