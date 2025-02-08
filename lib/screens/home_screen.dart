import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

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
            child: ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 12.0, right: 12),
                  child: Align(
                    alignment: Alignment.centerRight, // Align to the left
                    child: Container(
                      padding: EdgeInsets.all(16.0),
                      margin: EdgeInsets.symmetric(vertical: 4.0),
                      constraints: BoxConstraints(
                        maxWidth: MediaQuery.of(context).size.width *
                            0.7, // Max 70% of screen width
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
                        "Hello, how are you? I hope that you are doing well, since I miss you a lot. Remember the day when we have our first night",
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ),
                  ),
                ),
                Padding(
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
                        "I'm good",
                        style: TextStyle(
                            color: Color(0xFF2FF761),
                            fontSize: 16,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                ),
              ],
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
                    style: TextStyle(color: Colors.green), // Typed text color
                    decoration: InputDecoration(
                      hintText: "Type a message...",
                      hintStyle:
                          TextStyle(color: Colors.green), // Hint text color
                      border: OutlineInputBorder(
                        borderRadius:
                            BorderRadius.circular(24.0), // Rounded border
                        borderSide: BorderSide(
                            color: Colors.green, width: 2.0), // Green border
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24.0),
                        borderSide: BorderSide(
                            color: Colors.green,
                            width: 2.0), // Green border when not focused
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24.0),
                        borderSide: BorderSide(
                            color: Colors.green,
                            width: 2.5), // Green border when focused
                      ),
                      contentPadding: EdgeInsets.symmetric(
                          horizontal: 16.0,
                          vertical: 12.0), // Padding inside the field
                      suffixIcon: IconButton(
                        icon: Icon(Icons.mic, color: Colors.green),
                        onPressed: () {
                          print("Microphone button pressed!");
                        },
                      ),
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send, color: Colors.green),
                  onPressed: () {
                    // Handle send message
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
