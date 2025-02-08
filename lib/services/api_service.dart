import 'dart:convert';
import 'package:http/http.dart' as http;

class APIService {
  static const String baseUrl = "http://10.0.2.2:8000"; // Your FastAPI server

  Future<String> summarizeText(String text) async {
    final url = Uri.parse('$baseUrl/summarize');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'text': text}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['summary'];
    } else {
      throw Exception("Failed to summarize text.");
    }
  }
}
