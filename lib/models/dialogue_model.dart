class DialogueModel {
  final String id;
  final String characterId;
  final String characterName;
  final String text;
  final String emotion;
  final double startTime;
  final double duration;
  final String audioPath;

  DialogueModel({
    required this.id,
    required this.characterId,
    required this.characterName,
    required this.text,
    this.emotion = 'neutral',
    this.startTime = 0,
    this.duration = 3,
    this.audioPath = '',
  });

  factory DialogueModel.fromJson(Map<String, dynamic> json) {
    return DialogueModel(
      id: json['id'] ?? '',
      characterId: json['characterId'] ?? '',
      characterName: json['characterName'] ?? '',
      text: json['text'] ?? '',
      emotion: json['emotion'] ?? 'neutral',
      startTime: (json['startTime'] ?? 0).toDouble(),
      duration: (json['duration'] ?? 3).toDouble(),
      audioPath: json['audioPath'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'characterId': characterId,
      'characterName': characterName,
      'text': text,
      'emotion': emotion,
      'startTime': startTime,
      'duration': duration,
      'audioPath': audioPath,
    };
  }
}
