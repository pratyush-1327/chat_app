import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';

import 'package:responsive_sizer/responsive_sizer.dart';

import 'login_screen.dart';
import 'logfield.dart';

class SignupScreen extends ConsumerStatefulWidget {
  const SignupScreen({super.key});

  @override
  ConsumerState<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends ConsumerState<SignupScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  File? _image;
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;
  final _storage = FirebaseStorage.instance;
  bool _isLoading = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailController.dispose();
    _passController.dispose();
    _nameController.dispose();
    super.dispose();
  }

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
    final user = _auth.currentUser;
    if (user == null) {
      throw Exception("User not logged in during image upload.");
    }
    final ref = _storage.ref().child('user_images').child('${user.uid}.jpg');
    await ref.putFile(image);
    return ref.getDownloadURL();
  }

  Future<void> _signUp() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_image == null) {
      Fluttertoast.showToast(msg: "Please select a profile image to continue");
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
              email: _emailController.text.trim(),
              password: _passController.text.trim());

      if (userCredential.user != null) {
        final imageUrl = await _uploadImage(_image!);

        // Store user data in Firestore
        await _firestore.collection('users').doc(userCredential.user!.uid).set({
          'uid': userCredential.user!.uid,
          'email': _emailController.text.trim(),
          'name': _nameController.text.trim(),
          'imageUrl': imageUrl,
          'createdAt': Timestamp.now(),
        });

        Fluttertoast.showToast(msg: "Sign-Up was successful, Please Login");

        if (mounted) {
          Navigator.pushReplacement(
            context,
            PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) =>
                  const LoginScreen(),
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
                const beginOffset = Offset(1.0, 0.0);
                const endOffset = Offset.zero;
                const curve = Curves.easeInOut;

                var tweenOffset = Tween(begin: beginOffset, end: endOffset)
                    .chain(CurveTween(curve: curve));
                var slideAnimation = animation.drive(tweenOffset);

                var fadeAnimation =
                    Tween(begin: 0.0, end: 1.0).animate(animation);

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
        }
      } else {
        throw Exception("User creation failed, user data is null.");
      }
    } on FirebaseAuthException catch (e) {
      print(e);
      Fluttertoast.showToast(msg: "Sign-Up failed: ${e.message ?? e.code}");
    } catch (e) {
      print(e);
      Fluttertoast.showToast(msg: "Sign-Up failed: ${e.toString()}");
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveSizer(builder: (context, orientation, ScreenType) {
      return Scaffold(
        resizeToAvoidBottomInset: true,
        body: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          child: Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.only(top: 40),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    // Add a title
                    "Create Account",
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                  ),
                  SizedBox(height: 30.sp),
                  InkWell(
                    onTap: _pickImage,
                    child: CircleAvatar(
                      radius: 35.sp,
                      backgroundColor:
                          Theme.of(context).colorScheme.secondaryContainer,
                      backgroundImage:
                          _image != null ? FileImage(_image!) : null,
                      child: _image == null
                          ? Icon(
                              Icons.camera_alt,
                              size: 40.sp,
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSecondaryContainer,
                            )
                          : null,
                    ),
                  ),
                  SizedBox(height: 10.sp),
                  Text(
                    "Tap to select profile picture",
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  SizedBox(height: 20.sp),
                  MyTextField(
                    keyboardType: TextInputType.name,
                    hintText: "Enter your name",
                    controller: _nameController,
                    labeltext: "Name",
                    obscureText: false,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        // Use trim()
                        return "Please enter a name";
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 15.sp),
                  MyTextField(
                    keyboardType: TextInputType.emailAddress,
                    hintText: "you@example.com",
                    controller: _emailController,
                    labeltext: "Email",
                    obscureText: false,
                    validator: (value) {
                      if (value == null ||
                          value.trim().isEmpty ||
                          !value.contains('@')) {
                        // Basic email check
                        return "Please enter a valid email";
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 15.sp),
                  MyTextField(
                    keyboardType: TextInputType.visiblePassword,
                    hintText: "Enter your password",
                    controller: _passController,
                    labeltext: "Password",
                    obscureText: true,
                    validator: (value) {
                      if (value == null ||
                          value.trim().isEmpty ||
                          value.length < 6) {
                        return "Password must be at least 6 characters";
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 30.sp),
                  _isLoading
                      ? const CircularProgressIndicator() // Use const
                      : FilledButton.tonal(
                          style: FilledButton.styleFrom(
                            minimumSize:
                                Size(double.infinity, 50), // Make button wider
                          ),
                          onPressed: _signUp,
                          child: Text(
                            'Sign Up',
                            style:
                                TextStyle(fontSize: 18.sp), // Adjust font size
                          ),
                        ),
                  SizedBox(height: 20.sp),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Already have an account?",
                        style: TextStyle(fontSize: 16.sp),
                      ),
                      TextButton(
                          onPressed: () {
                            Navigator.pushReplacement(
                              context,
                              PageRouteBuilder(
                                pageBuilder:
                                    (context, animation, secondaryAnimation) =>
                                        const LoginScreen(),
                                transitionsBuilder: (context, animation,
                                    secondaryAnimation, child) {
                                  return FadeTransition(
                                      opacity: animation, child: child);
                                },
                              ),
                            );
                          },
                          child: Text(
                            "Login Now!",
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ))
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }
}
