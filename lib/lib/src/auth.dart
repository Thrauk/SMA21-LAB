import 'package:flutter/material.dart';
import 'package:laborator_sma/lib/src/repository/auth_repository.dart';
import 'package:laborator_sma/lib/src/view_payments.dart';

class Auth extends StatelessWidget {
  const Auth({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Scaffold(body: AuthPage()),
    );
  }
}

class AuthPage extends StatefulWidget {
  const AuthPage({Key? key}) : super(key: key);

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  String email = '';
  String password = '';
  String errorText = '';
  FirebaseAuthRepository firebaseAuthRepository = FirebaseAuthRepository();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          TextField(
            onChanged: (String value) {
              setState(() {
                email = value;
              });
            },
            decoration: const InputDecoration(
              labelText: 'Email',
            ),
          ),
          TextField(
            onChanged: (String value) {
              setState(() {
                password = value;
              });
            },
            decoration: const InputDecoration(
              labelText: 'Password',
            ),
            obscureText: true,
          ),
          Text(
            errorText,
            style: const TextStyle(
              color: Colors.red,
            ),
          ),
          Container(
            height: 40,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                TextButton(onPressed: () async {
                  try {
                    await firebaseAuthRepository.signUpWithEmailAndPassword(email: email, password: password);
                    Navigator.of(context).push<void>(MaterialPageRoute<void>(builder: (_) => const ViewPayments()));
                  }
                  catch (e) {
                    setState(() {
                      errorText = 'Email already in use';
                    });
                  }
                }, child: const Text('Register')),
                TextButton(onPressed: () async {
                  try {
                    await firebaseAuthRepository.logInWithEmailAndPassword(email: email, password: password);
                    Navigator.of(context).push<void>(MaterialPageRoute<void>(builder: (_) => const ViewPayments()));
                  }
                  catch (e) {
                    setState(() {
                      errorText = 'Email/Password invalid';
                    });
                  }
                }, child: const Text('Log In')),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

