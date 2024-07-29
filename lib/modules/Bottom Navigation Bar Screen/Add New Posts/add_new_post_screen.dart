

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fouders_longe/Controlllers/post_controller.dart';
import 'package:fouders_longe/constants/colors.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class AddScreen extends StatefulWidget {
  const AddScreen({super.key});

  @override
  State<AddScreen> createState() => _AddScreenState();
}

class _AddScreenState extends State<AddScreen> {
  final pcontroller = Get.put(PostController());

  // Image variables for profile picture.
  File? image;
  final picker = ImagePicker();

  Future<void> pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      image = File(pickedFile.path);
    }
    setState(() {});
  }


  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          automaticallyImplyLeading: false,
          title: const Text(
            'Add New Post',
            style: TextStyle(
              color: Colors.black,
              fontSize: 25,
              fontWeight: FontWeight.bold,
            ),
          ),
      ),
      body: Container(
        height: height,
        width: width,
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 15, right: 15),
                child: TextField(
                  controller: pcontroller.captionController,
                  decoration: const InputDecoration(
                    hintText: 'Caption',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(18)),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 30),
              // Show the picked image or Reselect button
              if (image != null)
                Center(
                  child: InkWell(
                    onTap: () async {
                      pickImage();
                    },
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(18),
                      child: Image.file(
                        image!,
                        height: height * 0.5,
                        width: width * 0.8,
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                )
              else
                Center(
                  child: InkWell(
                    onTap: () async {
                      pickImage();
                    },
                    child: Container(
                      height: height * 0.5,
                      width: width * 0.8,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: const Center(
                        child: Text('Select Image'),
                      ),
                    ),
                  ),
                ),
              const SizedBox(height: 20),
              // Button to post data to Firebase
              Padding(
                padding: const EdgeInsets.all(20),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: color2,
                    minimumSize: const Size(double.infinity, 50),
                  ),
                  onPressed: () async {
                    if (image != null && pcontroller.captionController.text.isNotEmpty) {
                      await pcontroller.postTask(image: image!);
                      setState(() {
                        image = null;
                      });
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Please select an image and add a caption.'),
                          duration: Duration(seconds: 2),
                        ),
                      );
                    }
                  },
                  child: const Text(
                    'Upload',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
