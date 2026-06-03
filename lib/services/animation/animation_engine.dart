import 'dart:math';
import 'package:flutter/material.dart';
import '../../models/scene_model.dart';
import '../../models/character_model.dart';

class CharacterState {
  final String characterId;
  double x;
  double y;
  String animation;
  String expression;
  bool facingRight;
  double scale;
  double opacity;

  CharacterState({
    required this.characterId,
    this.x = 0.3,
    this.y = 0.65,
    this.animation = 'stand',
    this.expression = 'neutral',
    this.facingRight = true,
    this.scale = 1.0,
    this.opacity = 1.0,
  });
}

class AnimationEngine extends ChangeNotifier {
  final SceneModel scene;
  final List<CharacterState> characterStates = [];
  double _sceneTime = 0;
  bool _isPlaying = false;

  AnimationEngine({required this.scene}) {
    _initCharacters();
  }

  void _initCharacters() {
    for (final character in scene.characters) {
      characterStates.add(
        CharacterState(
          characterId: character.id,
          x: 0.2 + (characterStates.length * 0.25),
          y: 0.65,
        ),
      );
    }
  }

  void tick(double deltaTime) {
    if (!_isPlaying) return;
    _sceneTime += deltaTime;

    for (final event in scene.animationEvents) {
      if (_sceneTime >= event.startTime &&
          _sceneTime <= event.startTime + event.duration) {
        final state = characterStates.firstWhere(
          (s) => s.characterId == event.characterId,
          orElse: () => CharacterState(characterId: event.characterId),
        );

        state.animation = event.animationType;
        state.expression = event.expression;

        if (event.animationType == 'walk' || event.animationType == 'run') {
          final progress =
              (_sceneTime - event.startTime) / event.duration;
          state.x = state.x + (event.targetX - state.x) * progress * 0.05;
          state.facingRight = event.targetX > state.x;
        }
      }
    }

    notifyListeners();
  }

  void play() {
    _isPlaying = true;
  }

  void pause() {
    _isPlaying = false;
  }

  void reset() {
    _sceneTime = 0;
    _isPlaying = false;
    _initCharacters();
    notifyListeners();
  }

  CharacterState? getCharacterState(String characterId) {
    try {
      return characterStates.firstWhere((s) => s.characterId == characterId);
    } catch (_) {
      return null;
    }
  }
}
