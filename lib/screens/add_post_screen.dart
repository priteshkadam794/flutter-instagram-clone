import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagram_clone/models/user.dart';
import 'package:instagram_clone/providers/user_providers.dart';
import 'package:instagram_clone/resources/firestore_methods.dart';
import 'package:instagram_clone/utils/colors.dart';
import 'package:instagram_clone/utils/utils.dart';
import 'package:provider/provider.dart';

class AddPostScreen extends StatefulWidget {
  const AddPostScreen({super.key});

  @override
  State<AddPostScreen> createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  final TextEditingController captionController = TextEditingController();
  Uint8List? _file;
  bool _isPosted = true;
  _selectImage(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
            backgroundColor: mobileSearchColor,
            alignment: Alignment.center,
            title: const Center(child: Text("Select a File")),
            children: [
              SimpleDialogOption(
                onPressed: (() async {
                  Navigator.of(context).pop();
                  Uint8List? file = await pickImage(ImageSource.gallery);
                  setState(() {
                    _file = file;
                  });
                }),
                child: const Center(child: Text("Choose from Gallery")),
              ),
              SimpleDialogOption(
                onPressed: (() async {
                  Navigator.of(context).pop();
                  Uint8List? file = await pickImage(ImageSource.camera);
                  setState(() {
                    _file = file;
                  });
                }),
                child: const Center(child: Text("Take a photo")),
              ),
              SimpleDialogOption(
                onPressed: (() {
                  Navigator.of(context).pop();
                }),
                child: const Center(child: Text("Cancel")),
              )
            ],
          );
        });
  }

  void uploadPost(
    String photoUrl,
    String username,
    String uid,
  ) async {
    setState(() {
      _isPosted = false;
    });
    try {
      String res = await FirestoreMethods()
          .uploadPost(captionController.text, photoUrl, username, uid, _file!);

      if (res == "success") {
        setState(() {
          captionController.clear();
          _isPosted = true;
          _file = null;
        });
        // ignore: use_build_context_synchronously
        showSnackBar(context, "Posted!!");
      } else {
        setState(() {
          _isPosted = true;
          _file = null;
        });
        // ignore: use_build_context_synchronously
        showSnackBar(context, res);
      }
    } catch (e) {
      setState(() {
        _isPosted = true;
        _file = null;
      });
      // ignore: use_build_context_synchronously
      showSnackBar(context, e.toString());
    }
  }

  @override
  void dispose() {
    super.dispose();
    captionController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final User user = Provider.of<UserProvider>(context).getUser;
    return _file == null
        ? Center(
            child: IconButton(
                onPressed: () => _selectImage(context),
                icon: const Icon(Icons.upload)),
          )
        : Scaffold(
            appBar: AppBar(
              elevation: 0,
              backgroundColor: mobileBackgroundColor,
              centerTitle: false,
              title: const Text("Post to"),
              leading: IconButton(
                onPressed: () {
                  setState(() {
                    _file = null;
                  });
                },
                icon: const Icon(Icons.arrow_back),
              ),
              actions: [
                TextButton(
                  onPressed: () =>
                      uploadPost(user.photoUrl, user.username, user.uid),
                  child: const Text(
                    "Post",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            body: Column(
              children: [
                SizedBox(
                  child: _isPosted == false
                      ? const LinearProgressIndicator()
                      : null,
                ),
                const SizedBox(
                  height: 8,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // displaying the profile pic
                    CircleAvatar(
                      backgroundImage: NetworkImage(user.photoUrl),
                    ),
                    // textfield for caption
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.5,
                      child: TextField(
                        controller: captionController,
                        decoration: const InputDecoration(
                          hintText: "Write a caption...",
                          border: InputBorder.none,
                        ),
                        maxLines: 8,
                      ),
                    ),
                    // post image
                    SizedBox(
                      width: 45,
                      height: 45,
                      child: AspectRatio(
                        aspectRatio: 487 / 451,
                        child: Container(
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              fit: BoxFit.fill,
                              alignment: FractionalOffset.topCenter,
                              image: MemoryImage(_file!),
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ],
            ),
          );
  }
}
