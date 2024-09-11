import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sdp_project/resources/user_auth.dart';
import 'package:sdp_project/utils/util.dart';


class SignupPage extends StatefulWidget {
  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  // used to manage and interact with the state of a Form widget.
  // By associating a Form with a GlobalKey<FormState>, we can access the FormState and perform operations such as validation or saving the form.
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _bioController = TextEditingController();
  final _nameController = TextEditingController();
  Uint8List ? _image;
  bool _isLoading = false;
  void signUpUser() async {
    // set loading to true

    // signup user using our authmethodds
    String res = await UserAuth().signUp(
        email: _emailController.text,
        password: _passwordController.text,
        username: _usernameController.text,
        bio: _bioController.text,
        file: _image!);
    // if string returned is sucess, user has been created
    if (res == "success") {

      // navigate to the login screen
      Navigator.pushReplacementNamed(context, '/login');
    } else {

      // show the error
      if (context.mounted) {
        showSnackBar(context, res);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Center(
              child: Text('Signup')
          ),
          backgroundColor: Colors.teal
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                GestureDetector(
                  onTap: () async {
                    Uint8List? im = await pickImage(ImageSource.gallery);
                    if(im == null){
                      im = await networkImageToUint8List("https://upload.wikimedia.org/wikipedia/commons/a/ac/Default_pfp.jpg?20200418092106");
                    }
                    setState(() {
                      _image = im;
                    });
                  },
                  child: CircleAvatar(
                    backgroundColor: Colors.teal,
                    radius: 60,
                    backgroundImage: _image != null ? MemoryImage(_image!): NetworkImage(
                        'https://i.stack.imgur.com/l60Hf.png'),
                    child: _image == null ? Icon(Icons.account_circle, size: 60) : null,
                  ),
                ),
                SizedBox(height: 20),
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(labelText: 'Name'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your name';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _usernameController,
                  decoration: InputDecoration(labelText: 'Username'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a username';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(labelText: 'Email'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter an email';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _passwordController,
                  decoration: InputDecoration(labelText: 'Password'),
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a password';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _bioController,
                  decoration: InputDecoration(labelText: 'Bio'),
                  validator: (value){
                    if(value == null || value.isEmpty){
                      return "Bio is needed";
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {

                      signUpUser();
                    }
                  },
                  child: Text('Sign Up',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ))
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      child: Text("Already have an account ?"),
                      padding: const EdgeInsets.symmetric(vertical: 8),

                    ),
                    const SizedBox(width: 4,),
                    GestureDetector(
                      onTap: (){
                        Navigator.pushReplacementNamed(context, '/login');
                      },
                      child: Container(
                        child: Text(
                          "Login",
                          style: TextStyle(
                            fontWeight: FontWeight.bold
                          ),
                        ),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
