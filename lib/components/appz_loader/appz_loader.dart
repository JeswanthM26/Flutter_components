import 'package:flutter/material.dart';
import 'appz_loader_service.dart';

/// A utility class providing an easy-to-use API for the global loader.
class AppzLoader {
  /// - [customLoaderPath]: The path to a project-level loader GIF asset.
  /// - [size]: The default size (width and height) for the loader.
  static void init({String? customLoaderPath, double? size}) {
    AppzLoaderService.instance.init(
      customLoaderPath: customLoaderPath,
      size: size,
    );
  }

  /// Displays the full-screen global loader.
  ///
  /// The UI behind the loader will be blurred and will not be interactive.
  /// Requires a [BuildContext] to access the app's overlay.
  static void startLoader(BuildContext context) {
    AppzLoaderService.instance.show(context);
  }

  /// Hides the global loader.
  static void stopLoader() {
    AppzLoaderService.instance.hide();
  }
}
