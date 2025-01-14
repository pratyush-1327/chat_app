import 'package:FlutChat/providers/auth_provider.dart';
import 'package:FlutChat/screens/home_screen.dart';
import 'package:FlutChat/screens/signup_screen.dart';
import 'package:FlutChat/screens/widgets/logfield.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passController = TextEditingController();
  bool _isLoading = false;

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
                  color: Theme.of(context).colorScheme.surfaceBright,
                ),
              ),
              Form(
                key: _formKey,
                child: Column(
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
                      child: _isLoading
                          ? CircularProgressIndicator()
                          : FilledButton.tonal(
                              style: ButtonStyle(
                                //backgroundColor: Colors.white,
                                padding: WidgetStateProperty.all<EdgeInsets>(
                                    EdgeInsets.fromLTRB(50, 7, 50, 7)),
                              ),
                              onPressed: () async {
                                if (_formKey.currentState!.validate()) {
                                  setState(() {
                                    _isLoading = true;
                                  });
                                  try {
                                    await authProvider.signIn(
                                      _emailController.text,
                                      _passController.text,
                                    );
                                    Fluttertoast.showToast(
                                        msg: "Login successful");
                                    Navigator.push(
                                      context,
                                      PageRouteBuilder(
                                        pageBuilder: (context, animation,
                                                secondaryAnimation) =>
                                            HomeScreen(),
                                        transitionsBuilder: (context, animation,
                                            secondaryAnimation, child) {
                                          const beginOffset = Offset(1.0, 0.0);
                                          const endOffset = Offset.zero;
                                          const curve = Curves.easeInOut;

                                          var tweenOffset = Tween(
                                                  begin: beginOffset,
                                                  end: endOffset)
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
                                  } catch (e) {
                                    print(e);
                                  } finally {
                                    setState(() {
                                      _isLoading = false;
                                    });
                                  }
                                }
                              },
                              child: Text(
                                'Log In',
                                style: TextStyle(
                                    fontSize: 21.sp,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onPrimaryFixed),
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
                              Navigator.push(
                                context,
                                PageRouteBuilder(
                                  pageBuilder: (context, animation,
                                          secondaryAnimation) =>
                                      SignupScreen(),
                                  transitionsBuilder: (context, animation,
                                      secondaryAnimation, child) {
                                    const beginOffset = Offset(1.0, 0.0);
                                    const endOffset = Offset.zero;
                                    const curve = Curves.easeInOut;

                                    var tweenOffset = Tween(
                                            begin: beginOffset, end: endOffset)
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
                              "Register Now",
                              style: TextStyle(fontSize: 17.sp),
                            ))
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
