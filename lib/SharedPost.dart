import 'package:flutter/material.dart';

class SharedPostsPage extends StatelessWidget {
  final List<Map<String, String>> sharedPosts = [
    {'title': 'Olympics - 2024', 'description': 'India won 5 bronze and 1 silver medal.'},
    {'title': 'IPL - 2024', 'description': 'KKR won by defeating SRH in TATA IPL FINAL'},
    {'title': 'GATE - 2025', 'description': 'GATE - 2025 to be taken on 1, 2, 15, 16 Feb 2025'},
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Shared Posts'),
        backgroundColor: Colors.teal,
      ),
      body: ListView.builder(
        itemCount: sharedPosts.length,
        itemBuilder: (context, index) {
          return Card(
            margin: EdgeInsets.all(10),
            child: ListTile(
              leading: const Icon(Icons.share, color: Colors.blue),
              title: Text(sharedPosts[index]['title']!),
              subtitle: Text(sharedPosts[index]['description']!),
            ),
          );
        },
      ),
    );
  }
}
