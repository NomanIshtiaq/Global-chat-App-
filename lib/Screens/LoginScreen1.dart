import 'package:flutter/material.dart';
import 'package:globachat/Screens/signup.dart';
import 'package:globachat/controllers/Login-controllers.dart';

class Loginscreen extends StatefulWidget {
  const Loginscreen({super.key});

  @override
  State<Loginscreen> createState() => _SignupState();
}

class _SignupState extends State<Loginscreen> {
  bool isloading = false;
  var userform = GlobalKey<FormState>();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: userform,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              SizedBox(height: 85),

              Image.asset("assets/image/glob.jpeg", height: 150),
              TextFormField(
                autovalidateMode: AutovalidateMode.onUserInteraction,
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
                controller: password,
                obscureText: true,
                enableSuggestions: false,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "password is required ";
                  }
                  return null;
                },
                decoration: InputDecoration(label: Text('Password')),
              ),

              SizedBox(height: 55),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        minimumSize: Size(0, 50),
                        backgroundColor: Color.fromARGB(255, 27, 99, 123),
                        foregroundColor: Colors.white,
                      ),
                      onPressed: () {
                        if (userform.currentState!.validate()) {
                          // create function
                          isloading = true;
                          setState(() {});
                          Logincontrollers.login(
                            context: context,
                            email: email.text,
                            password: password.text,
                          );
                          isloading = false;
                          setState(() {});
                        }
                      },
                      child: isloading
                          ? CircularProgressIndicator(color: Colors.white)
                          : Text("Login"),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 25),
              Row(
                children: [
                  Text("Dont't have Account---------->"),
                  SizedBox(width: 50),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return Signup();
                          },
                        ),
                      );
                    },
                    child: Text(
                      "Sign-up here?",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
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
