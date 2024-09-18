import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sdp_project/models/user.dart' as model;
import 'package:sdp_project/resources/storage_method.dart';
import 'package:local_auth/local_auth.dart';
class UserAuth {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final LocalAuthentication auth = LocalAuthentication();

  // get user details
  Future<Map<String, dynamic>> getUser() async {
    User currentUser = _auth.currentUser!;

    DocumentSnapshot documentSnapshot =
    await _firestore.collection('users').doc(currentUser.uid).get();
    var snapshot = documentSnapshot.data() as Map<String, dynamic>;
    return snapshot;
  }

  // Signing Up User

  Future<String> signUp({
    required String email,
    required String password,
    required String username,
    required String name,
    required String bio,
    required Uint8List file,
  }) async {
    String res = "Some error Occurred";
    try {
      if (email.isNotEmpty &&
          password.isNotEmpty &&
          username.isNotEmpty &&
          bio.isNotEmpty &&
          name.isNotEmpty &&
          file != null) {
        // registering user in auth with email and password
        UserCredential cred = await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );

        String photoUrl = await StorageMethods().uploadImageToStorage(
            'profilePics', file);

        model.User user = model.User(
          username: username,
          name: name,
          uid: cred.user!.uid,
          photoUrl: photoUrl,
          email: email,
          bio: bio,
          followers: [],
          following: [],
        );

        await _firestore
            .collection("users")
            .doc(cred.user!.uid)
            .set(user.toJson());

        res = "success";
      } else {
        res = "Please enter all the fields";
      }
    } catch (err) {
      return err.toString();
    }
    return res;
  }

  // logging in user
  Future<String> login({
    required String email,
    required String password,
  }) async {
    String res = "Some error Occurred";
    try {
      if (email.isNotEmpty && password.isNotEmpty) {
        // logging in user with email and password
        await _auth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );

        // Perform biometric or lock screen authentication
        bool authenticated = await _authenticateUser();

        if (authenticated) {
          res = "success";
        } else {
          res = "Authentication failed";
        }
      } else {
        res = "Please enter all the fields";
      }
    } catch (err) {
      return err.toString();
    }
    return res;
  }


  // Update user's bio in Firestore
  Future<String> updateBio({required String newBio}) async {
    String res = "Some error Occurred";
    try {
      User currentUser = _auth.currentUser!;
      // Update bio in Firestore
      await _firestore.collection('users').doc(currentUser.uid).update({
        'bio': newBio,
      });

      res = "Bio updated successfully";
    } catch (err) {
      return err.toString();
    }
    return res;
  }

  Future<bool> _authenticateUser() async {
    bool authenticated = false;
    try {
      // Check if the device can check biometrics and if it supports secure authentication (lock screen)
      bool canCheckBiometrics = await auth.canCheckBiometrics;
      bool isDeviceSupported = await auth.isDeviceSupported();

      // Check if there is any secure lock screen (password, PIN, or pattern) enabled
      bool hasLockScreen = await auth.isDeviceSupported();

      // Proceed if either biometrics or a secure lock screen is available
      if (canCheckBiometrics || hasLockScreen) {
        // Try to authenticate (biometric or fallback to lock screen password)
        authenticated = await auth.authenticate(
          localizedReason: 'Please authenticate to proceed',
          options: const AuthenticationOptions(
            stickyAuth: true,
            biometricOnly: false, // Allows fallback to lock screen password if biometrics fail
          ),
        );
      } else {
        // No secure lock screen set up, skip authentication
        print('No lock screen security is set. Skipping authentication.');
        return true;
      }
    } catch (e) {
      print('Error during authentication: $e');
    }
    return authenticated;
  }


  // Logout
  Future<void> logout() async {
    await _auth.signOut();
  }
}
