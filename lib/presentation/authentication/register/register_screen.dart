import 'package:dating_app/models/user_model.dart';
import 'package:dating_app/presentation/authentication/login/login_screen.dart';
import 'package:dating_app/presentation/profile/first_time_update_profile_screen.dart';
import 'package:dating_app/providers/auth_provider.dart';
import 'package:dating_app/providers/profile_provider.dart';
import 'package:dating_app/widgets/bottom_bar.dart';
import 'package:dating_app/widgets/custom_text_input.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();

  void _submitForm() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    RegisterModel registerModel = RegisterModel(
      email: _emailController.text.trim(),
      password: _passwordController.text,
      firstName: _firstNameController.text.trim(),
      lastName: _lastNameController.text.trim(),
    );

    bool success = await authProvider.register(registerModel, context);

    if (success) {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      bool loginSuccess = await authProvider.login(
          _emailController.text.trim(), _passwordController.text);

      if (loginSuccess) {
        final userId = authProvider.userModel?.user.id ?? "";
        final profileProvider =
            Provider.of<ProfileProvider>(context, listen: false);
        bool hasProfile = await profileProvider.getUserProfile(userId, context);
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
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ListView(children: [
      Container(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 30),
              child: Text(
                "Sign Up",
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
            ),
            CustomTextInput(
              controller: _firstNameController,
              labelText: "First Name",
              icon: Icons.person,
              hintText: "Your first name",
            ),
            SizedBox(
              height: 30,
            ),
            CustomTextInput(
              controller: _lastNameController,
              labelText: "Last Name",
              icon: Icons.person,
              hintText: "Your last name",
            ),
            SizedBox(
              height: 30,
            ),
            CustomTextInput(
              controller: _emailController,
              labelText: "Email",
              icon: Icons.mail,
              hintText: "Your email",
            ),
            SizedBox(
              height: 30,
            ),
            CustomTextInput(
              controller: _passwordController,
              labelText: "Password",
              icon: Icons.lock,
              obscureText: true,
              hintText: "Your password",
            ),
            SizedBox(
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
                            _submitForm();
                          },
                          child: const Center(
                            child: Text(
                              "Sign Up",
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
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Already have an account? ",
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const LoginScreen()),
                    );
                  },
                  child: const Text(
                    "Login",
                    style: TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                        fontWeight: FontWeight.bold),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    ]));
  }
}
