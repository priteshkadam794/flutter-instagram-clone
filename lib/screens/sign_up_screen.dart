import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagram_clone/resources/auth_methods.dart';
import 'package:instagram_clone/responsive_layout/mobile_screen_layout.dart';
import 'package:instagram_clone/responsive_layout/responsive_layout.dart';
import 'package:instagram_clone/responsive_layout/web_screen_layout.dart';
import 'package:instagram_clone/screens/login_screen.dart';
import 'package:instagram_clone/utils/colors.dart';
import 'package:instagram_clone/utils/utils.dart';
import 'package:instagram_clone/widgets/text_field_input.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  Uint8List? _image;
  bool _isLoading = false;
  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _bioController.dispose();
    _userNameController.dispose();
    super.dispose();
  }

  void signUpUser() async {
    setState(() {
      _isLoading = true;
    });
    String res = await AuthMethods().createUser(
        email: _emailController.text,
        userName: _userNameController.text,
        bio: _bioController.text,
        password: _passwordController.text,
        file: _image!);

    if (res != 'success') {
      // ignore: use_build_context_synchronously
      showSnackBar(context, res);
    } else {
      // ignore: use_build_context_synchronously
      Navigator.of(context)
          .pushReplacement(MaterialPageRoute(builder: (context) {
        return const ResponsiveLayout(
          mobileViewLayout: MobileScreenLayout(),
          webViewLayout: WebScreenLayout(),
        );
      }));
    }
    setState(() {
      _isLoading = false;
    });
  }

  void selectImage() async {
    Uint8List? image = await pickImage(ImageSource.gallery);
    setState(() {
      _image = image;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          reverse: true,
          physics: const BouncingScrollPhysics(),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            width: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // some spaceing

                const SizedBox(
                  height: 60,
                ),
                //logo of the app
                SvgPicture.asset(
                  "assets/Instagram_logo.svg",
                  color: primaryColor,
                ),
                const SizedBox(
                  height: 50,
                ),

                // profile pic
                Stack(
                  children: [
                    _image == null
                        ? const CircleAvatar(
                            radius: 64,
                            backgroundImage:
                                AssetImage('assets/profile_image.jpg'),
                          )
                        : CircleAvatar(
                            radius: 64,
                            backgroundImage: MemoryImage(_image!),
                          ),
                    Positioned(
                      bottom: 2,
                      right: -4,
                      child: IconButton(
                          iconSize: 26,
                          onPressed: selectImage,
                          icon: const Icon(Icons.add_a_photo)),
                    )
                  ],
                ),
                const SizedBox(
                  height: 30,
                ),
                //text field input for userName
                TextFieldInput(
                  textEditingController: _userNameController,
                  hintText: "Enter your username",
                ),
                const SizedBox(
                  height: 24,
                ),
                //text field input for email
                TextFieldInput(
                  textEditingController: _emailController,
                  hintText: "Enter your email",
                ),
                const SizedBox(
                  height: 24,
                ),
                // text-field input for password
                TextFieldInput(
                  textEditingController: _passwordController,
                  hintText: "Enter your password",
                  isPass: true,
                ),
                const SizedBox(
                  height: 24,
                ),
                //text field input for bio
                TextFieldInput(
                  textEditingController: _bioController,
                  hintText: "Enter your bio",
                ),
                const SizedBox(
                  height: 24,
                ),
                // button to login
                InkWell(
                  onTap: (() => signUpUser()),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    width: double.infinity,
                    decoration: ShapeDecoration(
                      color: blueColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    child: _isLoading
                        ? const Center(
                            child: CircularProgressIndicator.adaptive(
                              backgroundColor: primaryColor,
                            ),
                          )
                        : const Text(
                            "Sign Up",
                            textAlign: TextAlign.center,
                          ),
                  ),
                ),
                const SizedBox(
                  height: 60,
                ),
                // transition to signUp page
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child: const Text("Have an account? "),
                    ),
                    GestureDetector(
                      onTap: (() {
                        Navigator.of(context).pushReplacement(
                            MaterialPageRoute(builder: (context) {
                          return const LoginScreen();
                        }));
                      }),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        child: const Text(
                          "Log in.",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
