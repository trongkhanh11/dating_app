// lib/views/login_view.dart

import 'package:dating_app/presentation/authentication/register/register_screen.dart';
import 'package:dating_app/presentation/profile/first_time_update_profile_screen.dart';
import 'package:dating_app/providers/auth_provider.dart';
import 'package:dating_app/widgets/bottom_bar.dart';
import 'package:dating_app/widgets/custom_text_input.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  // bool _isLoading = false;
  // bool _isRememberMeChecked = false;

  // void _clearEmail() {
  //   _emailController.clear();
  // }

  // void _clearPassword() {
  //   _passwordController.clear();
  // }

  void _login() async {
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill all fields")),
      );
      return;
    }

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    bool success = await authProvider.login(
        _emailController.text, _passwordController.text);
    if (success) {
      String? userId = authProvider.getUserId();
      if (userId != null) {
        bool hasProfile = await authProvider.checkUserProfile(userId);
        if (hasProfile) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => BottomBar()),
          );
          return;
        } else {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    FirstTimeUpdateProfileScreen(userId: userId)),
          );
        }
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Login failed")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              const SizedBox(
                height: 100,
              ),
              Image.asset(
                'assets/images/logo.png',
                width: 200,
              ),
              Text(
                "Welcome",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                "Please login to find your best match",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 40,
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width - 36,
                child: CustomTextInput(
                  controller: _emailController,
                  labelText: "Email",
                  icon: Icons.email,
                  hintText: "Your email",
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width - 36,
                child: CustomTextInput(
                  controller: _passwordController,
                  labelText: "Password",
                  icon: Icons.lock,
                  hintText: "Your password",
                  obscureText: true,
                ),
              ),
              const SizedBox(
                height: 50,
              ),
              Consumer<AuthProvider>(
                builder: (context, authProvider, child) {
                  return authProvider.isLoading
                      ? CircularProgressIndicator()
                      : Container(
                          width: MediaQuery.of(context).size.width - 36,
                          height: 50,
                          decoration: const BoxDecoration(
                              color: Colors.redAccent,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(12))),
                          child: InkWell(
                            onTap: () {
                              _login();
                            },
                            child: const Center(
                              child: Text(
                                "Login",
                                style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        );
                },
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Don't have an account? ",
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                //const RegisterScreen()
                                const RegisterScreen()),
                      );
                    },
                    child: const Text(
                      "Create Here",
                      style: TextStyle(
                          fontSize: 18,
                          color: Colors.black,
                          fontWeight: FontWeight.bold),
                    ),
                  )
                ],
              ),
              const SizedBox(
                height: 16,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
