import 'package:flutter/material.dart';
import 'package:speech_recognition/widgets/loading_message.dart';
import 'package:speech_recognition/widgets/message_received.dart';
import 'package:speech_recognition/widgets/message_sent.dart';

class WelcomingMessage extends StatelessWidget {
  const WelcomingMessage({
    super.key,
    required List<Map<String, dynamic>> messages,
  }) : _messages = messages;

  final List<Map<String, dynamic>> _messages;

  @override
  Widget build(BuildContext context) {
    return Expanded(
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
    );
  }
}
