import 'package:flutter/material.dart';

class TarotCardBack extends StatelessWidget {
  const TarotCardBack({super.key});

  @override
  Widget build(BuildContext context) => AspectRatio(
    aspectRatio: 0.68,
    child: Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: const Color(0xFF090B0C),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFF9E754C), width: 1.5),
        boxShadow: const [
          BoxShadow(
            color: Color(0x44000000),
            blurRadius: 20,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(9),
          border: Border.all(color: const Color(0xFF354C4A)),
        ),
        child: CustomPaint(
          painter: _CardBackPattern(),
          child: const Center(
            child: Text(
              'TN',
              style: TextStyle(
                color: Color(0xFFE3D8C7),
                fontSize: 32,
                letterSpacing: 5,
                fontWeight: FontWeight.w300,
              ),
            ),
          ),
        ),
      ),
    ),
  );
}

class _CardBackPattern extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0x66577B76)
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.shortestSide * 0.34;
    for (var inset = 0; inset < 4; inset++) {
      final path = Path()
        ..addRRect(
          RRect.fromRectAndRadius(
            Rect.fromLTWH(
              12 + inset * 8,
              12 + inset * 8,
              size.width - 24 - inset * 16,
              size.height - 24 - inset * 16,
            ),
            const Radius.circular(7),
          ),
        );
      canvas.drawPath(path, paint);
    }
    canvas.drawCircle(center, radius, paint);
    canvas.drawCircle(
      center,
      radius * 0.84,
      paint..color = const Color(0x668D5148),
    );
  }

  @override
  bool shouldRepaint(covariant _CardBackPattern oldDelegate) => false;
}
