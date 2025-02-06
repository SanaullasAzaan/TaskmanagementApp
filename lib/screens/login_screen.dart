import 'package:flutter/material.dart';
import 'package:gig_task_management_app/screens/home_screen.dart';
import 'package:gig_task_management_app/screens/registerscreen.dart';
import '../widgets/loading_button.dart';
import '../widgets/image_text_container.dart';





class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
                const SizedBox(height: 48),
                const ImageTextContainer(
                  imagePath: 'assets/images/logsing.png',
                  text: 'Welcome Back!',
                  imageSize: 150,
                  textStyle: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                  fontFamily: 'Exo2',
                  ),
                ),
                const SizedBox(height: 32),
                const Text(
                'Email',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Exo2',
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                decoration: InputDecoration(
                  hintText: 'Your email',
                  hintStyle: const TextStyle(
                    color: Colors.black54,
                    fontSize: 16,
                    fontFamily: 'Exo2',
                  ),
                  filled: true,
                  fillColor: Colors.transparent,
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Colors.black38, width: 1.5),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Colors.black, width: 2),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 16,
                  ),
                ),
                style: const TextStyle(
                  fontSize: 16,
                  fontFamily: 'Exo2',
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'Password',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Exo2',
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                obscureText: !_isPasswordVisible,
                decoration: InputDecoration(
                  hintText: 'Your password',
                  hintStyle: const TextStyle(
                    color: Colors.black54,
                    fontSize: 16,
                    fontFamily: 'Exo2',
                  ),
                  filled: true,
                  fillColor: Colors.transparent,
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Colors.black38, width: 1.5),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Colors.black, width: 2),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 16,
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isPasswordVisible 
                          ? Icons.visibility_off
                          : Icons.visibility,
                      color: Colors.black54,
                    ),
                    onPressed: () {
                      setState(() {
                        _isPasswordVisible = !_isPasswordVisible;
                      });
                    },
                  ),
                ),
                style: const TextStyle(
                  fontSize: 16,
                  fontFamily: 'Exo2',
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 48),
              LoadingButton(
                onPressed: () async {
                  await Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (_) => const HomeScreen()),
                    (route) => false,
                  );
                },
                text: 'Sign In',
                ),
                const SizedBox(height: 16),  // Space between button and text
                Row(

                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Don't have an account? ",
                    style: TextStyle(
                      fontSize: 16,
                      fontFamily: 'Exo2',
                      color: Colors.black87,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const RegisterScreen()),
                      );
                    },
                    child: const Text(
                      'Sign Up',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Exo2',
                        color: Colors.black,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
} 