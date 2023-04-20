import 'package:fire_base_app/helper/fire_base_helper.dart';
import 'package:fire_base_app/helper/local_notification_helpers.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Login_Page extends StatefulWidget {
  const Login_Page({Key? key}) : super(key: key);

  @override
  State<Login_Page> createState() => _Login_PageState();
}

class _Login_PageState extends State<Login_Page> {
  @override
  initNotification() async {
    await LocalNotificationHelper.localNotificationHelper
        .initLocalNotifications();
  }

  void initState() {
    super.initState();
    initNotification();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Login Page",
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
                onPressed: () async {
                  await LocalNotificationHelper.localNotificationHelper
                      .showSimpleNotification();
                },
                child: const Text("Simple Notification")),
            ElevatedButton(
                onPressed: () async {
                  await LocalNotificationHelper.localNotificationHelper
                      .showScheduleNotification();
                },
                child: const Text("Schedule Notification")),
            ElevatedButton(
                onPressed: () async {
                  await LocalNotificationHelper.localNotificationHelper
                      .showBigPictureNotification();
                },
                child: const Text("Big Picture Notification")),
            ElevatedButton(
                onPressed: () async {
                  await LocalNotificationHelper.localNotificationHelper
                      .showMediaStyleNotification();
                },
                child: const Text("Media Style Notification")),
            ElevatedButton(
              onPressed: () async {
                User? user = await FirebaseAuthHelper.firebaseAuthHelper
                    .logInAnonymously();

                if (user != null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      backgroundColor: Colors.green,
                      behavior: SnackBarBehavior.floating,
                      content: Text("Login Successfully..."),
                    ),
                  );
                  Navigator.of(context).pushReplacementNamed('/');
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      backgroundColor: Colors.redAccent,
                      behavior: SnackBarBehavior.floating,
                      content: Text("Login Failed..."),
                    ),
                  );
                }
              },
              child: const Text("Anonymous Login"),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {},
                  child: const Text("Sign Up"),
                ),
                ElevatedButton(
                  onPressed: () {},
                  child: const Text("Sign In"),
                ),
              ],
            ),
            ElevatedButton(
              onPressed: () {},
              child: const Text("SignUp With Google"),
            ),
          ],
        ),
      ),
    );
    // void validateAndSignUp() {
    //   showDialog(
    //     context: context,
    //     builder: (context) => AlertDialog(
    //       title: const Center(
    //         child: Text("Sign Up"),
    //       ),
    //       content: Form(
    //         key: signUpFormKey,
    //         child: Container(),
    //       ),
    //     ),
    //   );
    // }
  }
}
