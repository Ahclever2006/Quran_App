import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';

class AyahNumberMarker extends StatelessWidget {
  final int ayahNumber;

  const AyahNumberMarker({super.key, required this.ayahNumber});

  @override
  Widget build(BuildContext context) {
    final markerColor =
        Theme.of(context).extension<RecitationColors>()!.ayahMarker;

    return SizedBox(
      width: 40,
      height: 45,
      child: CustomPaint(
        painter: _AyahMarkerPainter(color: markerColor),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 1),
            child: Text(
              '$ayahNumber',
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: markerColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 11,
                  ),
            ),
          ),
        ),
      ),
    );
  }
}

class _AyahMarkerPainter extends CustomPainter {
  final Color color;

  _AyahMarkerPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final fillPaint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final cx = size.width / 2;
    final cy = size.height / 2;
    final w = size.width;
    final h = size.height;

    // The shape: an ornamental Quran-style ayah marker with pointed tips
    // at top and bottom, scalloped sides, and a central oval area.
    final path = Path();

    // Start from the top point
    final topY = h * 0.02;
    final bottomY = h * 0.98;
    final midTopY = h * 0.22;
    final midBottomY = h * 0.78;

    // Top pointed petal
    path.moveTo(cx, topY);
    // Right side of top petal curving down to upper-right scallop
    path.cubicTo(
      cx + w * 0.12, topY + h * 0.04,
      cx + w * 0.22, midTopY - h * 0.06,
      cx + w * 0.20, midTopY,
    );
    // Upper-right wing/scallop curving outward
    path.cubicTo(
      cx + w * 0.35, midTopY - h * 0.02,
      w * 0.92, midTopY + h * 0.02,
      w * 0.95, cy - h * 0.06,
    );
    // Right side curving to center-right
    path.cubicTo(
      w * 0.97, cy,
      w * 0.97, cy,
      w * 0.95, cy + h * 0.06,
    );
    // Lower-right wing/scallop curving inward to lower-right
    path.cubicTo(
      w * 0.92, midBottomY - h * 0.02,
      cx + w * 0.35, midBottomY + h * 0.02,
      cx + w * 0.20, midBottomY,
    );
    // Right side of bottom petal curving to bottom point
    path.cubicTo(
      cx + w * 0.22, midBottomY + h * 0.06,
      cx + w * 0.12, bottomY - h * 0.04,
      cx, bottomY,
    );
    // Left side of bottom petal (mirror)
    path.cubicTo(
      cx - w * 0.12, bottomY - h * 0.04,
      cx - w * 0.22, midBottomY + h * 0.06,
      cx - w * 0.20, midBottomY,
    );
    // Lower-left wing/scallop
    path.cubicTo(
      cx - w * 0.35, midBottomY + h * 0.02,
      w * 0.08, midBottomY - h * 0.02,
      w * 0.05, cy + h * 0.06,
    );
    // Left side curving to center-left
    path.cubicTo(
      w * 0.03, cy,
      w * 0.03, cy,
      w * 0.05, cy - h * 0.06,
    );
    // Upper-left wing/scallop
    path.cubicTo(
      w * 0.08, midTopY + h * 0.02,
      cx - w * 0.35, midTopY - h * 0.02,
      cx - w * 0.20, midTopY,
    );
    // Left side of top petal back to top point
    path.cubicTo(
      cx - w * 0.22, midTopY - h * 0.06,
      cx - w * 0.12, topY + h * 0.04,
      cx, topY,
    );

    path.close();
    canvas.drawPath(path, paint);

    // Draw small decorative dots at top and bottom
    final dotRadius = 1.8;
    canvas.drawCircle(Offset(cx, topY + h * 0.12), dotRadius, fillPaint);
    canvas.drawCircle(Offset(cx, bottomY - h * 0.12), dotRadius, fillPaint);

    // Draw tiny inner scallop accents on the left and right tips
    final accentSize = 1.2;
    canvas.drawCircle(Offset(w * 0.06, cy), accentSize, fillPaint);
    canvas.drawCircle(Offset(w * 0.94, cy), accentSize, fillPaint);
  }

  @override
  bool shouldRepaint(covariant _AyahMarkerPainter oldDelegate) {
    return color != oldDelegate.color;
  }
}
