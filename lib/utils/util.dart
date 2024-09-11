import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:typed_data';
import 'package:http/http.dart' as http;

// for picking up image from gallery
pickImage(ImageSource source) async {
  final ImagePicker imagePicker = ImagePicker();
  XFile? file = await imagePicker.pickImage(source: source);
  if (file != null) {
    return await file.readAsBytes();
  }
}

showSnackBar(BuildContext context, String text) {
  return ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(text),
    ),
  );
}


Future<Uint8List?> networkImageToUint8List(String imageUrl) async {
  try {
    // Fetch the image from the network
    final http.Response response = await http.get(Uri.parse(imageUrl));

    if (response.statusCode == 200) {
      // Convert the response body to Uint8List
      return response.bodyBytes;
    } else {
      print('Error fetching image: ${response.statusCode}');
      return null;
    }
  } catch (e) {
    print('Exception fetching image: $e');
    return null;
  }
}
