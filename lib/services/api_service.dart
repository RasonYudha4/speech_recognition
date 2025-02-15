import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class APIService {
  static const String baseUrl = "http://192.168.1.59:8000";

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

  Future<String> extractTextFromImage(File imageFile) async {
    final url = Uri.parse('$baseUrl/upload');
    var request = http.MultipartRequest("POST", url);
    request.files
        .add(await http.MultipartFile.fromPath("file", imageFile.path));

    var response = await request.send();
    if (response.statusCode == 200) {
      var jsonResponse = json.decode(await response.stream.bytesToString());

      String summary = jsonResponse['summary'];

      return summary;
    } else {
      throw Exception("Failed to extract text from image.");
    }
  }

  Future<String> extractTextFromPDF(File pdfFile) async {
    final url = Uri.parse('$baseUrl/extract-pdf');
    var request = http.MultipartRequest("POST", url);
    request.files.add(await http.MultipartFile.fromPath("file", pdfFile.path));

    var response = await request.send();
    if (response.statusCode == 200) {
      var jsonResponse = json.decode(await response.stream.bytesToString());
      return jsonResponse['extracted_text'];
    } else {
      throw Exception("Failed to extract text from PDF.");
    }
  }
}
