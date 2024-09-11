import 'package:flutter/material.dart';

class LikedPostsPage extends StatelessWidget {
  final List<Map<String, String>> likedPosts = [
    {'title': 'Olympics - 2024', 'description': 'India won 5 bronze and 1 silver medal.'},
    {'title': 'IPL - 2024', 'description': 'KKR won by defeating SRK in TATA IPL FINAL'},
    {'title': 'GATE - 2025', 'description': 'GATE - 2025 to be taken on 1, 2, 15, 16 Feb 2025'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Liked Posts'),
        backgroundColor: Colors.teal,
      ),
      body: ListView.builder(
        itemCount: likedPosts.length,
        itemBuilder: (context, index) {
          return Card(
            margin: EdgeInsets.all(10),
            child: ListTile(
              leading: Icon(Icons.favorite, color: Colors.red),
              title: Text(likedPosts[index]['title']!),
              subtitle: Text(likedPosts[index]['description']!),
            ),
          );
        },
      ),
    );
  }
}
