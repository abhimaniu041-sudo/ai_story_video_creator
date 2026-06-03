import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../utils/constants.dart';

class GeminiService {
  final String apiKey;

  GeminiService({required this.apiKey});

  Future<String> generateContent(String prompt, {String? systemPrompt}) async {
    final url =
        '${AppConstants.geminiBaseUrl}/models/${AppConstants.geminiModel}:generateContent?key=$apiKey';

    final List<Map<String, dynamic>> contents = [];

    if (systemPrompt != null) {
      contents.add({
        'role': 'user',
        'parts': [{'text': systemPrompt}],
      });
      contents.add({
        'role': 'model',
        'parts': [{'text': 'Understood. I will follow these instructions.'}],
      });
    }

    contents.add({
      'role': 'user',
      'parts': [{'text': prompt}],
    });

    final response = await http
        .post(
          Uri.parse(url),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({
            'contents': contents,
            'generationConfig': {
              'temperature': 0.8,
              'maxOutputTokens': 8192,
            },
          }),
        )
        .timeout(Duration(seconds: AppConstants.timeoutSeconds));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['candidates'][0]['content']['parts'][0]['text'] ?? '';
    } else if (response.statusCode == 429) {
      throw Exception('RATE_LIMIT');
    } else {
      throw Exception('Gemini error: ${response.statusCode}');
    }
  }
}
