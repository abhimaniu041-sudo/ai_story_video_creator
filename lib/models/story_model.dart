import 'character_model.dart';
import 'scene_model.dart';
import 'dialogue_model.dart';

class StoryModel {
  final String id;
  final String title;
  final String prompt;
  final String fullStory;
  final String moral;
  final List<CharacterModel> characters;
  final List<SceneModel> scenes;
  final List<DialogueModel> dialogues;
  final String language;
  final String genre;
  final DateTime createdAt;

  StoryModel({
    required this.id,
    required this.title,
    required this.prompt,
    required this.fullStory,
    required this.moral,
    required this.characters,
    required this.scenes,
    required this.dialogues,
    required this.language,
    required this.genre,
    required this.createdAt,
  });

  factory StoryModel.fromJson(Map<String, dynamic> json) {
    return StoryModel(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      prompt: json['prompt'] ?? '',
      fullStory: json['fullStory'] ?? '',
      moral: json['moral'] ?? '',
      characters: (json['characters'] as List<dynamic>? ?? [])
          .map((c) => CharacterModel.fromJson(c))
          .toList(),
      scenes: (json['scenes'] as List<dynamic>? ?? [])
          .map((s) => SceneModel.fromJson(s))
          .toList(),
      dialogues: (json['dialogues'] as List<dynamic>? ?? [])
          .map((d) => DialogueModel.fromJson(d))
          .toList(),
      language: json['language'] ?? 'Hindi',
      genre: json['genre'] ?? 'drama',
      createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'prompt': prompt,
      'fullStory': fullStory,
      'moral': moral,
      'characters': characters.map((c) => c.toJson()).toList(),
      'scenes': scenes.map((s) => s.toJson()).toList(),
      'dialogues': dialogues.map((d) => d.toJson()).toList(),
      'language': language,
      'genre': genre,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}
