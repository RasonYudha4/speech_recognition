import 'package:flutter/material.dart';

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
