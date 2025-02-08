import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart';
import '../services/api_service.dart'; // Import API service

class SummarizationScreen extends StatefulWidget {
  @override
  _SummarizationScreenState createState() => _SummarizationScreenState();
}

class _SummarizationScreenState extends State<SummarizationScreen> {
  final TextEditingController _textController = TextEditingController();
  String _summary = '';
  bool _isLoading = false;

  // Speech-to-Text
  SpeechToText _speechToText = SpeechToText();
  bool _speechEnabled = false;

  // API Service
  final APIService _apiService = APIService();

  @override
  void initState() {
    super.initState();
    _initSpeech();
  }

  /// Initialize Speech-to-Text
  void _initSpeech() async {
    bool available = await _speechToText.initialize(
      onStatus: (status) => print("Speech Status: $status"),
      onError: (errorNotification) => print("Speech Error: $errorNotification"),
    );

    setState(() {
      _speechEnabled = available;
    });

    if (!available) {
      print("Speech recognition is not available on this device.");
    }
  }

  /// Start listening and convert speech to text
  void _startListening() async {
    if (!_speechEnabled) {
      print("Speech-to-Text is not initialized!");
      return;
    }
    await _speechToText.listen(onResult: _onSpeechResult);
    setState(() {});
  }

  /// Stop listening
  void _stopListening() async {
    await _speechToText.stop();
    setState(() {});
  }

  /// Capture recognized words and add them to text field
  void _onSpeechResult(result) {
    setState(() {
      _textController.text = result.recognizedWords;
    });
  }

  /// Summarize text using API
  Future<void> summarizeText() async {
    if (_textController.text.isEmpty) return;

    setState(() => _isLoading = true);

    try {
      final summary = await _apiService.summarizeText(_textController.text);
      setState(() => _summary = summary);
    } catch (e) {
      setState(() => _summary = "Error: ${e.toString()}");
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Speech-to-Text Summarization")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _textController,
              maxLines: 5,
              decoration: InputDecoration(
                hintText: "Enter text or use speech recognition...",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                FloatingActionButton(
                  onPressed: _speechToText.isNotListening
                      ? _startListening
                      : _stopListening,
                  tooltip: 'Listen',
                  child: Icon(
                      _speechToText.isNotListening ? Icons.mic_off : Icons.mic),
                ),
                ElevatedButton(
                  onPressed: _isLoading ? null : summarizeText,
                  child: _isLoading
                      ? CircularProgressIndicator()
                      : Text("Summarize"),
                ),
              ],
            ),
            SizedBox(height: 16),
            if (_summary.isNotEmpty) ...[
              Text("Summary:", style: TextStyle(fontWeight: FontWeight.bold)),
              Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(_summary),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
