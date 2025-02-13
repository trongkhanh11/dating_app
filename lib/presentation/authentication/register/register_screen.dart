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
  // Biến lưu trữ dữ liệu form
  final TextEditingController firstName = TextEditingController();
  final TextEditingController email = TextEditingController();
  final TextEditingController lastName = TextEditingController();
  final TextEditingController password = TextEditingController();

  void _submitForm() async {
    // Xử lý gửi form (API, Database, etc.)

    if (email.text.isEmpty ||
        password.text.isEmpty ||
        firstName.text.isEmpty ||
        lastName.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill all fields")),
      );
      return;
    }

    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    bool success = await authProvider.register(
        email.text, password.text, firstName.text, lastName.text);

    if (success) {
      // ScaffoldMessenger.of(context).showSnackBar(
      //   const SnackBar(content: Text("Register success")),
      // );
      bool loginSuccess = await authProvider.login(email.text, password.text);
      if (loginSuccess) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Register & Login success")),
        );
        
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
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => 
                //ChangeNotifierProvider.value(
                  //value: Provider.of<ProfileProvider>(context, listen: false),
                  //child: 
                  FirstTimeUpdateProfileScreen(userId: userId),
               // ),
              ),
            );
            return;
          }
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Login failed")),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Register failed")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("Register")),
        body: ListView(children: [
          Container(
            padding: EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomTextInput(
                  controller: firstName,
                  labelText: "First Name",
                  icon: Icons.person,
                ),
                SizedBox(
                  height: 30,
                ),
                CustomTextInput(
                  controller: lastName,
                  labelText: "Last Name",
                  icon: Icons.person,
                ),
                SizedBox(
                  height: 30,
                ),
                CustomTextInput(
                  controller: email,
                  labelText: "Email",
                  icon: Icons.mail,
                ),
                SizedBox(
                  height: 30,
                ),
                CustomTextInput(
                  controller: password,
                  labelText: "Password",
                  icon: Icons.lock,
                  obscureText: true,
                ),
                SizedBox(
                  height: 30,
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.redAccent),
                  onPressed: _submitForm,
                  child: Container(
                      padding: EdgeInsets.all(16),
                      child: Text("Register",
                          style: TextStyle(fontSize: 20, color: Colors.white))),
                ),
              ],
            ),
          ),
        ]));
  }
}
