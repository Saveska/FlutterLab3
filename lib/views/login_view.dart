import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:lab3/views/register_view.dart';
import '../firebase_options.dart';
import 'exam_terms_view.dart';


class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {

  late final TextEditingController _email;
  late final TextEditingController _password;

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Login"),
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          TextField(
            controller: _email,
            enableSuggestions: false,
            autocorrect: false,
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(
              hintText: 'Email',
            ),
          ),
          TextField(
            controller: _password,
            obscureText: true,
            enableSuggestions: false,
            autocorrect: false,
            decoration: const InputDecoration(
              hintText: 'Password',
            ),
          ),
          TextButton(
            onPressed: () async {
              final email = _email.text;
              final password = _password.text;

              try {
                final userCredential = await FirebaseAuth.instance
                    .signInWithEmailAndPassword(
                    email: email,
                    password: password
                );
                print(userCredential);

                if (mounted) {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const ExamTermsView()),
                  );
                }

              } on FirebaseAuthException catch (e){
                print("Invalid credentials.");
              }
            },
            child: const Text('Login'),
          ),
          TextButton(onPressed: (){
            Navigator.of(context).pushNamedAndRemoveUntil(
                    '/register',
                    (route) => false);
          },
              child: const Text('Not registered yet? Register here!')
          ),
        ],
      ),
    );
  }
}
