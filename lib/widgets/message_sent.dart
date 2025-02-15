import 'package:flutter/material.dart';

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
