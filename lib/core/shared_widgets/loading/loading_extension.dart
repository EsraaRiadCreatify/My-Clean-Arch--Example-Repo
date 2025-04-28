import 'package:flutter/material.dart';
import 'loading_controller.dart';

extension LoadingExtension on BuildContext {
  void showLoading({
    String? message,
    Color? backgroundColor,
    Color? spinnerColor,
    double opacity = 0.5,
  }) {
    LoadingController().startLoading(
      message: message,
      backgroundColor: backgroundColor,
      spinnerColor: spinnerColor,
      opacity: opacity,
    );
  }

  void hideLoading() {
    LoadingController().stopLoading();
  }

  Widget withLoading({
    required Widget child,
    String? message,
    Color? backgroundColor,
    Color? spinnerColor,
    double opacity = 0.5,
  }) {
    return LoadingController().wrapWithLoading(
      child: child,
      message: message,
      backgroundColor: backgroundColor,
      spinnerColor: spinnerColor,
      opacity: opacity,
    );
  }
} 