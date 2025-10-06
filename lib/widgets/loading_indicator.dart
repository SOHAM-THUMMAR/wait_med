import 'package:flutter/material.dart';

class LoadingIndicator extends StatelessWidget {
  final bool isVisible;

  const LoadingIndicator({super.key, required this.isVisible});

  @override
  Widget build(BuildContext context) {
    return isVisible
        ? const Center(child: CircularProgressIndicator(color: Colors.red))
        : const SizedBox.shrink();
  }
}
