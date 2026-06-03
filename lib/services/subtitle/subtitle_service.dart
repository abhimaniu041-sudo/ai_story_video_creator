import 'dart:io';
import 'package:path_provider/path_provider.dart';
import '../../models/dialogue_model.dart';
import '../../models/scene_model.dart';

class SubtitleService {
  Future<String> generateSRT({
    required List<SceneModel> scenes,
    required List<DialogueModel> dialogues,
  }) async {
    final buffer = StringBuffer();
    int index = 1;
    double timeOffset = 0;

    for (final scene in scenes) {
      buffer.writeln(index);
      buffer.writeln(
        '${_formatTime(timeOffset)} --> ${_formatTime(timeOffset + 2)}',
      );
      buffer.writeln('[${scene.title}]');
      buffer.writeln();
      index++;

      if (scene.narration.isNotEmpty) {
        buffer.writeln(index);
        buffer.writeln(
          '${_formatTime(timeOffset + 1)} --> ${_formatTime(timeOffset + scene.narration.length * 0.06)}',
        );
        buffer.writeln(scene.narration);
        buffer.writeln();
        index++;
      }

      for (final dialogue in scene.dialogues) {
        buffer.writeln(index);
        buffer.writeln(
          '${_formatTime(timeOffset + dialogue.startTime)} --> ${_formatTime(timeOffset + dialogue.startTime + dialogue.duration)}',
        );
        buffer.writeln('${dialogue.characterName}: ${dialogue.text}');
        buffer.writeln();
        index++;
      }

      timeOffset += scene.durationSeconds;
    }

    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/subtitles.srt');
    await file.writeAsString(buffer.toString());
    return file.path;
  }

  Future<String> generateVTT({
    required List<SceneModel> scenes,
    required List<DialogueModel> dialogues,
  }) async {
    final buffer = StringBuffer();
    buffer.writeln('WEBVTT');
    buffer.writeln();

    double timeOffset = 0;
    for (final scene in scenes) {
      for (final dialogue in scene.dialogues) {
        buffer.writeln(
          '${_formatTimeVTT(timeOffset + dialogue.startTime)} --> ${_formatTimeVTT(timeOffset + dialogue.startTime + dialogue.duration)}',
        );
        buffer.writeln('${dialogue.characterName}: ${dialogue.text}');
        buffer.writeln();
      }
      timeOffset += scene.durationSeconds;
    }

    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/subtitles.vtt');
    await file.writeAsString(buffer.toString());
    return file.path;
  }

  String _formatTime(double seconds) {
    final d = Duration(milliseconds: (seconds * 1000).round());
    final h = d.inHours.toString().padLeft(2, '0');
    final m = (d.inMinutes % 60).toString().padLeft(2, '0');
    final s = (d.inSeconds % 60).toString().padLeft(2, '0');
    final ms = (d.inMilliseconds % 1000).toString().padLeft(3, '0');
    return '$h:$m:$s,$ms';
  }

  String _formatTimeVTT(double seconds) {
    return _formatTime(seconds).replaceAll(',', '.');
  }
}
