import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:todoapp/widgets/alert_message.dart';

import '../models/user.dart';
import '../widgets/app_button.dart';
import '../widgets/app_textfield.dart';
import '../widgets/logo_with_name.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  //username text controller
  TextEditingController usernameController = TextEditingController();

  //password text controller
  TextEditingController passwordController = TextEditingController();

  //confirm password text controller
  TextEditingController confirmPasswordController = TextEditingController();

  //open the hive box for storing data
  late dynamic box;

  //Sign Up button on tap function
  void onPressed() {
    //check if the password and confirm password matches
    if (passwordController.text == confirmPasswordController.text &&
        passwordController.text.isNotEmpty) {
      box.add(User(
        userName: usernameController.text,
        password: confirmPasswordController.text,
        isLogin: false,
        taskList: [],
      ));
      setState(() {
        showSuccessMessage();
      });
    } else {
      showErrorMessage();
    }
  }

  //show error dialog if password doesn't match
  void showErrorMessage() {
    setState(() {
      showDialog(
        context: context,
        builder: (context) {
          return AlertMessage(
            buttonText: 'Ok',
            onPressed: () => Navigator.of(context).pop(),
            message: 'Password doesn\'t match',
          );
        },
      );
    });
  }

  //show success dialog if sign up is success
  void showSuccessMessage() {
    setState(() {
      showDialog(
          context: context,
          builder: (context) {
            return AlertMessage(
              buttonText: 'Sign in',
              onPressed: () =>
                  Navigator.of(context).pushReplacementNamed('signin'),
              message: 'Registration Success',
            );
          });
    });
  }

  @override
  void initState() {
    // get an instance of hive box
    box = Hive.box<User>('users');
    super.initState();
  }

  @override
  void dispose() {
    //dispose the text controllers
    usernameController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
        //keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        child: Container(
          width: double.infinity,
          height: MediaQuery.of(context).size.height,
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
              const IntrinsicWidth(
                  child: LogoWithName(iconSize: 12, fontSize: 15.5)),
              Flexible(
                //fit: FlexFit.loose,
                child: Align(
                  alignment: Alignment.center,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Sign up',
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
                      const CircleAvatar(
                        radius: 50,
                        child: Icon(
                          color: Colors.white,
                          Icons.person,
                          size: 90,
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
                      AppTextfield(
                        hintText: 'Confirm Password',
                        controller: confirmPasswordController,
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      AppButton(
                        buttonText: 'Sign up',
                        onPressed: onPressed,
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      buildRow(),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Row buildRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Already have an account?',
          style: GoogleFonts.roboto(
            fontSize: 10,
            fontWeight: FontWeight.w300,
          ),
        ),
        GestureDetector(
          onTap: () => Navigator.of(context).pushReplacementNamed('signin'),
          child: Text(
            'Sign in',
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
