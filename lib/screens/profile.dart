import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:todoapp/utils/string_extensions.dart';
import 'package:todoapp/widgets/app_button.dart';
import 'package:todoapp/widgets/secondary_textfield.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  //controllers for text fields
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  //save the new credentials (onEditingComplete function)
  void saveCredentials(userInstance) {
    FocusScope.of(context).unfocus();
    userInstance.userName = _usernameController.text;
    userInstance.password = _passwordController.text;
    userInstance.save();
  }

  //on tap function for log out button
  void logOut(userInstance) {
    userInstance.isLogin = false;
    userInstance.save();
    Navigator.of(context).pushNamedAndRemoveUntil(
      'signin',
      (route) => false,
    );
  }

  @override
  void dispose() {
    super.dispose();
    //dispose the text controllers
    _usernameController.dispose();
    _passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //get arguments
    dynamic currentUser = ModalRoute.of(context)!.settings.arguments as dynamic;
    //local variable of name to use Capitalize() method
    String name = currentUser.userName;
    //set the text field value
    _usernameController.text = currentUser.userName;
    _passwordController.text = currentUser.password;
    return Scaffold(
      body: SingleChildScrollView(
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: Column(
            children: [
              Expanded(
                flex: 2,
                child: Container(
                  //width: double.infinity,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      fit: BoxFit.fill,
                      image: AssetImage(
                        'assets/images/background.png',
                      ),
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.only(left: 20),
                        child: GestureDetector(
                            onTap: () => Navigator.of(context)
                                .pushReplacementNamed('home'),
                            child: const Icon(Icons.arrow_back_ios_new)),
                      ),
                      Column(
                        children: [
                          Container(
                            decoration: const BoxDecoration(
                              color: Colors.white70,
                              shape: BoxShape.circle,
                            ),
                            child: GestureDetector(
                              onTap: () => Navigator.of(context).pop(),
                              child: const Icon(
                                Icons.person,
                                size: 125,
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            name.capitalize(),
                            style: GoogleFonts.inter(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                  flex: 3,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 50, horizontal: 20),
                    child: Column(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Username',
                              style: GoogleFonts.inter(
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            SecondaryTextfield(
                              controller: _usernameController,
                              onEditingComplete: () =>
                                  saveCredentials(currentUser),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 40,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Password',
                              style: GoogleFonts.inter(
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            SecondaryTextfield(
                              controller: _passwordController,
                              onEditingComplete: () =>
                                  saveCredentials(currentUser),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 40,
                        ),
                        AppButton(
                          buttonText: 'Log out',
                          onPressed: () => logOut(currentUser),
                        ),
                      ],
                    ),
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
