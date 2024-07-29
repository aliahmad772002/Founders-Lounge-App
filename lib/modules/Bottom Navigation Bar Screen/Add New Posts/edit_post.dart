import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fouders_longe/Controlllers/post_controller.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../../constants/colors.dart';

class EditPost extends StatefulWidget {
  final String postID;
  final String postImage;

  const EditPost({Key? key, required this.postID, required this.postImage}) : super(key: key);

  @override
  State<EditPost> createState() => _EditPostState();
}

class _EditPostState extends State<EditPost> {
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
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          title: const Text(
            'Edit Post',
            style: TextStyle(
              color: Colors.black,
              fontSize: 25,
              fontWeight: FontWeight.bold,
            ),
          ),
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.black,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),),
        // resizeToAvoidBottomInset: false,
        body: Container(
          height: height,
          width: width,
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: pcontroller.captionController,
                  decoration: const InputDecoration(
                    hintText: 'Caption',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(18)),
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                // Show the picked image or Reselect button
                if (image != null)
                  Center(
                    child: InkWell(
                      onTap: () async {
                        await pickImage();
                        setState(() {}); // Force a rebuild
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
                        await pickImage();
                        setState(() {}); // Force a rebuild
                      },
                      child: Container(
                        height: height * 0.5,
                        width: width * 0.8,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(18),
                          image: DecorationImage(
                            image: NetworkImage(widget.postImage!),
                            fit: BoxFit.fill,
                          ),
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
                    onPressed: () {
                      pcontroller.updatePost(
                        image: image!,
                        postID: widget.postID,
                      );
                    },
                    child: const Text(
                      'Update Post',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
