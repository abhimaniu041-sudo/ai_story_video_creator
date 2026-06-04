import 'dart:io';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:path_provider/path_provider.dart';
import '../../models/dialogue_model.dart';

class VoiceService {
  final FlutterTts _tts = FlutterTts();

  Future<void> initialize(String language) async {
    await _tts.setLanguage(_getLanguageCode(language));
    await _tts.setSpeechRate(0.85);
    await _tts.setVolume(1.0);
    await _tts.setPitch(1.0);
  }

  Future<String> generateDialogueAudio({
    required DialogueModel dialogue,
    required String language,
    required String gender,
  }) async {
    await initialize(language);
    await _setPitch(gender, dialogue.emotion);

    final dir = await getApplicationDocumentsDirectory();
    final filePath = '${dir.path}/audio_${dialogue.id}.wav';

    await _tts.synthesizeToFile(dialogue.text, filePath);
    return filePath;
  }

  Future<String> generateNarration({
    required String text,
    required String language,
  }) async {
    await initialize(language);
    await _tts.setPitch(0.9);
    await _tts.setSpeechRate(0.8);

    final dir = await getApplicationDocumentsDirectory();
    final filePath =
        '${dir.path}/narration_${DateTime.now().millisecondsSinceEpoch}.wav';

    await _tts.synthesizeToFile(text, filePath);
    return filePath;
  }

  Future<void> _setPitch(String gender, String emotion) async {
    switch (gender.toLowerCase()) {
      case 'female':
        await _tts.setPitch(1.3);
        break;
      case 'child':
        await _tts.setPitch(1.6);
        await _tts.setSpeechRate(1.0);
        break;
      case 'old':
        await _tts.setPitch(0.7);
        await _tts.setSpeechRate(0.75);
        break;
      default:
        await _tts.setPitch(1.0);
    }

    switch (emotion) {
      case 'angry':
        await _tts.setSpeechRate(1.1);
        break;
      case 'sad':
        await _tts.setSpeechRate(0.7);
        break;
      case 'happy':
        await _tts.setSpeechRate(0.95);
        break;
      default:
        break;
    }
  }

  String _getLanguageCode(String language) {
    switch (language) {
      case 'Hindi':
        return 'hi-IN';
      case 'Punjabi':
        return 'pa-IN';
      default:
        return 'en-IN';
    }
  }

  Future<void> dispose() async {
    await _tts.stop();
  }
}
