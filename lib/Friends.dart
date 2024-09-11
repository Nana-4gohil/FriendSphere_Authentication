import 'package:flutter/material.dart';

class FriendsPage extends StatelessWidget {
  final List<Map<String, String>> friends = [
    {'name': 'Nana Gohil', 'status': 'Online'},
    {'name': 'Darshit Talsaniya', 'status': 'Offline'},
    {'name': 'Milan Vadhel', 'status': 'Online'},
    {'name': 'Dev Shah', 'status': 'Offline'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Friends'),
        backgroundColor: Colors.teal,
      ),
      body: ListView.builder(
        itemCount: friends.length,
        itemBuilder: (context, index) {
          return Card(
            margin: EdgeInsets.all(10),
            child: ListTile(
              leading: CircleAvatar(
                radius: 40,
                child: Icon(Icons.account_circle_sharp),
                backgroundColor: Colors.teal[200],
              ),
              title: Text(friends[index]['name']!),
              subtitle: Text(friends[index]['status']!),
            ),
          );
        },
      ),
    );
  }
}
