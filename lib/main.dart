import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/providers/user_providers.dart';
import 'package:instagram_clone/responsive_layout/mobile_screen_layout.dart';
import 'package:instagram_clone/responsive_layout/responsive_layout.dart';
import 'package:instagram_clone/responsive_layout/web_screen_layout.dart';
import 'package:instagram_clone/screens/login_screen.dart';
import 'package:instagram_clone/utils/colors.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    await Firebase.initializeApp(
        options: const FirebaseOptions(
            apiKey: "AIzaSyCvb-3jKH8PqwynvgB0szjxvoZDjRnbPK4",
            appId: "1:919160732038:web:9723b8cefdffb0658a5407",
            messagingSenderId: "919160732038",
            projectId: "instagram-clone-76476",
            storageBucket: "instagram-clone-76476.appspot.com"));
  } else {
    await Firebase.initializeApp();
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => UserProvider(),
        ),
      ],
      child: MaterialApp(
          title: "Instagram_clone",
          debugShowCheckedModeBanner: false,
          theme: ThemeData.dark().copyWith(
            scaffoldBackgroundColor: mobileBackgroundColor,
          ),
          // home: const MobileScreenLayout()));

          home: StreamBuilder(
              stream: FirebaseAuth.instance.authStateChanges(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.active) {
                  if (snapshot.hasData) {
                    return const ResponsiveLayout(
                      mobileViewLayout: MobileScreenLayout(),
                      webViewLayout: WebScreenLayout(),
                    );
                  }
                  if (snapshot.hasError) {
                    return const Center(
                      child: Text("some error occured"),
                    );
                  }
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator.adaptive(
                      backgroundColor: primaryColor,
                    ),
                  );
                }

                return const LoginScreen();
              })),
    );
  }
}
