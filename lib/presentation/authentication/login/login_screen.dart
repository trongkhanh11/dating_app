// lib/views/login_view.dart

import 'package:dating_app/presentation/authentication/register/register_screen.dart';
import 'package:dating_app/presentation/profile/first_time_update_profile_screen.dart';
import 'package:dating_app/providers/auth_provider.dart';
import 'package:dating_app/providers/profile_provider.dart';
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
  final _formField = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  Future<void> _login() async {
    if (_formField.currentState!.validate()) {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      bool success = await authProvider.login(
          _emailController.text.trim(), _passwordController.text);

      if (success) {
        final userId = authProvider.userModel?.user.id ?? "";
        final profileProvider =
            Provider.of<ProfileProvider>(context, listen: false);
        bool hasProfile = await profileProvider.getUserProfile(userId, context);
        if (hasProfile) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => BottomBar(
                profile: authProvider.profile,
              ),
            ),
          );
          return;
        } else {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    FirstTimeUpdateProfileScreen(userId: userId)),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Form(
            key: _formField,
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
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Please enter email.";
                      }
                      return null;
                    },
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
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Please enter password.";
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(
                  height: 50,
                ),
                if (authProvider.isLoading)
                  const CircularProgressIndicator()
                else
                  Container(
                    width: MediaQuery.of(context).size.width - 36,
                    height: 50,
                    decoration: const BoxDecoration(
                        color: Colors.redAccent,
                        borderRadius: BorderRadius.all(Radius.circular(12))),
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
                            fontSize: 16,
                            color: Colors.black,
                            fontWeight: FontWeight.bold),
                      ),
                    )
                  ],
                ),
                if (authProvider.errorMessage.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 20.0),
                    child: Text(
                      authProvider.errorMessage,
                      style: const TextStyle(color: Colors.red),
                    ),
                  ),
                const SizedBox(
                  height: 16,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
