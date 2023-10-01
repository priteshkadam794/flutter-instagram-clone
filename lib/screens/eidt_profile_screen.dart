import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagram_clone/resources/firestore_methods.dart';
import 'package:instagram_clone/utils/colors.dart';
import 'package:instagram_clone/utils/utils.dart';
import 'package:instagram_clone/widgets/edit_profile_textfield.dart';

class EditProfileScreen extends StatefulWidget {
  final dynamic snap;
  const EditProfileScreen({
    super.key,
    required this.snap,
  });

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  Uint8List? _file;

  _editProfile() async {
    String res = await FirestoreMethods().updateProfile(widget.snap['uid'],
        _file, _nameController.text.toString(), _bioController.text.toString());

    if (res == "success") {
      if (!context.mounted) return;
      showSnackBar(context, "Profile updated Successfully");
      Navigator.of(context).pop();
    } else {
      if (!context.mounted) return;
      showSnackBar(context, res);
    }
  }

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

  @override
  void dispose() {
    super.dispose();
    _nameController.dispose();
    _bioController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        centerTitle: false,
        title: const Text("Edit profile"),
        actions: [
          InkWell(
            splashColor: Colors.transparent,
            onTap: () async {
              await _editProfile();
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: const Icon(
                Icons.done_rounded,
                size: 30,
                color: blueColor,
              ),
            ),
          )
        ],
      ),
      body: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
        const Spacer(
          flex: 1,
        ),
        Stack(clipBehavior: Clip.none, children: [
          _file == null
              ? CircleAvatar(
                  radius: 50,
                  backgroundImage: NetworkImage(widget.snap['photoUrl']),
                )
              : CircleAvatar(
                  radius: 50,
                  backgroundImage: MemoryImage(_file!),
                ),
          Positioned(
            bottom: -8,
            right: -8,
            child: CircleAvatar(
              backgroundColor: mobileSearchColor,
              child: IconButton(
                onPressed: () {
                  _selectImage(context);
                },
                icon: const Icon(
                  Icons.edit,
                  size: 26,
                ),
              ),
            ),
          )
        ]),
        const SizedBox(
          height: 30,
        ),
        EditField(
          controller: _nameController,
          labelText: "Name",
          initialValue: widget.snap['username'],
        ),
        EditField(
          controller: _bioController,
          labelText: "Bio",
          initialValue: widget.snap['bio'],
        ),
        const Spacer(
          flex: 8,
        ),
      ]),
    );
  }
}
