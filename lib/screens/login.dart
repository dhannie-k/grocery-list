import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/all.dart';

import '../states/riverpod_state_mgmt.dart';
import '../utils/form_field_validator.dart';

final loadingStateProvider = StateProvider<bool>((ref) => false);

class LoginScreen extends ConsumerWidget {
  final _loginFormKey = GlobalKey<FormState>();
  final _emailTxtController = TextEditingController();
  final _passwordTxtController = TextEditingController();

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    bool isLoading = watch(loadingStateProvider).state;
    final userSignIn = watch(firebaseAuthServiceProvider);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'GROCERY APP',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
                fit: BoxFit.cover,
                image: AssetImage('assets/images/2664645-04.png'))),
        height: MediaQuery.of(context).size.height,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView(
            scrollDirection: Axis.vertical,
            children: [
              SizedBox(height: 40.0),
              Form(
                key: _loginFormKey,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                child: Column(
                  children: [
                    TextFormField(
                      validator: (value) => validateEmail(value),
                      controller: _emailTxtController,
                      decoration: InputDecoration(
                          labelText: 'email',
                          labelStyle: TextStyle(
                              fontSize: 18.0,
                              color: Colors.black,
                              fontWeight: FontWeight.w400)),
                      keyboardType: TextInputType.emailAddress,
                    ),
                    TextFormField(
                      validator: (value) => validatePassword(value),
                      controller: _passwordTxtController,
                      decoration: InputDecoration(
                          labelText: 'password',
                          labelStyle: TextStyle(
                              fontSize: 18.0,
                              color: Colors.black,
                              fontWeight: FontWeight.w400)),
                      obscureText: true,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: FlatButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6.0)),
                        color: Colors.amber.withOpacity(0.9),
                        splashColor: Colors.amberAccent,
                        child: Text(
                          'Login',
                          style: TextStyle(fontSize: 18.0, color: Colors.white),
                        ),
                        onPressed: () async {
                          if (_loginFormKey.currentState.validate()) {
                            context.read(loadingStateProvider).state = true;
                            try {
                              await userSignIn
                                  .signInWithEmail(
                                      _emailTxtController.text.trim(),
                                      _passwordTxtController.text.trim())
                                  .whenComplete(() => context
                                      .read(loadingStateProvider)
                                      .state = false);
                            } on FirebaseAuthException catch (e) {
                              context.read(loadingStateProvider).state = false;
                              Scaffold.of(context).showSnackBar(SnackBar(
                                content: Text('${e.message}'),
                              ));
                            }
                          }
                        },
                      ),
                    )
                  ],
                ),
              ),
              Center(
                child: Container(
                  color: Colors.white.withOpacity(0.8),
                  width: MediaQuery.of(context).size.width * 0.7,
                  height: 50.0,
                  child: OutlineButton(
                    splashColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    onPressed: () {
                      context.read(loadingStateProvider).state = true;
                      userSignIn.signInWithGoogle().whenComplete(() =>
                          context.read(loadingStateProvider).state = false);
                    },
                    child: Visibility(
                      visible: isLoading == false,
                      replacement: CircularProgressIndicator(),
                      child: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(6.0),
                            child: Image(
                              image:
                                  AssetImage('assets/images/google_logo.png'),
                            ),
                          ),
                          Text(
                            'Sign in with Google',
                            style: TextStyle(
                                fontSize: 18.0, color: Colors.black87),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
