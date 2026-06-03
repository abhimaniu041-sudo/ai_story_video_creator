import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../utils/constants.dart';

class HuggingFaceService {
  final String apiKey;
  static const String model = 'mistralai/Mistral-7B-Instruct-v0.3';

  HuggingFaceService({required this.apiKey});

  Future<String> generateContent(String prompt, {String? systemPrompt}) async {
    final url = '${AppConstants.huggingFaceBaseUrl}/$model';

    final fullPrompt = systemPrompt != null
        ? '<s>[INST] $systemPrompt\n\n$prompt [/INST]'
        : '<s>[INST] $prompt [/INST]';

    final response = await http
        .post(
          Uri.parse(url),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $apiKey',
          },
          body: jsonEncode({
            'inputs': fullPrompt,
            'parameters': {
              'max_new_tokens': 4096,
              'temperature': 0.8,
              'return_full_text': false,
            },
          }),
        )
        .timeout(Duration(seconds: AppConstants.timeoutSeconds));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data is List && data.isNotEmpty) {
        return data[0]['generated_text'] ?? '';
      }
      return '';
    } else {
      throw Exception('HuggingFace error: ${response.statusCode}');
    }
  }
}
