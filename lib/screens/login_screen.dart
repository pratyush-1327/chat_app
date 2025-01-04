import 'package:chat_app/providers/auth_provider.dart';
import 'package:chat_app/screens/home_screen.dart';
import 'package:chat_app/screens/signup_screen.dart';
import 'package:chat_app/screens/widgets/logfield.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    return ResponsiveSizer(builder: (context, orientation, ScreenType) {
      return Scaffold(
        resizeToAvoidBottomInset: false,
        body: SafeArea(
          child: Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: const Color(0xFF8BC6EC), // Background color
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xFF8BC6EC),
                      Color(0xFF9599E2),
                    ],
                  ),
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
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
                    child: FilledButton.tonal(
                      style: ButtonStyle(
                        //backgroundColor: Colors.white,
                        padding: WidgetStateProperty.all<EdgeInsets>(
                            EdgeInsets.fromLTRB(50, 10, 50, 10)),
                      ),
                      onPressed: () async {
                        try {
                          await authProvider.signIn(
                              _emailController.text, _passController.text);
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => HomeScreen()));
                        } catch (e) {
                          print(e);
                        }
                      },
                      child: Text(
                        'Log In',
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
                        "Don't have an account?",
                        style: TextStyle(fontSize: 17.sp),
                      ),
                      TextButton(
                          onPressed: () {
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => SignupScreen()));
                          },
                          child: Text(
                            "Register Now",
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
