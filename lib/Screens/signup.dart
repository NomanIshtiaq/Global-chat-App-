import 'package:flutter/material.dart';
import 'package:globachat/controllers/sign-up-controllers%20copy.dart';

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  var userform = GlobalKey<FormState>();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController name = TextEditingController();
  TextEditingController country = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Sign-up')),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Form(
                key: userform,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      SizedBox(height: 25),
                      Image.asset("assets/image/glob.jpeg", height: 150),
                      TextFormField(
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        controller: name,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Name is required ";
                          }
                          return null;
                        },
                        decoration: InputDecoration(label: Text('Name')),
                      ),
                      SizedBox(height: 25),
                      TextFormField(
                        controller: email,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Email is required ";
                          }
                          return null;
                        },
                        decoration: InputDecoration(label: Text('Email')),
                      ),
                      SizedBox(height: 20),
                      TextFormField(
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        controller: country,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Country is required ";
                          }
                          return null;
                        },
                        decoration: InputDecoration(label: Text('Country')),
                      ),
                      SizedBox(height: 25),
                      TextFormField(
                        controller: password,
                        obscureText: true,
                        enableSuggestions: false,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "password is required ";
                          }
                          return null;
                        },
                        decoration: InputDecoration(label: Text('Password')),
                      ),
                      SizedBox(height: 25),
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                minimumSize: Size(0, 50),
                                backgroundColor: Color.fromARGB(
                                  255,
                                  27,
                                  99,
                                  123,
                                ),
                                foregroundColor: Colors.white,
                              ),
                              onPressed: () {
                                if (userform.currentState!.validate()) {
                                  // create function
                                  Signupcontrollers.createaccount(
                                    context: context,
                                    email: email.text,
                                    password: password.text,
                                    name: name.text,
                                    country: country.text,
                                  );
                                }
                              },
                              child: Text("Create Account"),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
