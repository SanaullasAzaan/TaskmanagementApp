import 'package:flutter/material.dart';
import 'package:gig_task_management_app/screens/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:gig_task_management_app/screens/home_screen.dart';
import 'package:gig_task_management_app/services/authentication.dart';
import 'package:gig_task_management_app/widgets/snackbar.dart';
import 'package:gig_task_management_app/widgets/image_text_container.dart';
import 'package:gig_task_management_app/widgets/social_button.dart';

class SignupScreen extends StatefulWidget {
  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  bool isLoading = false;
  bool _isPasswordVisible = false;

  void signupUser() async {
    setState(() {
      isLoading = true; // Show loading before signup
    });

    String res = await AuthMethod().signupUser(
      email: emailController.text,
      password: passwordController.text,
      name: nameController.text,
    );

    if (res == "success") {
      print("🔄 Waiting for Firebase Auth to update...");
      await Future.delayed(Duration(seconds: 2)); // Allow Firebase to update

      if (FirebaseAuth.instance.currentUser != null) {
        print("✅ User authenticated, navigating to HomeScreen...");
        if (mounted) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => const HomeScreen(),
            ),
          );
        }
      } else {
        print("❌ User not authenticated. Try logging in.");
        showSnackBar(context, "User not authenticated. Try logging in.");
      }
    } else {
      setState(() {
        isLoading = false;
      });
      print("❌ Signup failed: $res");
      showSnackBar(context, res);
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final height = size.height;
    final width = size.width;

    final inputDecoration = InputDecoration(
      filled: true,
      fillColor: Colors.transparent,
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.black, width: 1.5),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.black, width: 2),
      ),
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 16,
      ),
    );

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: width * 0.04,
            vertical: height * 0.02,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ImageTextContainer(
                imagePath: "assets/images/logsing.png",
                text: "Create Your Account",
                width: width * 0.9,
                height: height * 0.25,
                imageSize: height * 0.15,
                textStyle: TextStyle(
                  fontSize: width * 0.06,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            SizedBox(height: height * 0.03),
            const Text(
              'Full Name',
              style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: nameController,
              decoration: inputDecoration.copyWith(
              hintText: 'Your full name',
              hintStyle: const TextStyle(
                color: Colors.black54,
                fontSize: 16,
              ),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Email',
              style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: emailController,
              decoration: inputDecoration.copyWith(
              hintText: 'Your email',
              hintStyle: const TextStyle(
                color: Colors.black54,
                fontSize: 16,
              ),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Password',
              style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: passwordController,
              obscureText: !_isPasswordVisible,
              decoration: inputDecoration.copyWith(
              hintText: 'Your password',
              hintStyle: const TextStyle(
                color: Colors.black54,
                fontSize: 16,
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
            ),
            SizedBox(height: height * 0.04),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: isLoading
              ? const Center(child: CircularProgressIndicator())
              : ElevatedButton(
                onPressed: signupUser,
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  ),
                  backgroundColor: Colors.black,
                ),
                child: const Text(
                  "Sign Up",
                  style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  ),
                ),
                ),
            ),
            SizedBox(height: height * 0.03),
            Row(
              children: [
              Expanded(
                child: Container(
                height: 1,
                color: Colors.black38,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                'Or continue with',
                style: TextStyle(
                  color: Colors.black.withOpacity(0.6),
                  fontSize: 16,
                ),
                ),
              ),
              Expanded(
                child: Container(
                height: 1,
                color: Colors.black38,
                ),
              ),
              ],
            ),
            SizedBox(height: height * 0.03),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
              SocialButton(
                onTap: () {
                // Handle Google signup
                },
                iconPath: 'assets/images/google.png',
                size: width * 0.15,
                iconSize: width * 0.08,
              ),
              SocialButton(
                onTap: () {
                // Handle Facebook signup
                },
                iconPath: 'assets/images/facebook.png',
                size: width * 0.15,
                iconSize: width * 0.08,
              ),
              SocialButton(
                onTap: () {
                // Handle Apple signup
                },
                iconPath: 'assets/images/apple.png',
                size: width * 0.15,
                iconSize: width * 0.08,
              ),
                ],
              ),
              SizedBox(height: height * 0.03),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                Text(
                  "Already have an account? ",
                  style: TextStyle(
                  fontSize: width * 0.04,
                  color: Colors.black87,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                    builder: (context) => const LoginScreen(),
                    ),
                  );
                  },
                  child: Text(
                  "Sign in",
                  style: TextStyle(
                    fontSize: width * 0.04,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                  ),
                ),
                ],
              ),
              SizedBox(height: height * 0.02),
              ],
              ),
              ),
     ) );
            }
            }
