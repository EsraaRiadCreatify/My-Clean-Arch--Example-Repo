import 'package:flutter/material.dart';
import 'loading_overlay.dart';

class LoadingController {
  static final LoadingController _instance = LoadingController._internal();
  factory LoadingController() => _instance;
  LoadingController._internal();

  final List<_LoadingState> _loadingStates = [];
  bool _isLoading = false;
  GlobalKey<NavigatorState>? _navigatorKey;
  OverlayEntry? _overlayEntry;

  bool get isLoading => _isLoading;

  // Set the navigator key
  void setNavigatorKey(GlobalKey<NavigatorState> key) {
    _navigatorKey = key;
  }

  void startLoading({
    String? message,
    Color? backgroundColor,
    Color? spinnerColor,
    double opacity = 0.5,
    bool isGlobal = false,
  }) {
    if (isGlobal) {
      _showGlobalLoading(
        message: message,
        backgroundColor: backgroundColor,
        spinnerColor: spinnerColor,
        opacity: opacity,
      );
    } else {
      _loadingStates.add(_LoadingState(
        message: message,
        backgroundColor: backgroundColor,
        spinnerColor: spinnerColor,
        opacity: opacity,
      ));
      _updateLoadingState();
    }
  }

  void stopLoading({bool isGlobal = false}) {
    if (isGlobal) {
      _hideGlobalLoading();
    } else {
      if (_loadingStates.isNotEmpty) {
        _loadingStates.removeLast();
        _updateLoadingState();
      }
    }
  }

  void _updateLoadingState() {
    _isLoading = _loadingStates.isNotEmpty;
  }

  Widget wrapWithLoading({
    required Widget child,
    String? message,
    Color? backgroundColor,
    Color? spinnerColor,
    double opacity = 0.5,
  }) {
    return LoadingOverlay(
      isLoading: _isLoading,
      message: message ?? _loadingStates.lastOrNull?.message,
      backgroundColor:
          backgroundColor ?? _loadingStates.lastOrNull?.backgroundColor,
      spinnerColor: spinnerColor ?? _loadingStates.lastOrNull?.spinnerColor,
      opacity: opacity,
      child: child,
    );
  }

  // Global loading methods
  void _showGlobalLoading({
    String? message,
    Color? backgroundColor,
    Color? spinnerColor,
    double opacity = 0.5,
  }) {
    if (_navigatorKey?.currentContext == null) return;

    _overlayEntry?.remove();
    _overlayEntry = OverlayEntry(
      builder: (context) => LoadingOverlay(
        isLoading: true,
        message: message,
        backgroundColor: backgroundColor,
        spinnerColor: spinnerColor,
        opacity: opacity,
        child: const SizedBox.shrink(),
      ),
    );

    _navigatorKey?.currentState?.overlay?.insert(_overlayEntry!);
  }

  void _hideGlobalLoading() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  // Cleanup method
  void dispose() {
    _loadingStates.clear();
    _isLoading = false;
    _hideGlobalLoading();
    _navigatorKey = null;
  }
}

class _LoadingState {
  final String? message;
  final Color? backgroundColor;
  final Color? spinnerColor;
  final double opacity;

  _LoadingState({
    this.message,
    this.backgroundColor,
    this.spinnerColor,
    this.opacity = 0.5,
  });
}
