import 'dart:convert';
import 'gemini_service.dart';
import 'groq_service.dart';
import 'huggingface_service.dart';
import 'usage_tracker.dart';
import '../../utils/constants.dart';

class AIManager {
  late final GeminiService _gemini;
  late final GroqService _groq;
  late final HuggingFaceService _hf;
  final UsageTracker _tracker = UsageTracker();

  AIManager() {
    _gemini = GeminiService(apiKey: ApiKeys.geminiKey);
    _groq = GroqService(apiKey: ApiKeys.groqKey);
    _hf = HuggingFaceService(apiKey: ApiKeys.hfKey);
  }

  Future<String> generate(String prompt, {String? systemPrompt}) async {
    final provider = await _tracker.getAvailableProvider();
    return await _generateWithFallback(prompt, systemPrompt, provider);
  }

  Future<String> _generateWithFallback(
    String prompt,
    String? systemPrompt,
    AIProvider startProvider,
  ) async {
    final providers = [
      AIProvider.gemini,
      AIProvider.groq,
      AIProvider.huggingFace,
    ];

    final startIndex = providers.indexOf(startProvider);
    final orderedProviders = [
      ...providers.sublist(startIndex),
      ...providers.sublist(0, startIndex),
    ];

    for (final provider in orderedProviders) {
      try {
        final result = await _callProvider(provider, prompt, systemPrompt);
        await _tracker.incrementUsage(provider);
        return result;
      } catch (e) {
        if (e.toString().contains('RATE_LIMIT')) {
          continue;
        }
        if (provider == orderedProviders.last) {
          rethrow;
        }
      }
    }
    throw Exception('All AI providers exhausted');
  }

  Future<String> _callProvider(
    AIProvider provider,
    String prompt,
    String? systemPrompt,
  ) async {
    switch (provider) {
      case AIProvider.gemini:
        return await _gemini.generateContent(prompt, systemPrompt: systemPrompt);
      case AIProvider.groq:
        return await _groq.generateContent(prompt, systemPrompt: systemPrompt);
      case AIProvider.huggingFace:
        return await _hf.generateContent(prompt, systemPrompt: systemPrompt);
    }
  }

  Future<Map<String, dynamic>> generateJson(
    String prompt, {
    String? systemPrompt,
  }) async {
    final response = await generate(prompt, systemPrompt: systemPrompt);
    final cleaned = response
        .replaceAll('```json', '')
        .replaceAll('```', '')
        .trim();
    try {
      return jsonDecode(cleaned);
    } catch (e) {
      final match = RegExp(r'\{[\s\S]*\}').firstMatch(cleaned);
      if (match != null) {
        return jsonDecode(match.group(0)!);
      }
      throw Exception('Failed to parse JSON response');
    }
  }
}
