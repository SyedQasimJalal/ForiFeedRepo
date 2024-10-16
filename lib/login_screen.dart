import 'package:flutter/material.dart';
import 'signup_screen.dart'; // Make sure to import the signup screen

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();

  @override
  void dispose() {
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  void _onPasswordTap() {
    FocusScope.of(context).requestFocus(_passwordFocusNode); // Explicitly request focus for password
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () {
          // Dismiss the keyboard when tapping outside of text fields
          FocusScope.of(context).unfocus();
        },
        child: Stack(
          children: [
            // Panel with the color you provided
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Container(
                height: MediaQuery.of(context).size.height * 0.25, // Upper quarter of the screen
                color: const Color(0xFFE3F2FD), // Light Blue top panel
                child: Align(
                  alignment: Alignment.bottomLeft, // Align to the bottom left
                  child: Padding(
                    padding: const EdgeInsets.only(left: 20, bottom: 10), // Padding to position text
                    child: const Text(
                      'Welcome Back!',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.normal,
                        color: Color(0xFF001F5B), // Darkest blue color
                      ),
                    ),
                  ),
                ),
              ),
            ),

            // New Gradient Background Panel below the top panel
            Positioned(
              top: MediaQuery.of(context).size.height * 0.25, // Start below the top panel
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.blue.shade900, // Dark Blue
                      Colors.blue.shade700, // Navy Blue
                      Colors.grey.shade500, // Grey
                      Colors.blue.shade800, // Light Blue
                    ],
                    begin: Alignment.topLeft, // Start the gradient at the top-left
                    end: Alignment.bottomRight, // End the gradient at the bottom-right
                  ),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(30), // Slight curve on the top left
                    topRight: Radius.circular(30), // Slight curve on the top right
                  ),
                ),
                padding: const EdgeInsets.all(20.0),
                child: SingleChildScrollView( // Wrap content in a scrollable view
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 40),
                      // Email Input Field with straight underline
                      TextField(
                        focusNode: _emailFocusNode, // Set the focus node
                        keyboardType: TextInputType.emailAddress, // Set the keyboard type for email
                        decoration: InputDecoration(
                          labelText: 'Email',
                          labelStyle: const TextStyle(color: Colors.white),
                          enabledBorder: UnderlineInputBorder( // Straight underline
                            borderSide: BorderSide(color: Colors.white),
                          ),
                          focusedBorder: UnderlineInputBorder( // Focused underline
                            borderSide: BorderSide(color: Colors.white, width: 2),
                          ),
                          prefixIcon: const Icon(Icons.email, color: Colors.white),
                        ),
                      ),
                      const SizedBox(height: 20),
                      // Password Input Field with straight underline
                      GestureDetector(
                        onTap: _onPasswordTap,
                        child: TextField(
                          focusNode: _passwordFocusNode, // Set the focus node
                          obscureText: true,
                          decoration: InputDecoration(
                            labelText: 'Password',
                            labelStyle: const TextStyle(color: Colors.white),
                            enabledBorder: UnderlineInputBorder( // Straight underline
                              borderSide: BorderSide(color: Colors.white),
                            ),
                            focusedBorder: UnderlineInputBorder( // Focused underline
                              borderSide: BorderSide(color: Colors.white, width: 2),
                            ),
                            prefixIcon: const Icon(Icons.lock, color: Colors.white),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () {},
                          child: const Text('Forgot Password?', style: TextStyle(color: Colors.white)),
                        ),
                      ),
                      const SizedBox(height: 20),
                      // Login Button with modified size
                      ElevatedButton(
                        onPressed: () {
                          // Handle login action here
                        },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 120, vertical: 6), // Increased width, decreased height
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          backgroundColor: Colors.white, // Button color
                        ),
                        child: const Text('Sign in', style: TextStyle(fontSize: 20, color: Colors.blue)),
                      ),
                      const SizedBox(height: 20),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            PageRouteBuilder(
                              pageBuilder: (context, animation, secondaryAnimation) => const SignupScreen(),
                              transitionsBuilder: (context, animation, secondaryAnimation, child) {
                                const begin = Offset(1.0, 0.0); // Slide in from the right
                                const end = Offset.zero;
                                const curve = Curves.easeInOut;

                                var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
                                var offsetAnimation = animation.drive(tween);

                                // Adjust the duration of the transition
                                return SlideTransition(
                                  position: offsetAnimation,
                                  child: child,
                                );
                              },
                              transitionDuration: const Duration(milliseconds: 600), // Slow down the transition
                            ),
                          );
                        },
                        child: const Text(
                          "Don't have an account? Create one",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
