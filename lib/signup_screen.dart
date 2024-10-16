import 'package:flutter/material.dart';

class SignupScreen extends StatelessWidget {
  const SignupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Upper Gradient Panel
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              height: MediaQuery.of(context).size.height * 0.25, // Upper quarter of the screen
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.blue.shade900, // Dark Blue
                    Colors.blue.shade700, // Navy Blue
                    Colors.grey.shade500, // Grey
                    Colors.blue.shade800, // Light Blue
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: const Padding(
                padding: EdgeInsets.only(top: 40, left: 20), // Align text to the left with padding
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center, // Center vertically
                  crossAxisAlignment: CrossAxisAlignment.start, // Align text to the left
                  children: [
                    Text(
                      "Let's get you",
                      style: TextStyle(
                        fontSize: 26, // Font size
                        fontWeight: FontWeight.bold,
                        color: Colors.white, // Text color
                      ),
                    ),
                    Text(
                      'Onboard!',
                      style: TextStyle(
                        fontSize: 30, // Font size
                        fontWeight: FontWeight.bold,
                        color: Colors.white, // Text color
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Content
          Positioned(
            top: MediaQuery.of(context).size.height * 0.25, // Start content below the gradient
            left: 0,
            right: 0,
            bottom: 0,
            child: Stack(
              children: [
                // Background Gradient for the Curved Area
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.blue.shade900, // Dark Blue
                        Colors.blue.shade700, // Navy Blue
                        Colors.grey.shade500, // Grey
                        Colors.blue.shade800, // Light Blue
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                ),
                // White Bottom Panel with Curved Borders
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(30), // Rounded corners
                    topRight: Radius.circular(30),
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white, // Background color for the bottom panel
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1), // Shadow color
                          blurRadius: 10.0, // Softening the shadow
                          offset: const Offset(0, 2), // Position of the shadow
                        ),
                      ],
                    ),
                    child: SingleChildScrollView( // Wrap content in a scrollable view
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start, // Align fields to the left
                        children: [
                          const SizedBox(height: 40),
                          // Username Input Field
                          TextField(
                            style: const TextStyle(fontSize: 14), // Font size
                            decoration: InputDecoration(
                              prefixIcon: const Icon(Icons.person),
                              labelText: 'Username',
                              labelStyle: const TextStyle(color: Colors.blue), // Set label color
                              enabledBorder: const UnderlineInputBorder( // Straight underline for default state
                                borderSide: BorderSide(color: Colors.blue),
                              ),
                              focusedBorder: const UnderlineInputBorder( // Straight underline when focused
                                borderSide: BorderSide(color: Colors.blue, width: 2),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          // Email Input Field
                          TextField(
                            style: const TextStyle(fontSize: 14), // Font size
                            decoration: InputDecoration(
                              prefixIcon: const Icon(Icons.email),
                              labelText: 'Email',
                              labelStyle: const TextStyle(color: Colors.blue), // Set label color
                              enabledBorder: const UnderlineInputBorder( // Straight underline for default state
                                borderSide: BorderSide(color: Colors.blue),
                              ),
                              focusedBorder: const UnderlineInputBorder( // Straight underline when focused
                                borderSide: BorderSide(color: Colors.blue, width: 2),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          // Create Password Input Field
                          TextField(
                            style: const TextStyle(fontSize: 14), // Font size
                            obscureText: true,
                            decoration: InputDecoration(
                              prefixIcon: const Icon(Icons.lock),
                              labelText: 'Create Password',
                              labelStyle: const TextStyle(color: Colors.blue), // Set label color
                              enabledBorder: const UnderlineInputBorder( // Straight underline for default state
                                borderSide: BorderSide(color: Colors.blue),
                              ),
                              focusedBorder: const UnderlineInputBorder( // Straight underline when focused
                                borderSide: BorderSide(color: Colors.blue, width: 2),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          // Confirm Password Input Field
                          TextField(
                            style: const TextStyle(fontSize: 14), // Font size
                            obscureText: true,
                            decoration: InputDecoration(
                              prefixIcon: const Icon(Icons.lock),
                              labelText: 'Confirm Password',
                              labelStyle: const TextStyle(color: Colors.blue), // Set label color
                              enabledBorder: const UnderlineInputBorder( // Straight underline for default state
                                borderSide: BorderSide(color: Colors.blue),
                              ),
                              focusedBorder: const UnderlineInputBorder( // Straight underline when focused
                                borderSide: BorderSide(color: Colors.blue, width: 2),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          // Signup Button
                          ElevatedButton(
                            onPressed: () {
                              // Handle signup action here
                            },
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(horizontal: 120, vertical: 10),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                              backgroundColor: Colors.blue, // Button color
                            ),
                            child: const Text('Sign Up', style: TextStyle(fontSize: 16, color: Colors.white)),
                          ),
                          const SizedBox(height: 20),
                          // Back to Login
                          GestureDetector(
                            onTap: () {
                              Navigator.pop(context); // Go back to the login screen
                            },
                            child: const Text(
                              "Already have an account? Sign in",
                              style: TextStyle(color: Colors.blue),
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
        ],
      ),
    );
  }
}
