import 'dart:convert';
import 'package:uuid/uuid.dart';
import 'ai/ai_manager.dart';
import '../models/story_model.dart';
import '../models/character_model.dart';
import '../models/scene_model.dart';
import '../models/dialogue_model.dart';

class StoryService {
  final AIManager _ai;
  final _uuid = const Uuid();

  StoryService({required AIManager aiManager}) : _ai = aiManager;

  Future<StoryModel> generateStory({
    required String prompt,
    required String language,
    String? fullScript,
  }) async {
    final systemPrompt = '''
You are an expert Indian animated story writer. 
Generate stories suitable for animated cartoon videos like Saral Toons.
Always return valid JSON only. No extra text.
Language: $language
''';

    final userPrompt = fullScript != null
        ? '''
Convert this script into a complete animated story JSON:
Script: $fullScript

Return JSON with this exact structure:
{
  "title": "Story Title",
  "fullStory": "Complete story text",
  "moral": "Moral of the story",
  "genre": "drama/comedy/action/adventure",
  "characters": [
    {
      "id": "char_1",
      "name": "Character Name",
      "gender": "male/female",
      "age": "child/teen/adult/old",
      "skinTone": "light/medium/dark",
      "hairStyle": "short/long/bald/curly",
      "outfit": "describe outfit briefly",
      "currentExpression": "neutral",
      "currentAnimation": "stand"
    }
  ],
  "scenes": [
    {
      "id": "scene_1",
      "sceneNumber": 1,
      "title": "Scene Title",
      "description": "What happens in this scene",
      "backgroundCategory": "village/school/city/office/forest/market/temple/palace",
      "timeOfDay": "morning/day/evening/night",
      "weather": "clear/cloudy/rain/sunny",
      "narration": "Narrator text for this scene",
      "music": "emotional/action/comedy/adventure/motivation",
      "durationSeconds": 12,
      "characters": ["char_1"],
      "animationEvents": [
        {
          "characterId": "char_1",
          "animationType": "walk/stand/talk/sit/run/cry/laugh",
          "expression": "happy/sad/angry/neutral/shocked/thinking",
          "startTime": 0,
          "duration": 4,
          "targetX": 0.3,
          "targetY": 0.7
        }
      ]
    }
  ],
  "dialogues": [
    {
      "id": "dial_1",
      "characterId": "char_1",
      "characterName": "Character Name",
      "text": "Dialogue text",
      "emotion": "happy/sad/angry/neutral",
      "startTime": 2,
      "duration": 3
    }
  ]
}
'''
        : '''
Create a complete animated story from this prompt: "$prompt"

Generate 5-8 scenes. Each scene must have animation events.
Return JSON with this exact structure:
{
  "title": "Story Title",
  "fullStory": "Complete 300-word story",
  "moral": "Moral of the story",
  "genre": "drama",
  "characters": [
    {
      "id": "char_1",
      "name": "Raju",
      "gender": "male",
      "age": "child",
      "skinTone": "medium",
      "hairStyle": "short",
      "outfit": "school uniform white shirt blue shorts",
      "currentExpression": "neutral",
      "currentAnimation": "stand"
    }
  ],
  "scenes": [
    {
      "id": "scene_1",
      "sceneNumber": 1,
      "title": "Village Morning",
      "description": "Boy wakes up in village",
      "backgroundCategory": "village",
      "timeOfDay": "morning",
      "weather": "clear",
      "narration": "Ek baar ki baat hai...",
      "music": "emotional",
      "durationSeconds": 12,
      "characters": ["char_1"],
      "animationEvents": [
        {
          "characterId": "char_1",
          "animationType": "walk",
          "expression": "happy",
          "startTime": 0,
          "duration": 4,
          "targetX": 0.5,
          "targetY": 0.7
        }
      ]
    }
  ],
  "dialogues": [
    {
      "id": "dial_1",
      "characterId": "char_1",
      "characterName": "Raju",
      "text": "Aaj mujhe school jaana hai!",
      "emotion": "happy",
      "startTime": 4,
      "duration": 3
    }
  ]
}
''';

    final jsonData = await _ai.generateJson(
      userPrompt,
      systemPrompt: systemPrompt,
    );

    final characters = (jsonData['characters'] as List<dynamic>? ?? [])
        .map((c) => CharacterModel.fromJson(c as Map<String, dynamic>))
        .toList();

    final scenes = (jsonData['scenes'] as List<dynamic>? ?? []).map((s) {
      final sceneJson = s as Map<String, dynamic>;
      final sceneCharIds = List<String>.from(sceneJson['characters'] ?? []);
      final sceneChars =
          characters.where((c) => sceneCharIds.contains(c.id)).toList();
      return SceneModel.fromJson({...sceneJson, 'characters': sceneChars.map((c) => c.toJson()).toList()});
    }).toList();

    final dialogues = (jsonData['dialogues'] as List<dynamic>? ?? [])
        .map((d) => DialogueModel.fromJson(d as Map<String, dynamic>))
        .toList();

    return StoryModel(
      id: _uuid.v4(),
      title: jsonData['title'] ?? 'My Story',
      prompt: prompt,
      fullStory: jsonData['fullStory'] ?? '',
      moral: jsonData['moral'] ?? '',
      characters: characters,
      scenes: scenes,
      dialogues: dialogues,
      language: language,
      genre: jsonData['genre'] ?? 'drama',
      createdAt: DateTime.now(),
    );
  }
}
