import 'package:shared_preferences/shared_preferences.dart';

enum AIProvider { gemini, groq, huggingFace }

class UsageTracker {
  static const int geminiDailyLimit = 1500;
  static const int groqDailyLimit = 14400;
  static const int hfDailyLimit = 1000;

  Future<int> getUsage(AIProvider provider) async {
    final prefs = await SharedPreferences.getInstance();
    final key = '${provider.name}_usage_${_todayKey()}';
    return prefs.getInt(key) ?? 0;
  }

  Future<void> incrementUsage(AIProvider provider) async {
    final prefs = await SharedPreferences.getInstance();
    final key = '${provider.name}_usage_${_todayKey()}';
    final current = prefs.getInt(key) ?? 0;
    await prefs.setInt(key, current + 1);
  }

  Future<bool> isLimitReached(AIProvider provider) async {
    final usage = await getUsage(provider);
    switch (provider) {
      case AIProvider.gemini:
        return usage >= geminiDailyLimit;
      case AIProvider.groq:
        return usage >= groqDailyLimit;
      case AIProvider.huggingFace:
        return usage >= hfDailyLimit;
    }
  }

  Future<AIProvider> getAvailableProvider() async {
    if (!await isLimitReached(AIProvider.gemini)) return AIProvider.gemini;
    if (!await isLimitReached(AIProvider.groq)) return AIProvider.groq;
    return AIProvider.huggingFace;
  }

  String _todayKey() {
    final now = DateTime.now();
    return '${now.year}_${now.month}_${now.day}';
  }
}
