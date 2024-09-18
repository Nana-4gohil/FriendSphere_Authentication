import 'LikedPost.dart';
import 'SharedPost.dart';
import 'Friends.dart';
import 'package:flutter/material.dart';
import 'package:sdp_project/resources/user_auth.dart';
import 'Login.dart'; // Import your login screen here

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Map<String, dynamic> user = {};

  Future<void> getUser() async {
    try {
      var res = await UserAuth().getUser();
      setState(() {
        user = res;
      });
    } catch (err) {
      print(err);
    }
  }

  @override
  void initState() {
    super.initState();
    getUser();
  }

  Future<void> _logout() async {
    await UserAuth().logout();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()), // Redirect to login screen
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Welcome, ${user['name']}!'),
        backgroundColor: Colors.teal,
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: _logout, // Calls the logout method
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Center(
                child: GestureDetector(
                  onTap: () => {},
                  child: CircleAvatar(
                    backgroundColor: Colors.teal,
                    radius: 60,
                    backgroundImage: user['photoUrl'] != null
                        ? NetworkImage(user['photoUrl'])
                        : NetworkImage('https://i.stack.imgur.com/l60Hf.png'),
                    child: user['photoUrl'] == null
                        ? const Icon(Icons.account_circle, size: 60)
                        : null,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Center(
                child: Text(
                  user['username'] ?? '',
                  style: const TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Center(
                      child: Text(
                        user['email'] ?? 'abc@gmail.com',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              Divider(color: Colors.teal),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Bio',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.edit, color: Colors.teal),
                    onPressed: () => _editField('Bio', user['bio'] ?? '',
                            (value) {
                          setState(() {
                            UserAuth().updateBio(newBio: value);
                            getUser();
                          });
                        }),
                  ),
                ],
              ),
              SizedBox(height: 10),
              Text(
                user['bio'] ?? '',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 20),
              Divider(color: Colors.teal),
              SizedBox(height: 20),
              Text(
                'Your Activity',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10),
              _buildActivityCard('Liked Posts', Icons.thumb_up, LikedPostsPage(),
                  context),
              SizedBox(height: 10),
              _buildActivityCard(
                  'Shared Posts', Icons.share, SharedPostsPage(), context),
              SizedBox(height: 10),
              _buildActivityCard(
                  'Friends', Icons.people, FriendsPage(), context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActivityCard(
      String title, IconData icon, Widget page, BuildContext context) {
    return Card(
      color: Colors.teal[100],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      elevation: 4,
      child: ListTile(
        leading: Icon(icon, color: Colors.teal, size: 30),
        title: Text(
          title,
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        trailing: Icon(Icons.arrow_forward_ios, color: Colors.teal),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => page),
          );
        },
      ),
    );
  }

  void _editField(String title, String initialValue, Function(String) onSave) {
    final controller = TextEditingController(text: initialValue);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Edit $title'),
        content: TextField(
          controller: controller,
          decoration: InputDecoration(hintText: 'Enter new $title'),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              onSave(controller.text);
              Navigator.pop(context);
            },
            child: Text('Save'),
          ),
        ],
      ),
    );
  }
}
