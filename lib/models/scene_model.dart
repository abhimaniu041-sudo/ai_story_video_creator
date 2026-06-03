import 'character_model.dart';
import 'dialogue_model.dart';

class SceneModel {
  final String id;
  final int sceneNumber;
  final String title;
  final String description;
  final String background;
  final String backgroundCategory;
  final String timeOfDay;
  final String weather;
  final List<CharacterModel> characters;
  final List<DialogueModel> dialogues;
  final String narration;
  final String music;
  final int durationSeconds;
  final List<AnimationEvent> animationEvents;

  SceneModel({
    required this.id,
    required this.sceneNumber,
    required this.title,
    required this.description,
    required this.background,
    required this.backgroundCategory,
    this.timeOfDay = 'day',
    this.weather = 'clear',
    required this.characters,
    required this.dialogues,
    this.narration = '',
    this.music = 'emotional',
    this.durationSeconds = 10,
    this.animationEvents = const [],
  });

  factory SceneModel.fromJson(Map<String, dynamic> json) {
    return SceneModel(
      id: json['id'] ?? '',
      sceneNumber: json['sceneNumber'] ?? 1,
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      background: json['background'] ?? '',
      backgroundCategory: json['backgroundCategory'] ?? 'village',
      timeOfDay: json['timeOfDay'] ?? 'day',
      weather: json['weather'] ?? 'clear',
      characters: (json['characters'] as List<dynamic>? ?? [])
          .map((c) => CharacterModel.fromJson(c))
          .toList(),
      dialogues: (json['dialogues'] as List<dynamic>? ?? [])
          .map((d) => DialogueModel.fromJson(d))
          .toList(),
      narration: json['narration'] ?? '',
      music: json['music'] ?? 'emotional',
      durationSeconds: json['durationSeconds'] ?? 10,
      animationEvents: (json['animationEvents'] as List<dynamic>? ?? [])
          .map((e) => AnimationEvent.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'sceneNumber': sceneNumber,
      'title': title,
      'description': description,
      'background': background,
      'backgroundCategory': backgroundCategory,
      'timeOfDay': timeOfDay,
      'weather': weather,
      'characters': characters.map((c) => c.toJson()).toList(),
      'dialogues': dialogues.map((d) => d.toJson()).toList(),
      'narration': narration,
      'music': music,
      'durationSeconds': durationSeconds,
      'animationEvents': animationEvents.map((e) => e.toJson()).toList(),
    };
  }
}

class AnimationEvent {
  final String characterId;
  final String animationType;
  final String expression;
  final double startTime;
  final double duration;
  final double targetX;
  final double targetY;

  AnimationEvent({
    required this.characterId,
    required this.animationType,
    required this.expression,
    required this.startTime,
    required this.duration,
    this.targetX = 0.5,
    this.targetY = 0.7,
  });

  factory AnimationEvent.fromJson(Map<String, dynamic> json) {
    return AnimationEvent(
      characterId: json['characterId'] ?? '',
      animationType: json['animationType'] ?? 'stand',
      expression: json['expression'] ?? 'neutral',
      startTime: (json['startTime'] ?? 0).toDouble(),
      duration: (json['duration'] ?? 2).toDouble(),
      targetX: (json['targetX'] ?? 0.5).toDouble(),
      targetY: (json['targetY'] ?? 0.7).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'characterId': characterId,
      'animationType': animationType,
      'expression': expression,
      'startTime': startTime,
      'duration': duration,
      'targetX': targetX,
      'targetY': targetY,
    };
  }
}
