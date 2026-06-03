import 'package:flutter/material.dart';

class AppColors {
  static const Color primary = Color(0xFFFF6B35);
  static const Color secondary = Color(0xFF2EC4B6);
  static const Color background = Color(0xFF0A0A0F);
  static const Color surface = Color(0xFF1A1A2E);
  static const Color card = Color(0xFF16213E);
  static const Color text = Color(0xFFEEEEEE);
  static const Color textSecondary = Color(0xFF888888);
  static const Color error = Color(0xFFE63946);
  static const Color success = Color(0xFF2EC4B6);
}

class AppConstants {
  static const String geminiBaseUrl =
      'https://generativelanguage.googleapis.com/v1beta';
  static const String groqBaseUrl = 'https://api.groq.com/openai/v1';
  static const String huggingFaceBaseUrl =
      'https://api-inference.huggingface.co/models';

  static const String geminiModel = 'gemini-1.5-flash';
  static const String groqModel = 'llama3-70b-8192';

  static const int maxRetries = 3;
  static const int timeoutSeconds = 60;

  static const List<String> backgroundCategories = [
    'village',
    'school',
    'forest',
    'city',
    'palace',
    'farm',
    'river',
    'market',
    'hospital',
    'office',
    'temple',
    'fantasy',
  ];

  static const List<String> characterExpressions = [
    'happy',
    'sad',
    'angry',
    'crying',
    'laughing',
    'shocked',
    'thinking',
    'neutral',
  ];

  static const List<String> animationTypes = [
    'walk',
    'run',
    'talk',
    'sit',
    'stand',
    'eat',
    'sleep',
    'cry',
    'laugh',
    'fight',
    'jump',
  ];

  static const List<String> musicCategories = [
    'emotional',
    'horror',
    'action',
    'comedy',
    'motivation',
    'adventure',
    'fantasy',
  ];

  static const List<String> supportedLanguages = [
    'Hindi',
    'English',
    'Punjabi',
  ];
}

class ApiKeys {
  static const String geminiKey = String.fromEnvironment('GEMINI_API_KEY');
  static const String groqKey = String.fromEnvironment('GROQ_API_KEY');
  static const String hfKey = String.fromEnvironment('HF_API_KEY');
  static const String firebaseProjectId =
      String.fromEnvironment('FIREBASE_PROJECT_ID');
}
