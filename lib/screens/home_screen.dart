import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart';

import '../services/api_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _controller = TextEditingController();
  final APIService _apiService = APIService();
  SpeechToText _speechToText = SpeechToText();
  bool _speechEnabled = false;
  final List<Map<String, dynamic>> _messages = [];

  @override
  void initState() {
    super.initState();
  }

  void _sendMessage() async {
    String message = _controller.text.trim();
    if (message.isEmpty) return;

    // ✅ Add sent message
    setState(() {
      _messages.add({'type': 'sent', 'message': message});
      _messages.add({'type': 'loading'});
    });

    _controller.clear(); // Clear input field

    try {
      String summary = await _apiService.summarizeText(message);
      print("API Response: $summary"); // Debug output

      setState(() {
        _messages.removeWhere((msg) => msg['type'] == 'loading');
        _messages.add({'type': 'received', 'message': summary});
      });
    } catch (e) {
      print("Error calling API: $e");
      setState(() {
        _messages.removeWhere((msg) => msg['type'] == 'loading');
        _messages
            .add({'type': 'received', 'message': 'Error processing request.'});
      });
    }
  }

  Future<bool> _initSpeech() async {
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

    return available;
  }

  void _startListening() async {
    if (!_speechEnabled) {
      await _initSpeech();
    }

    if (!_speechEnabled) {
      print("Speech-to-Text is not available on this device.");
      return;
    }

    await _speechToText.listen(onResult: _onSpeechResult);
    setState(() {});
  }

  void _stopListening() async {
    await _speechToText.stop();
    setState(() {});
  }

  void _onSpeechResult(result) {
    setState(() {
      _controller.text = result.recognizedWords;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF021907),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 20),
            child: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              flexibleSpace: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 16.0),
                    child: IconButton(
                      icon: Icon(
                        Icons.chevron_left_rounded,
                        color: Color(0xFF2FF761),
                        size: 50,
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                  Center(
                    child: Text(
                      'Summarizon AI',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2FF761),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 16.0),
                    child: PopupMenuButton<String>(
                      icon: Icon(
                        Icons.more_vert,
                        color: Color(0xFF2FF761),
                        size: 36,
                      ),
                      color: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16.0),
                      ),
                      onSelected: (value) {
                        print("Selected: $value");
                      },
                      itemBuilder: (BuildContext context) =>
                          <PopupMenuEntry<String>>[
                        PopupMenuItem<String>(
                          value: 'Change Language',
                          child: SizedBox(
                            width: 150,
                            height: 50,
                            child: Container(
                              height: 50,
                              alignment: Alignment.centerLeft,
                              padding: EdgeInsets.only(left: 16.0),
                              child: Text(
                                'Change Language',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                        PopupMenuItem<String>(
                          value: 'Chat History',
                          child: SizedBox(
                            width: 150,
                            height: 50,
                            child: Container(
                              height: 50,
                              alignment: Alignment.centerLeft,
                              padding: EdgeInsets.only(left: 16.0),
                              child: Text(
                                'Chat History',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.all(8.0),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final msg = _messages[index];

                if (msg['type'] == 'sent') {
                  return MessageSent(message: msg['message']);
                } else if (msg['type'] == 'received') {
                  return MessageReceived(message: msg['message']);
                } else if (msg['type'] == 'loading') {
                  return LoadingMessage(); // ✅ Show loading animation
                }

                return SizedBox.shrink();
              },
            ),
          ),
          Container(
            padding: EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.transparent,
            ),
            child: Row(
              children: [
                PopupMenuButton<String>(
                  icon: Icon(
                    Icons.attach_file,
                    color: Color(0xFF2FF761),
                  ),
                  onSelected: (value) {
                    print("Selected: $value");
                  },
                  color: Color(0xFF133E1E),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  itemBuilder: (BuildContext context) =>
                      <PopupMenuEntry<String>>[
                    PopupMenuItem<String>(
                      value: 'Image',
                      child: Row(
                        children: [
                          Icon(
                            Icons.image,
                            color: Color(0xFF50E776),
                          ),
                          SizedBox(width: 10),
                          Text(
                            "Image",
                            style: TextStyle(
                              color: Color(0xFF50E776),
                            ),
                          ),
                        ],
                      ),
                    ),
                    PopupMenuItem<String>(
                      value: 'Document',
                      child: Row(
                        children: [
                          Icon(
                            Icons.insert_drive_file,
                            color: Color(0xFF50E776),
                          ),
                          SizedBox(width: 10),
                          Text(
                            "Document",
                            style: TextStyle(
                              color: Color(0xFF50E776),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Expanded(
                  child: TextField(
                    controller: _controller,
                    style: TextStyle(color: Colors.green),
                    decoration: InputDecoration(
                      hintText: "Type a message...",
                      hintStyle: TextStyle(color: Colors.green),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24.0),
                        borderSide: BorderSide(color: Colors.green, width: 2.0),
                      ),
                      contentPadding: EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 12.0),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _speechToText.isNotListening
                              ? Icons.mic_off
                              : Icons.mic,
                          color: Colors.green,
                        ),
                        onPressed: _speechToText.isNotListening
                            ? _startListening
                            : _stopListening,
                      ),
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send, color: Colors.green),
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class MessageReceived extends StatelessWidget {
  final String message;
  const MessageReceived({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0, left: 12),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Container(
          padding: EdgeInsets.all(16.0),
          margin: EdgeInsets.symmetric(vertical: 4.0),
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.7,
          ),
          decoration: BoxDecoration(
            color: Colors.transparent,
            border: Border.all(
              color: Color(0xFF2FF761),
              width: 2.0,
            ),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(24.0),
              topRight: Radius.circular(24.0),
              bottomLeft: Radius.circular(0.0),
              bottomRight: Radius.circular(24.0),
            ),
          ),
          child: Text(
            message,
            style: TextStyle(
                color: Color(0xFF2FF761),
                fontSize: 16,
                fontWeight: FontWeight.w600),
          ),
        ),
      ),
    );
  }
}

class LoadingMessage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0, left: 12),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Container(
          padding: EdgeInsets.all(16.0),
          margin: EdgeInsets.symmetric(vertical: 4.0),
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.7,
          ),
          decoration: BoxDecoration(
            color: Colors.transparent,
            border: Border.all(
              color: Color(0xFF2FF761),
              width: 2.0,
            ),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(24.0),
              topRight: Radius.circular(24.0),
              bottomLeft: Radius.circular(0.0),
              bottomRight: Radius.circular(24.0),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF2FF761)),
                strokeWidth: 2.0,
              ),
              SizedBox(width: 10),
              Text(
                "Processing...",
                style: TextStyle(
                  color: Color(0xFF2FF761),
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MessageSent extends StatelessWidget {
  final String message;
  const MessageSent({
    super.key,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0, right: 12),
      child: Align(
        alignment: Alignment.centerRight,
        child: Container(
          padding: EdgeInsets.all(16.0),
          margin: EdgeInsets.symmetric(vertical: 4.0),
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.7,
          ),
          decoration: BoxDecoration(
            color: Color(0xFF133E1E),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(24.0),
              topRight: Radius.circular(24.0),
              bottomLeft: Radius.circular(24.0),
              bottomRight: Radius.circular(0),
            ),
          ),
          child: Text(
            message,
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
        ),
      ),
    );
  }
}
