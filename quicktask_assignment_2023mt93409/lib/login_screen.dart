import 'package:flutter/material.dart';
import 'package:quicktask_assignment_2023mt93409/auth_service.dart';
import 'package:quicktask_assignment_2023mt93409/task_management_screen.dart';
import 'package:quicktask_assignment_2023mt93409/signup_screen.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with SingleTickerProviderStateMixin {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String _errorMessage = '';

  late AnimationController _animationController;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();

    // Initialize the animation controller for sliding animation
    _animationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    // Define the slide animation to come from left to right
    _slideAnimation = Tween<Offset>(
      begin: Offset(-1.0, 0.0), // Start position: off-screen left
      end: Offset(0.0, 0.0),    // End position: normal position
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    // Start the animation when the screen loads
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose(); // Dispose the controller when the widget is destroyed
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.yellow[200], // Dark yellow background
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Top Heading
              Container(
                color: Colors.blue, // Blue background strip
                padding: const EdgeInsets.all(12.0),
                child: Text(
                  'Quick Task Login',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ),
              SizedBox(height: 24.0),

              // Main Label (Quick Task App)
              Text(
                'QUICK TASK APP',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8.0),

              // Animated Punch Line (from left to right)
              SlideTransition(
                position: _slideAnimation,
                child: Text(
                  'Manage your tasks efficiently and effectively',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ),
              SizedBox(height: 32.0),

              // Login Form Card
              Card(
                elevation: 4.0,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextFormField(
                          controller: _usernameController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your username';
                            }
                            return null;
                          },
                          decoration: InputDecoration(labelText: 'Username'),
                        ),
                        SizedBox(height: 16.0),
                        TextFormField(
                          controller: _passwordController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your password';
                            }
                            return null;
                          },
                          obscureText: true,
                          decoration: InputDecoration(labelText: 'Password'),
                        ),
                        SizedBox(height: 16.0),
                        ElevatedButton(
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              await _login();
                            }
                          },
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(Colors.green), // Correct way to set button background color
                          ),
                          child: Text(
                            'Log In',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        SizedBox(height: 8.0),
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => SignUpScreen()),
                            );
                          },
                          style: ButtonStyle(
                            foregroundColor: MaterialStateProperty.all(Colors.green), // Correct way to set button text color
                          ),
                          child: Text('Sign Up'),
                        ),
                        SizedBox(height: 8.0),
                        Text(
                          _errorMessage,
                          style: TextStyle(color: Colors.red),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _login() async {
    final username = _usernameController.text.trim();
    final password = _passwordController.text.trim();

    try {
      final loginResult = await AuthService().login(username, password);

      final sessionToken = loginResult['sessionToken'] ?? "";

      if (sessionToken.isNotEmpty) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => TaskManagementScreen()),
        );
      } else {
        setState(() {
          _errorMessage = 'Invalid username or password';
        });
      }
    } catch (e) {
      print('Error during login: $e');
      setState(() {
        _errorMessage = 'An error occurred. Please try again later.';
      });
    }
  }
}
