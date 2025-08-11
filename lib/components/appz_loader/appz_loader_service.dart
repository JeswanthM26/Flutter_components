import 'dart:ui';
import 'package:flutter/material.dart';

class AppzLoaderService {
  AppzLoaderService._internal();
  static final AppzLoaderService instance = AppzLoaderService._internal();

  OverlayEntry? _overlayEntry;
  String _loaderAssetPath =
      'packages/apz_flutter_components/assets/loader/loader.gif';
  double _size = 80.0;

  void init({String? customLoaderPath, double? size}) {
    if (customLoaderPath != null) {
      _loaderAssetPath = customLoaderPath;
    }
    if (size != null) {
      _size = size;
    }
  }

  void show(BuildContext context) {
    if (_overlayEntry != null) {
      return;
    }

    _overlayEntry = OverlayEntry(
      builder: (context) => Stack(
        children: [
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 4.0, sigmaY: 4.0),
            child: Container(
              color: Colors.black.withOpacity(0.2),
            ),
          ),
          Center(
            child: Image.asset(
              _loaderAssetPath,
              height: _size,
              width: _size,
            ),
          ),
        ],
      ),
    );

    Overlay.of(context).insert(_overlayEntry!);
  }

  void hide() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }
}
