class CharacterModel {
  final String id;
  final String name;
  final String gender;
  final String age;
  final String skinTone;
  final String hairStyle;
  final String outfit;
  final String currentExpression;
  final String currentAnimation;
  final Map<String, String> expressionAssets;

  CharacterModel({
    required this.id,
    required this.name,
    required this.gender,
    required this.age,
    required this.skinTone,
    required this.hairStyle,
    required this.outfit,
    this.currentExpression = 'neutral',
    this.currentAnimation = 'stand',
    this.expressionAssets = const {},
  });

  CharacterModel copyWith({
    String? currentExpression,
    String? currentAnimation,
    double? positionX,
    double? positionY,
  }) {
    return CharacterModel(
      id: id,
      name: name,
      gender: gender,
      age: age,
      skinTone: skinTone,
      hairStyle: hairStyle,
      outfit: outfit,
      currentExpression: currentExpression ?? this.currentExpression,
      currentAnimation: currentAnimation ?? this.currentAnimation,
      expressionAssets: expressionAssets,
    );
  }

  factory CharacterModel.fromJson(Map<String, dynamic> json) {
    return CharacterModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      gender: json['gender'] ?? 'male',
      age: json['age'] ?? 'adult',
      skinTone: json['skinTone'] ?? 'medium',
      hairStyle: json['hairStyle'] ?? 'short',
      outfit: json['outfit'] ?? 'casual',
      currentExpression: json['currentExpression'] ?? 'neutral',
      currentAnimation: json['currentAnimation'] ?? 'stand',
      expressionAssets: Map<String, String>.from(
        json['expressionAssets'] ?? {},
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'gender': gender,
      'age': age,
      'skinTone': skinTone,
      'hairStyle': hairStyle,
      'outfit': outfit,
      'currentExpression': currentExpression,
      'currentAnimation': currentAnimation,
      'expressionAssets': expressionAssets,
    };
  }
}
