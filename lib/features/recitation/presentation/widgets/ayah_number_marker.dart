import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';

class AyahNumberMarker extends StatelessWidget {
  final int ayahNumber;

  const AyahNumberMarker({super.key, required this.ayahNumber});

  @override
  Widget build(BuildContext context) {
    final markerColor =
        Theme.of(context).extension<RecitationColors>()!.ayahMarker;

    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: markerColor, width: 1.5),
      ),
      alignment: Alignment.center,
      child: Text(
        '$ayahNumber',
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: markerColor,
              fontWeight: FontWeight.bold,
            ),
      ),
    );
  }
}
