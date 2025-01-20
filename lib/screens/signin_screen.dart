import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:todoapp/models/user.dart';
import 'package:todoapp/widgets/alert_message.dart';
import 'package:todoapp/widgets/app_button.dart';
import 'package:todoapp/widgets/app_textfield.dart';

import '../widgets/logo_with_name.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  //username text controller
  final TextEditingController usernameController = TextEditingController();

  //password text controller
  final TextEditingController passwordController = TextEditingController();

  //Sign Up tap function
  void signUpOnTap(BuildContext context) {
    Navigator.of(context).pushReplacementNamed('signup');
  }

  late dynamic box;

  //Login tap function
  void loginOnTap() {
    String username = usernameController.text;
    String password = passwordController.text;
    if (username.isNotEmpty && password.isNotEmpty) {
      //convert box values to list
      List<User> users = box.values.toList();
      //check for empty users
      if (users.isEmpty) {
        showDialog(
          context: context,
          builder: (context) {
            return AlertMessage(
              buttonText: 'Ok',
              onPressed: () => Navigator.of(context).pop(),
              message: 'No account found for these credentials.',
            );
          },
        );
        //return;
      }
      //check for user
      for (int i = 0; i < users.length; i++) {
        if (users[i].userName == username && users[i].password == password) {
          //set isLogin to true for this user
          User user = box.getAt(i);
          user.isLogin = true;
          user.save();
          //User found go to home
          Navigator.of(context).pushReplacementNamed('home');
          return;
        } else if (i == users.length - 1) {
          //this is the end of Users list
          showDialog(
            context: context,
            builder: (context) {
              return AlertMessage(
                buttonText: 'Ok',
                onPressed: () => Navigator.of(context).pop(),
                message: 'No account found for these credentials.',
              );
            },
          );
        }
      }
    } else {
      showDialog(
        context: context,
        builder: (context) {
          return AlertMessage(
            buttonText: 'Ok',
            onPressed: () => Navigator.of(context).pop(),
            message: 'Please provide valid credentials',
          );
        },
      );
    }
  }

  @override
  void initState() {
    //get an instance of hive box
    box = Hive.box<User>('users');
    super.initState();
  }

  @override
  void dispose() {
    // disposing the text controllers
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(
          horizontal: 25,
          vertical: 50,
        ),
        decoration: const BoxDecoration(
            image: DecorationImage(
          fit: BoxFit.fill,
          image: AssetImage(
            'assets/images/background.png',
          ),
        )),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const LogoWithName(iconSize: 12, fontSize: 15.5),
            Expanded(
              child: Align(
                alignment: Alignment.center,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Welcome Back !',
                      style: GoogleFonts.roboto(
                        textStyle: const TextStyle(
                          fontSize: 21,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    AppTextfield(
                      hintText: 'Username',
                      controller: usernameController,
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    AppTextfield(
                      hintText: 'Password',
                      controller: passwordController,
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    AppButton(
                      buttonText: 'Login',
                      onPressed: loginOnTap,
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    buildRow(context),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Row buildRow(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Don\'n have an account?',
          style: GoogleFonts.roboto(
            fontSize: 10,
            fontWeight: FontWeight.w300,
          ),
        ),
        GestureDetector(
          onTap: () => signUpOnTap(context),
          child: Text(
            'Sign up',
            style: GoogleFonts.roboto(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              decoration: TextDecoration.underline,
            ),
          ),
        ),
      ],
    );
  }
}
