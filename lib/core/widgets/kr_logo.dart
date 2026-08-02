import 'package:flutter/material.dart';

import '../constants/app_assets.dart';

/// Brand chameleon mark. Use for splash, auth headers and loaders.
class KrLogo extends StatelessWidget {
  const KrLogo({
    super.key,
    this.size = 96,
    this.fit = BoxFit.contain,
  });

  final double size;
  final BoxFit fit;

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      AppAssets.logo,
      width: size,
      height: size,
      fit: fit,
      filterQuality: FilterQuality.high,
    );
  }
}
