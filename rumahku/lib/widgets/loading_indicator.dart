import 'package:flutter/material.dart';
import 'package:rumahku/utils/app_theme.dart';

class LoadingIndicator extends StatelessWidget {
  final double size;

  const LoadingIndicator({
    super.key,
    this.size = 40,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: const CircularProgressIndicator(
        strokeWidth: 3,
        valueColor: AlwaysStoppedAnimation<Color>(AppTheme.primaryColor),
      ),
    );
  }
}