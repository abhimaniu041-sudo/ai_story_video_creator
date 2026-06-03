import 'package:flutter/material.dart';
import '../models/character_model.dart';

class CharacterWidget extends StatefulWidget {
  final CharacterModel character;
  final bool facingRight;
  final double scale;
  final bool isPlaying;

  const CharacterWidget({
    super.key,
    required this.character,
    this.facingRight = true,
    this.scale = 1.0,
    this.isPlaying = false,
  });

  @override
  State<CharacterWidget> createState() => _CharacterWidgetState();
}

class _CharacterWidgetState extends State<CharacterWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animCtrl;
  late Animation<double> _bobAnim;
  late Animation<double> _walkAnim;

  @override
  void initState() {
    super.initState();
    _animCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    )..repeat(reverse: true);

    _bobAnim = Tween<double>(begin: -3, end: 3).animate(
      CurvedAnimation(parent: _animCtrl, curve: Curves.easeInOut),
    );
    _walkAnim = Tween<double>(begin: -5, end: 5).animate(
      CurvedAnimation(parent: _animCtrl, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animCtrl,
      builder: (context, child) {
        final isWalking = widget.character.currentAnimation == 'walk' ||
            widget.character.currentAnimation == 'run';
        final isTalking = widget.character.currentAnimation == 'talk';

        return Transform(
          transform: Matrix4.identity()
            ..scale(widget.facingRight ? 1.0 : -1.0, 1.0)
            ..translate(
              isWalking ? _walkAnim.value : 0,
              widget.isPlaying ? _bobAnim.value : 0,
            ),
          alignment: Alignment.center,
          child: Transform.scale(
            scale: widget.scale,
            child: SizedBox(
              width: 80,
              height: 140,
              child: CustomPaint(
                painter: CharacterPainter(
                  character: widget.character,
                  animationValue: _animCtrl.value,
                  isWalking: isWalking,
                  isTalking: isTalking,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class CharacterPainter extends CustomPainter {
  final CharacterModel character;
  final double animationValue;
  final bool isWalking;
  final bool isTalking;

  CharacterPainter({
    required this.character,
    required this.animationValue,
    this.isWalking = false,
    this.isTalking = false,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    // Skin color
    final skinColor = _getSkinColor(character.skinTone);
    final outfitColor = _getOutfitColor(character.outfit);
    final hairColor = const Color(0xFF1A0A00);

    final paint = Paint()..style = PaintingStyle.fill;

    // Legs with walking animation
    _drawLegs(canvas, w, h, paint, outfitColor);

    // Body
    paint.color = outfitColor;
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(center: Offset(w / 2, h * 0.55), width: w * 0.55, height: h * 0.3),
        const Radius.circular(8),
      ),
      paint,
    );

    // Arms
    _drawArms(canvas, w, h, paint, skinColor);

    // Head
    paint.color = skinColor;
    canvas.drawCircle(Offset(w / 2, h * 0.22), w * 0.28, paint);

    // Hair
    paint.color = hairColor;
    _drawHair(canvas, w, h, paint, character.hairStyle);

    // Eyes
    _drawEyes(canvas, w, h, character.currentExpression);

    // Mouth
    _drawMouth(canvas, w, h, character.currentExpression, isTalking);
  }

  void _drawLegs(Canvas canvas, double w, double h, Paint paint, Color outfitColor) {
    final walkOffset = isWalking ? (animationValue - 0.5) * 15 : 0.0;

    paint.color = outfitColor.withOpacity(0.8);
    // Left leg
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(
          center: Offset(w * 0.35, h * 0.8 + walkOffset),
          width: w * 0.2,
          height: h * 0.25,
        ),
        const Radius.circular(4),
      ),
      paint,
    );
    // Right leg
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(
          center: Offset(w * 0.65, h * 0.8 - walkOffset),
          width: w * 0.2,
          height: h * 0.25,
        ),
        const Radius.circular(4),
      ),
      paint,
    );
  }

  void _drawArms(Canvas canvas, double w, double h, Paint paint, Color skinColor) {
    final talkOffset = isTalking ? (animationValue - 0.5) * 8 : 0.0;
    paint.color = skinColor;
    // Left arm
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(
          center: Offset(w * 0.2, h * 0.55 + talkOffset),
          width: w * 0.16,
          height: h * 0.22,
        ),
        const Radius.circular(6),
      ),
      paint,
    );
    // Right arm
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(
          center: Offset(w * 0.8, h * 0.55 - talkOffset),
          width: w * 0.16,
          height: h * 0.22,
        ),
        const Radius.circular(6),
      ),
      paint,
    );
  }

  void _drawHair(Canvas canvas, double w, double h, Paint paint, String style) {
    paint.color = const Color(0xFF1A0A00);
    switch (style) {
      case 'short':
        canvas.drawArc(
          Rect.fromCenter(center: Offset(w / 2, h * 0.2), width: w * 0.58, height: w * 0.35),
          3.14,
          3.14,
          false,
          paint,
        );
        break;
      case 'long':
        canvas.drawRRect(
          RRect.fromRectAndRadius(
            Rect.fromCenter(center: Offset(w / 2, h * 0.28), width: w * 0.6, height: h * 0.2),
            const Radius.circular(4),
          ),
          paint,
        );
        break;
      case 'bald':
        break;
      default:
        canvas.drawCircle(Offset(w / 2, h * 0.17), w * 0.28, paint);
    }
  }

  void _drawEyes(Canvas canvas, double w, double h, String expression) {
    final eyePaint = Paint()..color = Colors.white;
    final pupilPaint = Paint()..color = const Color(0xFF1A0A00);

    // Eye whites
    canvas.drawOval(
      Rect.fromCenter(center: Offset(w * 0.38, h * 0.22), width: w * 0.14, height: w * 0.1),
      eyePaint,
    );
    canvas.drawOval(
      Rect.fromCenter(center: Offset(w * 0.62, h * 0.22), width: w * 0.14, height: w * 0.1),
      eyePaint,
    );

    // Pupils
    if (expression != 'crying') {
      canvas.drawCircle(Offset(w * 0.38, h * 0.22), w * 0.04, pupilPaint);
      canvas.drawCircle(Offset(w * 0.62, h * 0.22), w * 0.04, pupilPaint);
    } else {
      // Sad squinting eyes
      final sadPaint = Paint()
        ..color = Colors.blue[300]!
        ..strokeWidth = 2
        ..style = PaintingStyle.stroke;
      canvas.drawArc(
        Rect.fromCenter(center: Offset(w * 0.38, h * 0.22), width: w * 0.12, height: w * 0.08),
        0,
        3.14,
        false,
        sadPaint,
      );
    }

    // Eyebrows
    final browPaint = Paint()
      ..color = const Color(0xFF1A0A00)
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    if (expression == 'angry') {
      canvas.drawLine(
        Offset(w * 0.3, h * 0.17),
        Offset(w * 0.46, h * 0.2),
        browPaint,
      );
      canvas.drawLine(
        Offset(w * 0.7, h * 0.17),
        Offset(w * 0.54, h * 0.2),
        browPaint,
      );
    } else {
      canvas.drawLine(
        Offset(w * 0.3, h * 0.18),
        Offset(w * 0.46, h * 0.18),
        browPaint,
      );
      canvas.drawLine(
        Offset(w * 0.54, h * 0.18),
        Offset(w * 0.7, h * 0.18),
        browPaint,
      );
    }
  }

  void _drawMouth(Canvas canvas, double w, double h, String expression, bool isTalking) {
    final mouthPaint = Paint()
      ..color = const Color(0xFF8B0000)
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    if (isTalking) {
      // Open mouth when talking
      canvas.drawOval(
        Rect.fromCenter(center: Offset(w / 2, h * 0.295), width: w * 0.15, height: w * 0.1),
        Paint()..color = const Color(0xFF8B0000),
      );
      return;
    }

    switch (expression) {
      case 'happy':
      case 'laughing':
        canvas.drawArc(
          Rect.fromCenter(center: Offset(w / 2, h * 0.28), width: w * 0.2, height: w * 0.1),
          0,
          3.14,
          false,
          mouthPaint,
        );
        break;
      case 'sad':
      case 'crying':
        canvas.drawArc(
          Rect.fromCenter(center: Offset(w / 2, h * 0.32), width: w * 0.2, height: w * 0.1),
          3.14,
          3.14,
          false,
          mouthPaint,
        );
        break;
      default:
        canvas.drawLine(
          Offset(w * 0.4, h * 0.3),
          Offset(w * 0.6, h * 0.3),
          mouthPaint,
        );
    }
  }

  Color _getSkinColor(String tone) {
    switch (tone) {
      case 'light':
        return const Color(0xFFFFDBAC);
      case 'dark':
        return const Color(0xFF8D5524);
      default:
        return const Color(0xFFC68642);
    }
  }

  Color _getOutfitColor(String outfit) {
    if (outfit.contains('blue') || outfit.contains('school')) {
      return const Color(0xFF1565C0);
    } else if (outfit.contains('red')) {
      return const Color(0xFFC62828);
    } else if (outfit.contains('white')) {
      return const Color(0xFFEEEEEE);
    } else if (outfit.contains('kurta') || outfit.contains('traditional')) {
      return const Color(0xFFFF8F00);
    }
    return const Color(0xFF37474F);
  }

  @override
  bool shouldRepaint(CharacterPainter oldDelegate) {
    return oldDelegate.animationValue != animationValue ||
        oldDelegate.character.currentExpression != character.currentExpression ||
        oldDelegate.character.currentAnimation != character.currentAnimation;
  }
}
