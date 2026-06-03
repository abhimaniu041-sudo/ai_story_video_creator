import 'package:flutter/material.dart';
import 'dart:async';
import '../models/scene_model.dart';
import '../models/character_model.dart';
import '../services/animation/animation_engine.dart';
import 'character_widget.dart';
import 'background_widget.dart';

class SceneCanvas extends StatefulWidget {
  final SceneModel scene;
  final bool isPlaying;

  const SceneCanvas({
    super.key,
    required this.scene,
    required this.isPlaying,
  });

  @override
  State<SceneCanvas> createState() => _SceneCanvasState();
}

class _SceneCanvasState extends State<SceneCanvas>
    with SingleTickerProviderStateMixin {
  late AnimationEngine _engine;
  Timer? _ticker;
  late AnimationController _bgController;

  @override
  void initState() {
    super.initState();
    _engine = AnimationEngine(scene: widget.scene);
    _bgController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);
  }

  @override
  void didUpdateWidget(SceneCanvas oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isPlaying && !oldWidget.isPlaying) {
      _startTicker();
      _engine.play();
    } else if (!widget.isPlaying && oldWidget.isPlaying) {
      _stopTicker();
      _engine.pause();
    }
    if (widget.scene.id != oldWidget.scene.id) {
      _engine = AnimationEngine(scene: widget.scene);
      _engine.reset();
    }
  }

  void _startTicker() {
    _ticker = Timer.periodic(const Duration(milliseconds: 33), (t) {
      _engine.tick(0.033);
      if (mounted) setState(() {});
    });
  }

  void _stopTicker() {
    _ticker?.cancel();
    _ticker = null;
  }

  @override
  void dispose() {
    _stopTicker();
    _bgController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final w = constraints.maxWidth;
        final h = constraints.maxHeight;

        return Stack(
          children: [
            // Background
            BackgroundWidget(
              category: widget.scene.backgroundCategory,
              timeOfDay: widget.scene.timeOfDay,
              weather: widget.scene.weather,
              animController: _bgController,
            ),

            // Characters
            ..._engine.characterStates.map((state) {
              final character = widget.scene.characters.firstWhere(
                (c) => c.id == state.characterId,
                orElse: () => CharacterModel(
                  id: state.characterId,
                  name: 'Unknown',
                  gender: 'male',
                  age: 'adult',
                  skinTone: 'medium',
                  hairStyle: 'short',
                  outfit: 'casual',
                ),
              );

              return Positioned(
                left: state.x * w - 40,
                top: state.y * h - 80,
                child: CharacterWidget(
                  character: character.copyWith(
                    currentAnimation: state.animation,
                    currentExpression: state.expression,
                  ),
                  facingRight: state.facingRight,
                  scale: state.scale,
                  isPlaying: widget.isPlaying,
                ),
              );
            }),

            // Dialogue bubble
            if (widget.isPlaying)
              _buildDialogueBubble(w, h),
          ],
        );
      },
    );
  }

  Widget _buildDialogueBubble(double w, double h) {
    // Find active dialogue
    final activeDialogue = widget.scene.dialogues.isNotEmpty
        ? widget.scene.dialogues.first
        : null;

    if (activeDialogue == null) return const SizedBox();

    return Positioned(
      bottom: 16,
      left: 16,
      right: 16,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.75),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.white24),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              activeDialogue.characterName,
              style: const TextStyle(
                color: Color(0xFFFF6B35),
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              activeDialogue.text,
              style: const TextStyle(color: Colors.white, fontSize: 13),
              maxLines: 2,
            ),
          ],
        ),
      ),
    );
  }
}
