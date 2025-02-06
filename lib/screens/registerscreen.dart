import 'package:flutter/material.dart';
import 'package:gig_task_management_app/screens/login_screen.dart';
import 'package:gig_task_management_app/widgets/loading_button.dart';
import 'package:gig_task_management_app/widgets/social_button.dart';
import '../widgets/image_text_container.dart';


class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  bool _isPasswordVisible = false;
// Add loading state

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
                const SizedBox(height: 48),
                const ImageTextContainer(
                imagePath: 'assets/images/logsing.png',
                text: 'Create Account',
                imageSize: 150,
                textStyle: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                  fontFamily: 'Exo2',
                ),
                ),
                const SizedBox(height: 48),
              // Email Field
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
              // Password Field
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
                      _isPasswordVisible ? Icons.visibility_off : Icons.visibility,
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
                  // Add registration logic here
                  await Future.delayed(const Duration(seconds: 2)); // Remove this - just for testing
                },
                text: 'Sign Up',
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  const Expanded(
                    child: Divider(
                      color: Colors.black38,
                      thickness: 1,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      'Continue with',
                      style: TextStyle(
                        color: Colors.black.withOpacity(0.6),
                        fontSize: 14,
                        fontFamily: 'Exo2',
                      ),
                    ),
                  ),
                  const Expanded(
                    child: Divider(
                      color: Colors.black38,
                      thickness: 1,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SocialButton(
                    onTap: () {
                      // Add Google sign in logic
                    },
                    iconPath: 'assets/images/google.png',
                  ),
                  SocialButton(
                    onTap: () {
                      // Add Apple sign in logic
                    },
                    iconPath: 'assets/images/facebook.png',
                  ),
                  SocialButton(
                    onTap: () {
                      // Add Facebook sign in logic
                    },
                    iconPath: 'assets/images/apple.png',
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Already have an account? ",
                    style: TextStyle(
                      fontSize: 16,
                      fontFamily: 'Exo2',
                      color: Colors.black87,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (_) => const LoginScreen()),
                      );
                    },
                    child: const Text(
                      'Sign In',
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