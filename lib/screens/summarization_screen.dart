import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:speech_recognition/widgets/loading_message.dart';
import 'package:speech_recognition/widgets/message_received.dart';
import 'package:speech_recognition/widgets/message_sent.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../services/api_service.dart';

class SummarizationScreen extends StatefulWidget {
  const SummarizationScreen({super.key});

  @override
  State<SummarizationScreen> createState() => _SummarizationScreenState();
}

class _SummarizationScreenState extends State<SummarizationScreen> {
  final TextEditingController _controller = TextEditingController();
  final APIService _apiService = APIService();
  SpeechToText _speechToText = SpeechToText();
  bool _speechEnabled = false;
  List<Map<String, dynamic>> _messages = [];

  @override
  void initState() {
    super.initState();
    _loadChatHistory();
  }

  Future<void> _pickFile(String fileType) async {
    FilePickerResult? result;
    final ImagePicker picker = ImagePicker();
    File? file;

    if (fileType == 'PDF') {
      result = await FilePicker.platform.pickFiles(type: FileType.any);
      if (result != null && result.files.isNotEmpty) {
        file = File(result.files.single.path!);
      }
    } else if (fileType == 'Image') {
      XFile? image = await picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        file = File(image.path);
      }
    } else if (fileType == 'Camera') {
      XFile? image = await picker.pickImage(source: ImageSource.camera);
      if (image != null) {
        file = File(image.path);
      }
    }

    if (file != null) {
      _sendFile(file, fileType);
    }
  }

  void _sendFile(File file, String fileType) async {
    setState(() {
      _messages
          .add({'type': 'sent', 'message': 'Sent a $fileType', 'file': file});
      _messages.add({'type': 'loading'});
    });

    try {
      String response = await _apiService.extractTextFromImage(file);
      setState(() {
        _messages.removeWhere((msg) => msg['type'] == 'loading');
        _messages.add({'type': 'received', 'message': response});
      });
    } catch (e) {
      setState(() {
        _messages.removeWhere((msg) => msg['type'] == 'loading');
        _messages
            .add({'type': 'received', 'message': 'Error uploading file: $e'});
      });
    }
  }

  void _sendMessage() async {
    String message = _controller.text.trim();
    if (message.isEmpty) return;

    setState(() {
      _messages.add({'type': 'sent', 'message': message});
      _messages.add({'type': 'loading'});
    });

    _controller.clear();

    try {
      String summary = await _apiService.summarizeText(message);
      print("API Response: $summary");

      setState(() {
        _messages.removeWhere((msg) => msg['type'] == 'loading');
        _messages.add({'type': 'received', 'message': summary});
      });

      _saveChatSession();
    } catch (e) {
      print("Error calling API: $e");
      setState(() {
        _messages.removeWhere((msg) => msg['type'] == 'loading');
        _messages
            .add({'type': 'received', 'message': 'Error processing request.'});
      });
    }
  }

  Future<void> _loadChatHistory() async {
    final prefs = await SharedPreferences.getInstance();
    List<String>? chatHistory = prefs.getStringList('chat_history');

    if (chatHistory != null) {
      setState(() {
        _messages = chatHistory.map((msg) {
          var parts = msg.split(':');
          return {'type': parts[0], 'message': parts.sublist(1).join(':')};
        }).toList();
      });
    }
  }

  Future<void> _saveChatSession() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> chatHistory =
        _messages.map((msg) => '${msg['type']}:${msg['message']}').toList();
    await prefs.setStringList('chat_history', chatHistory);
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
      endDrawer: Drawer(
        child: Container(
          color: Colors.black,
          child: Column(
            children: [
              SizedBox(
                height: 140,
                child: DrawerHeader(
                  decoration: BoxDecoration(color: Color(0xFF133E1E)),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 24,
                        backgroundColor: Colors.white,
                        child: CircleAvatar(
                          radius: 28,
                          backgroundColor: Colors.grey[800],
                          child:
                              Icon(Icons.person, size: 30, color: Colors.white),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Container(
                          width: 180,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "You're not yet logged in",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold),
                              ),
                              Text(
                                'Login to access your chats anywhere',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 10),
                                softWrap: true,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: ListView(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text("Chat History",
                          style: TextStyle(color: Colors.white, fontSize: 18)),
                    ),
                    ..._messages
                        .where((msg) => msg['type'] == 'sent')
                        .map((msg) {
                      return Container(
                        decoration: BoxDecoration(
                          border: Border(
                              bottom:
                                  BorderSide(color: Colors.white24, width: 1)),
                        ),
                        child: ListTile(
                          contentPadding:
                              EdgeInsets.symmetric(horizontal: 20.0),
                          leading: Icon(Icons.chat, color: Colors.white),
                          title: Text(
                            msg['message'],
                            style: TextStyle(color: Colors.white),
                            overflow: TextOverflow.ellipsis,
                          ),
                          onTap: () {
                            setState(() {
                              _controller.text =
                                  msg['message']; // Load chat in input
                            });
                            Navigator.pop(context);
                          },
                        ),
                      );
                    }).toList(),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Text(
                      "Start New Chat",
                      style: TextStyle(color: Colors.white54, fontSize: 12),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 30, right: 25, left: 25),
            child: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              title: Text(
                'Summarizon AI',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2FF761),
                ),
              ),
              centerTitle: true,
              actions: [
                Builder(
                  builder: (context) => IconButton(
                    icon: Icon(
                      Icons.menu_rounded,
                      color: Color(0xFF2FF761),
                      size: 32,
                    ),
                    onPressed: () {
                      Scaffold.of(context).openEndDrawer();
                    },
                  ),
                ),
              ],
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
                  return LoadingMessage();
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
                  onSelected: (value) => _pickFile(value),
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
                      value: 'PDF',
                      child: Row(
                        children: [
                          Icon(
                            Icons.insert_drive_file,
                            color: Color(0xFF50E776),
                          ),
                          SizedBox(width: 10),
                          Text(
                            "Upload PDF",
                            style: TextStyle(
                              color: Color(0xFF50E776),
                            ),
                          ),
                        ],
                      ),
                    ),
                    PopupMenuItem(
                        value: 'Camera',
                        child: Row(
                          children: [
                            Icon(
                              Icons.camera_alt_rounded,
                              color: Color(0xFF50E776),
                            ),
                            SizedBox(width: 10),
                            Text(
                              "Take a Picture",
                              style: TextStyle(
                                color: Color(0xFF50E776),
                              ),
                            ),
                          ],
                        ))
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
