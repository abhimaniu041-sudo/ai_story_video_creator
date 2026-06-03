import 'package:flutter/material.dart';

class BackgroundWidget extends StatelessWidget {
  final String category;
  final String timeOfDay;
  final String weather;
  final AnimationController animController;

  const BackgroundWidget({
    super.key,
    required this.category,
    required this.timeOfDay,
    required this.weather,
    required this.animController,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animController,
      builder: (context, child) {
        return CustomPaint(
          painter: BackgroundPainter(
            category: category,
            timeOfDay: timeOfDay,
            weather: weather,
            animValue: animController.value,
          ),
          child: const SizedBox.expand(),
        );
      },
    );
  }
}

class BackgroundPainter extends CustomPainter {
  final String category;
  final String timeOfDay;
  final String weather;
  final double animValue;

  BackgroundPainter({
    required this.category,
    required this.timeOfDay,
    required this.weather,
    required this.animValue,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    // Sky gradient
    _drawSky(canvas, size);

    // Ground
    _drawGround(canvas, size);

    // Category-specific elements
    switch (category) {
      case 'village':
        _drawVillage(canvas, w, h);
        break;
      case 'city':
        _drawCity(canvas, w, h);
        break;
      case 'forest':
        _drawForest(canvas, w, h);
        break;
      case 'school':
        _drawSchool(canvas, w, h);
        break;
      case 'office':
        _drawOffice(canvas, w, h);
        break;
      default:
        _drawVillage(canvas, w, h);
    }

    // Animated clouds
    _drawClouds(canvas, w, h);

    // Weather effects
    if (weather == 'rain') {
      _drawRain(canvas, w, h);
    }
  }

  void _drawSky(Canvas canvas, Size size) {
    final skyColors = timeOfDay == 'night'
        ? [const Color(0xFF0D1B2A), const Color(0xFF1B2838)]
        : timeOfDay == 'evening'
            ? [const Color(0xFFFF7043), const Color(0xFF1565C0)]
            : [const Color(0xFF42A5F5), const Color(0xFF90CAF9)];

    final paint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: skyColors,
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height * 0.65));

    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height * 0.65), paint);
  }

  void _drawGround(Canvas canvas, Size size) {
    final paint = Paint()..color = const Color(0xFF558B2F);
    canvas.drawRect(
      Rect.fromLTWH(0, size.height * 0.62, size.width, size.height * 0.38),
      paint,
    );
    // Ground dirt path
    final pathPaint = Paint()..color = const Color(0xFF8D6E63);
    canvas.drawRect(
      Rect.fromLTWH(
        size.width * 0.3,
        size.height * 0.72,
        size.width * 0.4,
        size.height * 0.28,
      ),
      pathPaint,
    );
  }

  void _drawVillage(Canvas canvas, double w, double h) {
    // Draw 2-3 huts
    _drawHut(canvas, w * 0.1, h * 0.45, w * 0.18, h * 0.22, const Color(0xFFA1887F));
    _drawHut(canvas, w * 0.7, h * 0.45, w * 0.2, h * 0.22, const Color(0xFF90A4AE));
    _drawTree(canvas, w * 0.05, h * 0.55, 0.8);
    _drawTree(canvas, w * 0.85, h * 0.52, 1.0);
    _drawTree(canvas, w * 0.45, h * 0.5, 0.7);
  }

  void _drawHut(Canvas canvas, double x, double y, double w, double h, Color color) {
    final wallPaint = Paint()..color = color;
    final roofPaint = Paint()..color = const Color(0xFF5D4037);

    // Wall
    canvas.drawRect(Rect.fromLTWH(x, y, w, h), wallPaint);

    // Roof (triangle)
    final roofPath = Path()
      ..moveTo(x - w * 0.1, y)
      ..lineTo(x + w / 2, y - h * 0.5)
      ..lineTo(x + w + w * 0.1, y)
      ..close();
    canvas.drawPath(roofPath, roofPaint);

    // Door
    final doorPaint = Paint()..color = const Color(0xFF3E2723);
    canvas.drawRect(
      Rect.fromLTWH(x + w * 0.35, y + h * 0.5, w * 0.3, h * 0.5),
      doorPaint,
    );
  }

  void _drawTree(Canvas canvas, double x, double y, double scale) {
    final trunkPaint = Paint()..color = const Color(0xFF5D4037);
    final leafPaint = Paint()..color = const Color(0xFF2E7D32);

    canvas.drawRect(
      Rect.fromCenter(center: Offset(x, y + 20 * scale), width: 12 * scale, height: 35 * scale),
      trunkPaint,
    );
    canvas.drawCircle(Offset(x, y), 28 * scale, leafPaint);
    canvas.drawCircle(
      Offset(x - 15 * scale, y + 10 * scale),
      20 * scale,
      leafPaint,
    );
    canvas.drawCircle(
      Offset(x + 15 * scale, y + 10 * scale),
      20 * scale,
      leafPaint,
    );
  }

  void _drawCity(Canvas canvas, double w, double h) {
    _drawBuilding(canvas, w * 0.05, h * 0.25, w * 0.15, h * 0.4, const Color(0xFF546E7A));
    _drawBuilding(canvas, w * 0.22, h * 0.15, w * 0.12, h * 0.5, const Color(0xFF455A64));
    _drawBuilding(canvas, w * 0.36, h * 0.2, w * 0.18, h * 0.45, const Color(0xFF607D8B));
    _drawBuilding(canvas, w * 0.56, h * 0.1, w * 0.14, h * 0.55, const Color(0xFF37474F));
    _drawBuilding(canvas, w * 0.72, h * 0.22, w * 0.2, h * 0.43, const Color(0xFF546E7A));
  }

  void _drawBuilding(Canvas canvas, double x, double y, double w, double h, Color color) {
    final paint = Paint()..color = color;
    canvas.drawRect(Rect.fromLTWH(x, y, w, h), paint);

    // Windows
    final winPaint = Paint()..color = const Color(0xFFFFEB3B).withOpacity(0.7);
    for (int row = 0; row < 4; row++) {
      for (int col = 0; col < 2; col++) {
        canvas.drawRect(
          Rect.fromLTWH(
            x + w * 0.15 + col * w * 0.42,
            y + h * 0.08 + row * h * 0.2,
            w * 0.28,
            h * 0.12,
          ),
          winPaint,
        );
      }
    }
  }

  void _drawForest(Canvas canvas, double w, double h) {
    for (int i = 0; i < 8; i++) {
      _drawTree(canvas, w * 0.05 + i * w * 0.13, h * 0.45 + (i % 3) * h * 0.05, 1.0 + (i % 2) * 0.3);
    }
  }

  void _drawSchool(Canvas canvas, double w, double h) {
    _drawBuilding(canvas, w * 0.15, h * 0.25, w * 0.6, h * 0.4, const Color(0xFFF48FB1));
    // Flag
    final flagPaint = Paint()..color = const Color(0xFFFF5722);
    canvas.drawRect(Rect.fromLTWH(w * 0.44, h * 0.1, w * 0.1, h * 0.06), flagPaint);
    canvas.drawLine(
      Offset(w * 0.44, h * 0.1),
      Offset(w * 0.44, h * 0.25),
      Paint()..color = const Color(0xFF5D4037)..strokeWidth = 2,
    );
  }

  void _drawOffice(Canvas canvas, double w, double h) {
    _drawBuilding(canvas, w * 0.1, h * 0.1, w * 0.75, h * 0.55, const Color(0xFF263238));
    // Glass effect
    final glassPaint = Paint()
      ..color = const Color(0xFF4FC3F7).withOpacity(0.3);
    canvas.drawRect(
      Rect.fromLTWH(w * 0.12, h * 0.12, w * 0.71, h * 0.51),
      glassPaint,
    );
  }

  void _drawClouds(Canvas canvas, double w, double h) {
    if (timeOfDay == 'night') return;
    final cloudPaint = Paint()..color = Colors.white.withOpacity(0.9);
    final cloudX = w * 0.2 + animValue * w * 0.05;
    canvas.drawCircle(Offset(cloudX, h * 0.1), 20, cloudPaint);
    canvas.drawCircle(Offset(cloudX + 25, h * 0.08), 28, cloudPaint);
    canvas.drawCircle(Offset(cloudX + 50, h * 0.1), 20, cloudPaint);

    canvas.drawCircle(Offset(w * 0.65 - animValue * w * 0.03, h * 0.12), 16, cloudPaint);
    canvas.drawCircle(Offset(w * 0.65 + 20 - animValue * w * 0.03, h * 0.1), 22, cloudPaint);
    canvas.drawCircle(Offset(w * 0.65 + 40 - animValue * w * 0.03, h * 0.12), 16, cloudPaint);
  }

  void _drawRain(Canvas canvas, double w, double h) {
    final rainPaint = Paint()
      ..color = Colors.blue.withOpacity(0.5)
      ..strokeWidth = 1.5;

    for (int i = 0; i < 30; i++) {
      final x = (w * (i / 30) + animValue * 20) % w;
      final y = (h * ((i * 17 % 100) / 100) + animValue * 30) % h;
      canvas.drawLine(
        Offset(x, y),
        Offset(x - 3, y + 12),
        rainPaint,
      );
    }
  }

  @override
  bool shouldRepaint(BackgroundPainter oldDelegate) {
    return oldDelegate.animValue != animValue ||
        oldDelegate.category != category;
  }
}
