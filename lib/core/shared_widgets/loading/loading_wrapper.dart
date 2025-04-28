import 'package:flutter/material.dart';
import 'loading_controller.dart';

class LoadingWrapper extends StatefulWidget {
  final Widget child;
  final GlobalKey<NavigatorState> navigatorKey;

  const LoadingWrapper({
    super.key,
    required this.child,
    required this.navigatorKey,
  });

  @override
  State<LoadingWrapper> createState() => _LoadingWrapperState();
}

class _LoadingWrapperState extends State<LoadingWrapper> {
  @override
  void initState() {
    super.initState();
    LoadingController().setNavigatorKey(widget.navigatorKey);
  }

  @override
  void dispose() {
    LoadingController().dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
} 