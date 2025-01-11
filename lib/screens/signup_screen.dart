import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';

import 'package:responsive_sizer/responsive_sizer.dart';

import 'login_screen.dart';
import 'widgets/logfield.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  File? _image;
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;
  final _storage = FirebaseStorage.instance;
  bool _isLoading = false;

  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  Future<String> _uploadImage(File image) async {
    final ref = _storage
        .ref()
        .child('user_images')
        .child('${_auth.currentUser!.uid}.jpg');
    await ref.putFile(image);
    return ref.getDownloadURL();
  }

  Future<void> _signUp() async {
    bool isValid = true;
    setState(() {
      _isLoading = true;
    });

    if (_nameController.text.isEmpty) {
      setState(() {
        _nameController.text = '';
        // _nameController.errorText = 'Please enter your name.';
        Fluttertoast.showToast(msg: "Please enter a name");
      });
      isValid = false;
    }

    if (_emailController.text.isEmpty) {
      setState(() {
        _emailController.text = '';
        // _emailController.errorText = 'Please enter your email.';
        Fluttertoast.showToast(msg: "Please enter  valid email");
      });
      isValid = false;
    }

    if (_passController.text.isEmpty) {
      setState(() {
        _passController.text = '';

        Fluttertoast.showToast(msg: "Please enter a valid password");
      });
      isValid = false;
    }

    if (_image == null) {
      setState(() {
        Fluttertoast.showToast(
            msg: "Please select a profile image to continue");
      });
      isValid = false;
    }

    if (!isValid) {
      return; // Stop signup if any field is invalid
    }

    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
              email: _emailController.text, password: _passController.text);
      final imageUrl = await _uploadImage(_image!);
      await _firestore.collection('users').doc(userCredential.user!.uid).set({
        'uid': userCredential.user!.uid,
        'email': _emailController.text,
        'name': _nameController.text,
        'imageUrl': imageUrl,
      });
      Fluttertoast.showToast(msg: "Sign-Up was successful, Please Login");
      Navigator.push(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) =>
              LoginScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            const beginOffset = Offset(1.0, 0.0);
            const endOffset = Offset.zero;
            const curve = Curves.easeInOut;

            var tweenOffset = Tween(begin: beginOffset, end: endOffset)
                .chain(CurveTween(curve: curve));
            var slideAnimation = animation.drive(tweenOffset);

            var fadeAnimation = Tween(begin: 0.0, end: 1.0).animate(animation);

            return SlideTransition(
              position: slideAnimation,
              child: FadeTransition(
                opacity: fadeAnimation,
                child: child,
              ),
            );
          },
        ),
      );
    } catch (e) {
      print(e);
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // final authProvider = Provider.of<AuthProvider>(context);
    return ResponsiveSizer(builder: (context, orientation, ScreenType) {
      return Scaffold(
        resizeToAvoidBottomInset: false,
        body: SafeArea(
          child: Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceBright,
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  InkWell(
                    onTap: _pickImage,
                    child: Container(
                        height: 50.sp,
                        width: 50.sp,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle, border: Border.all()),
                        child: _image == null
                            ? Center(
                                child: Icon(
                                Icons.camera_alt,
                                size: 40,
                              ))
                            : ClipRRect(
                                borderRadius: BorderRadius.circular(100),
                                child: Image.file(_image!, fit: BoxFit.cover),
                              )),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    "Your Avatar",
                    style: TextStyle(
                        fontSize: 17.sp,
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.w600),
                  ),
                  MyTextField(
                    keyboardType: TextInputType.name,
                    hintText: "name",
                    controller: _nameController,
                    labeltext: "Name:",
                    obscureText: false,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter a name";
                      }
                    },
                  ),
                  MyTextField(
                    keyboardType: TextInputType.emailAddress,
                    hintText: "abcd@gmail.com",
                    controller: _emailController,
                    labeltext: "Email:",
                    obscureText: false,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter valid email";
                      } else {
                        return null;
                      }
                    },
                  ),
                  MyTextField(
                    keyboardType: TextInputType.visiblePassword,
                    hintText: "hello@123",
                    controller: _passController,
                    labeltext: "Password:",
                    obscureText: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter valid password";
                      } else {
                        return null;
                      }
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 50),
                    child: _isLoading
                        ? CircularProgressIndicator()
                        : FilledButton.tonal(
                            style: ButtonStyle(
                              //backgroundColor: Colors.white,
                              padding: WidgetStateProperty.all<EdgeInsets>(
                                  EdgeInsets.fromLTRB(50, 7, 50, 7)),
                            ),
                            onPressed: _signUp,
                            child: Text(
                              'Sign Up',
                              style: TextStyle(fontSize: 21.sp),
                            ),
                          ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Already have an account?",
                        style: TextStyle(fontSize: 17.sp),
                      ),
                      TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              PageRouteBuilder(
                                pageBuilder:
                                    (context, animation, secondaryAnimation) =>
                                        LoginScreen(),
                                transitionsBuilder: (context, animation,
                                    secondaryAnimation, child) {
                                  const beginOffset = Offset(1.0, 0.0);
                                  const endOffset = Offset.zero;
                                  const curve = Curves.easeInOut;

                                  var tweenOffset =
                                      Tween(begin: beginOffset, end: endOffset)
                                          .chain(CurveTween(curve: curve));
                                  var slideAnimation =
                                      animation.drive(tweenOffset);

                                  var fadeAnimation =
                                      Tween(begin: 0.0, end: 1.0)
                                          .animate(animation);

                                  return SlideTransition(
                                    position: slideAnimation,
                                    child: FadeTransition(
                                      opacity: fadeAnimation,
                                      child: child,
                                    ),
                                  );
                                },
                              ),
                            );
                          },
                          child: Text(
                            "Login Now!",
                            style: TextStyle(fontSize: 17.sp),
                          ))
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    });
  }
}
