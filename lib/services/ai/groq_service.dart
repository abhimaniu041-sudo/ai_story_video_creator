import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../utils/constants.dart';

class GroqService {
  final String apiKey;

  GroqService({required this.apiKey});

  Future<String> generateContent(String prompt, {String? systemPrompt}) async {
    final url = '${AppConstants.groqBaseUrl}/chat/completions';

    final List<Map<String, dynamic>> messages = [];

    if (systemPrompt != null) {
      messages.add({'role': 'system', 'content': systemPrompt});
    }

    messages.add({'role': 'user', 'content': prompt});

    final response = await http
        .post(
          Uri.parse(url),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $apiKey',
          },
          body: jsonEncode({
            'model': AppConstants.groqModel,
            'messages': messages,
            'max_tokens': 8192,
            'temperature': 0.8,
          }),
        )
        .timeout(Duration(seconds: AppConstants.timeoutSeconds));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['choices'][0]['message']['content'] ?? '';
    } else if (response.statusCode == 429) {
      throw Exception('RATE_LIMIT');
    } else {
      throw Exception('Groq error: ${response.statusCode}');
    }
  }
}
