import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:instagram_clone/resources/auth_methods.dart';
import 'package:instagram_clone/responsive_layout/mobile_screen_layout.dart';
import 'package:instagram_clone/responsive_layout/responsive_layout.dart';
import 'package:instagram_clone/responsive_layout/web_screen_layout.dart';
import 'package:instagram_clone/screens/sign_up_screen.dart';
import 'package:instagram_clone/utils/colors.dart';
import 'package:instagram_clone/utils/utils.dart';
import 'package:instagram_clone/widgets/text_field_input.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  void logIn() async {
    setState(() {
      _isLoading = true;
    });
    String res = await AuthMethods().logInUser(
        email: _emailController.text, password: _passwordController.text);

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

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          width: double.infinity,
          child: Column(
            children: [
              // some spaceing
              Flexible(
                flex: 2,
                child: Container(),
              ),
              //logo of the app
              SvgPicture.asset(
                "assets/Instagram_logo.svg",
                color: primaryColor,
              ),
              const SizedBox(
                height: 50,
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
              // button to login
              InkWell(
                onTap: logIn,
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
                          "Log in",
                          textAlign: TextAlign.center,
                        ),
                ),
              ),
              Flexible(
                flex: 2,
                child: Container(),
              ),
              // transition to signUp page
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: const Text("Don't have an account?"),
                  ),
                  GestureDetector(
                    onTap: (() {
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                        builder: (context) {
                          return const SignUpScreen();
                        },
                      ));
                    }),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child: const Text(
                        "Sign up.",
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
    );
  }
}
