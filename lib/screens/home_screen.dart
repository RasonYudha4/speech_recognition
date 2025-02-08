import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF021907), // Background color of the Scaffold
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: AppBar(
              backgroundColor:
                  Colors.transparent, // Make AppBar background transparent
              elevation: 0, // Remove shadow
              flexibleSpace: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Leading icon
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 16.0), // Add some padding
                    child: IconButton(
                      icon: Icon(
                        Icons.chevron_left_rounded,
                        color: Color(0xFF2FF761),
                        size: 50,
                      ),
                      onPressed: () {
                        Navigator.pop(context); // Navigate back when pressed
                      },
                    ),
                  ),
                  // Title
                  Center(
                    child: Text(
                      'Summarizor AI',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2FF761),
                      ),
                    ),
                  ),
                  // Action icon
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
                          value: 'Option 1',
                          child: SizedBox(
                            width: 150, // Set width
                            height: 50, // Set height
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
                          value: 'Option 2',
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
                // Chat messages go here
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(top: BorderSide(color: Colors.grey.shade300)),
            ),
            child: Row(
              children: [
                PopupMenuButton<String>(
                  icon: Icon(Icons.attach_file, color: Colors.grey),
                  onSelected: (value) {
                    print("Selected: $value");
                  },
                  color: Colors.white, // Background color of dropdown
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(12.0), // Rounded corners
                  ),
                  itemBuilder: (BuildContext context) =>
                      <PopupMenuEntry<String>>[
                    PopupMenuItem<String>(
                      value: 'Image',
                      child: Row(
                        children: [
                          Icon(Icons.image, color: Colors.blue),
                          SizedBox(width: 10),
                          Text("Image"),
                        ],
                      ),
                    ),
                    PopupMenuItem<String>(
                      value: 'Video',
                      child: Row(
                        children: [
                          Icon(Icons.videocam, color: Colors.red),
                          SizedBox(width: 10),
                          Text("Video"),
                        ],
                      ),
                    ),
                    PopupMenuItem<String>(
                      value: 'Document',
                      child: Row(
                        children: [
                          Icon(Icons.insert_drive_file, color: Colors.green),
                          SizedBox(width: 10),
                          Text("Document"),
                        ],
                      ),
                    ),
                  ],
                ),
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: "Type a message...",
                      border: InputBorder.none,
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
