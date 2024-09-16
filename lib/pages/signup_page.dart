import 'package:chat_app/constants/constant.dart';
import 'package:chat_app/pages/login_page.dart';
import 'package:chat_app/widgets/custom_button.dart';
import 'package:chat_app/widgets/custom_text_form_field.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class SignUpPage extends StatefulWidget {
  SignUpPage({super.key});

  static String id = "SignUpPage";

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  String? email;

  String? password;

  bool isLoading = false;

  GlobalKey<FormState> formKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return ModalProgressHUD(
      inAsyncCall: isLoading,
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.white,
          body: SingleChildScrollView(
            child: Column(
              children: [
                Stack(
                  children: [
                    ClipPath(
                      clipper: DrawClip1(),
                      child: Container(
                        height: size.height / 2.9,
                        color: kColor,
                      ),
                    ),
                    ClipPath(
                      clipper: DrawClip2(),
                      child: Container(
                        height: size.height / 2.9,
                        color: kPrimaryColor,
                      ),
                    ),
                    Positioned(
                      bottom: 50,
                      left: 70,
                      child: Text(
                        'Chat App',
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 30,
                            fontFamily: 'Merriweather',
                            fontWeight: FontWeight.bold),
                      ),
                    )
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: Form(
                    key: formKey,
                    child: Column(
                      children: [
                        SizedBox(
                          height: 20,
                        ),
                        Align(
                          alignment: AlignmentDirectional.centerStart,
                          child: Text(
                            'SignUp',
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 24,
                                fontFamily: 'Merriweather',
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        CustomTextFormField(
                            validator: (data) {
                              if (data!.isEmpty) {
                                return 'No filed Empty';
                              } else if (!(RegExp(r'\S+@\S+\.\S+')
                                  .hasMatch(data))) {
                                return 'the email not match this "example@gmail.com"';
                              }
                            },
                            onChanged: (data) {
                              email = data;
                            },
                            hintText: 'Email'),
                        SizedBox(
                          height: 15,
                        ),
                        CustomTextFormField(
                            validator: (data) {
                              if (data!.isEmpty) {
                                return 'No filed Empty';
                              }
                            },
                            onChanged: (data) {
                              password = data;
                            },
                            hintText: 'Password'),
                        SizedBox(
                          height: 20,
                        ),
                        CustomButton(
                          onTap: () async {
                            if (formKey.currentState!.validate()) {
                              isLoading = true;
                              setState(() {});
                              try {
                                await SignUpUser();
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(SnackBar(
                                        backgroundColor: kPrimaryColor,
                                        content: Text(
                                          "Success SignUp",
                                          style: TextStyle(
                                            fontSize: 17,
                                            fontWeight: FontWeight.bold,
                                            fontFamily: 'Merriweather',
                                            color: Colors.black,
                                          ),
                                        )));
                              } on FirebaseAuthException catch (e) {
                                if (e.code == 'weak-password') {
                                  showSnackBar(context, "Weak-password");
                                } else if (e.code == 'email-already-in-use') {
                                  showSnackBar(context, "Email already exists");
                                }
                              } catch (e) {
                                showSnackBar(context, "There was an error");
                              }
                              isLoading = false;
                              setState(() {});
                            }
                          },
                          text: 'SignUp',
                          color: kColor,
                          textStyle: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Merriweather',
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'already have an account?',
                              style: TextStyle(
                                color: Colors.black,
                                fontFamily: 'Merriweather',
                                fontSize: 16,
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.pushReplacementNamed(
                                    context, LoginPage.id);
                              },
                              child: Text(
                                '  Login',
                                style: TextStyle(
                                  color: kPrimaryColor,
                                  fontSize: 18,
                                  fontFamily: 'Merriweather',
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: kColor,
        content: Text(
          message,
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.bold,
            fontFamily: 'Merriweather',
            color: Colors.black,
          ),
        ),
      ),
    );
  }

  Future<void> SignUpUser() async {
    UserCredential user = await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email!, password: password!);
  }
}

class DrawClip1 extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.moveTo(size.width / 3.8, 0);
    path.lineTo(size.width * 0.8, size.height * 0.7);
    path.quadraticBezierTo(size.width * 0.8 + 15, size.height * 0.7 + 15,
        size.width * 0.8 + 30, size.height * 0.7);
    path.lineTo(size.width, size.height * 0.6 - 10);
    path.lineTo(size.width, 0);
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return true;
  }
}

class DrawClip2 extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, 50);
    path.lineTo(size.width / 3.8 - 5, 150);
    path.quadraticBezierTo(
        size.width / 3.8 + 30, 185, size.width / 3.8 + 57, 150);
    path.lineTo(size.width / 1.4, 0);

    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return true;
  }
}
