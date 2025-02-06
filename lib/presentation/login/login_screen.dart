// lib/views/login_view.dart
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginViewState createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _isRememberMeChecked = false;

  void _clearEmail() {
    _emailController.clear();
  }

  void _clearPassword() {
    _passwordController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(''),
        foregroundColor: Theme.of(context).scaffoldBackgroundColor,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      ),
      body: Container(
        color: Theme.of(context).scaffoldBackgroundColor,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(0),
              child: SizedBox(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      padding: const EdgeInsets.all(15.0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Theme.of(context)
                              .scaffoldBackgroundColor, // Background color
                          border: Border.all(
                            color: Theme.of(context)
                                .scaffoldBackgroundColor, // Border color
                            width: 2.0, // Border width
                          ),
                          borderRadius:
                              BorderRadius.circular(0.0), // Border radius
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              spreadRadius: 2,
                              blurRadius: 5,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(8, 20, 8, 8),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              const SizedBox(height: 16.0),
                              TextFormField(
                                cursorColor: Theme.of(context).primaryColor,
                                controller: _emailController,
                                decoration: InputDecoration(
                                  labelText: 'User name',
                                  labelStyle:
                                      Theme.of(context).textTheme.labelMedium,
                                  suffixIcon: IconButton(
                                    color: const Color(0xFFB3B3B3),
                                    icon: const Icon(Icons.clear),
                                    onPressed: _clearEmail,
                                  ),
                                  enabledBorder: const UnderlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Color(0xFFD7D7D7)),
                                  ),
                                  focusedBorder: const UnderlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Color(0xFFD7D7D7)),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 16.0),
                              TextFormField(
                                controller: _passwordController,
                                decoration: InputDecoration(
                                  labelText: 'Password',
                                  labelStyle:
                                      Theme.of(context).textTheme.labelMedium,
                                  suffixIcon: IconButton(
                                    color: const Color(0xFFB3B3B3),
                                    icon: const Icon(Icons.clear),
                                    onPressed: _clearPassword,
                                  ),
                                  enabledBorder: const UnderlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Color(0xFFD7D7D7)),
                                  ),
                                  focusedBorder: const UnderlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Color(0xFFD7D7D7)),
                                  ),
                                ),
                                obscureText: true,
                              ),
                              const SizedBox(height: 10),
                              ListTileTheme(
                                  horizontalTitleGap: 0,
                                  child: CheckboxListTile(
                                    contentPadding: EdgeInsets.zero,
                                    activeColor: const Color(0xFF3E92EE),
                                    title: Text(
                                      'remember',
                                      style: Theme.of(context)
                                          .textTheme
                                          .labelMedium,
                                    ),
                                    value: _isRememberMeChecked,
                                    onChanged: (newValue) {
                                      setState(() {
                                        _isRememberMeChecked = newValue!;
                                      });
                                    },
                                    controlAffinity:
                                        ListTileControlAffinity.leading,
                                  )),
                              const SizedBox(height: 16.0),
                              _isLoading
                                  ? const CircularProgressIndicator(
                                      color: Color(0xFF2C62C0),
                                    )
                                  : Container(
                                      width: double.infinity,
                                      height: 40,
                                      margin: const EdgeInsets.symmetric(
                                          horizontal: 8),
                                      decoration: BoxDecoration(
                                        color: Theme.of(context)
                                            .scaffoldBackgroundColor, // Background color
                                        border: Border.all(
                                          color: Theme.of(context)
                                              .scaffoldBackgroundColor, // Border color
                                          width: 0.0, // Border width
                                        ),
                                        borderRadius: BorderRadius.circular(
                                            0.0), // Border radius
                                        boxShadow: [
                                          BoxShadow(
                                            color:
                                                Colors.black.withOpacity(0.2),
                                            spreadRadius: 2,
                                            blurRadius: 5,
                                            offset: const Offset(0, 3),
                                          ),
                                        ],
                                      ),
                                      child: ElevatedButton(
                                        onPressed: () {},
                                        style: ElevatedButton.styleFrom(
                                          foregroundColor:
                                              Theme.of(context).primaryColor,
                                          backgroundColor:
                                              const Color(0xFF2C62C0),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(0),
                                          ),
                                        ),
                                        child: const Text(
                                          'Login',
                                          style: TextStyle(
                                              fontFamily: "Epilogue",
                                              color: Colors.white,
                                              fontSize: 15,
                                              fontWeight: FontWeight.normal),
                                        ),
                                      ),
                                    ),
                              const SizedBox(height: 16.0),
                              Container(
                                height: 50,
                                padding: const EdgeInsets.all(8),
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 8),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  color:
                                      Theme.of(context).scaffoldBackgroundColor,
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
            ),
            const Padding(
              padding: EdgeInsets.all(40.0),
              child: Text(
                '2024 MY  TRACKER',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF8A8585),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
