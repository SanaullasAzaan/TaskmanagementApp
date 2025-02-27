import 'package:flutter/material.dart';
import 'package:gig_task_management_app/screens/home_screen.dart';
import 'package:gig_task_management_app/screens/registerscreen.dart';
import 'package:gig_task_management_app/services/authentication.dart';
import 'package:gig_task_management_app/widgets/snackbar.dart';
import 'package:gig_task_management_app/widgets/image_text_container.dart';



class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isLoading = false;
  bool _isPasswordVisible = false;

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
  }

  void loginUsers() async {
    setState(() {
      isLoading = true;
    });
    
    String res = await AuthMethod().loginUser(
      email: emailController.text,
      password: passwordController.text,
    );
    
    if (res == "success") {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const HomeScreen(),
        ),
      );
    } else {
      setState(() {
        isLoading = false;
      });
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
          text: "Welcome Back!",
          width: width * 0.9,
          height: height * 0.25,
          imageSize: height * 0.15,
          textStyle: TextStyle(
            fontSize: width * 0.06,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
          ),
          SizedBox(height: height * 0.02),
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
            const SizedBox(height: 16),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () {
                  // Handle forgot password
                },
                child: const Text(
                  "Forgot Password?",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
              ),
            ),
            SizedBox(height: height * 0.03),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : ElevatedButton(
                    onPressed: loginUsers,
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      backgroundColor: Colors.black,
                    ),
                    child: const Text(
                      "Sign In",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
            ),
            SizedBox(height: height * 0.02),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Don't have an account? ",
                  style: TextStyle(
                    fontSize: width * 0.04,
                    color: Colors.black87,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SignupScreen(),
                      ),
                    );
                  },
                  child: Text(
                    "Sign Up",
                    style: TextStyle(
                      fontSize: width * 0.04,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ));
  }
}
