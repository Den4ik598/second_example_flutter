import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:login/auth/navigator_key.dart';


class signUp extends StatefulWidget {
  const signUp({super.key});

  @override
  State<signUp> createState() => _LoginPageState();
}

class _LoginPageState extends State<signUp> {
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();

  signInWithEmailAndPassword() async {
        try {
          setState(() {
            isLoading = true;
          });
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _email.text,
        password: _password.text,
      );
      setState(() {
            isLoading = false;
          });
    } on FirebaseAuthException catch (e) {
      setState(() {
            isLoading = true;
          });
      if (e.code == 'user-not-found') {
        return ScaffoldMessenger.of(navigatorKey.currentContext!).showSnackBar(
          const SnackBar(content: Text("No Uesr found for that email"),),
        );
        
      } else if (e.code == 'wrong-password') {
        return ScaffoldMessenger.of(navigatorKey.currentContext!).showSnackBar(
          const SnackBar(content: Text("Wrong password"),),
        );
      }
    }
  }

  createUserWithEmailAndPassword() async{
    try {
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _email.text,
          password: _password.text,
        );
      } on FirebaseAuthException catch (e) {
        if (e.code == 'weak-password') {
          return ScaffoldMessenger.of(navigatorKey.currentContext!).showSnackBar(
          const SnackBar(content: Text("the password provided is too weak"),),
          );
        } else if (e.code == 'email-already-in-use') {
          return ScaffoldMessenger.of(navigatorKey.currentContext!).showSnackBar(
          const SnackBar(content: Text("The account exists for that email"),),
          );
        }
      } catch (e) {
        print(e);
      }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                const Spacer(flex: 10,),
                TextFormField(
                  controller: _email,
                  validator: (text) {
                    if (text == null || text.isEmpty) {
                      return 'Email is empty';
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                      hintText: "Email",
                      fillColor: Color.fromARGB(255, 172, 12, 201)),
                ),
                const Spacer(),
                TextFormField(
                  controller: _password,
                  validator: (text) {
                    if (text == null || text.isEmpty) {
                      return 'Password is empty';
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                      hintText: "Password",
                      fillColor: Color.fromARGB(255, 172, 12, 201)),
                ),
                const Spacer(),
                SizedBox(
                  width: double.infinity,
                  height: 45,
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        signInWithEmailAndPassword();
                      }
                    },
                    child: isLoading ? const Center(child: CircularProgressIndicator(color: Colors.purple,),):const Text("login"),
                  ),
                ),
                const Spacer(),
                SizedBox(
                  width: double.infinity,
                  height: 45,
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        
                      }
                    },
                    child: isLoading ? const Center(child: CircularProgressIndicator(color: Colors.purple,),): const Text("signUp"),
                  ),
                ),
                const Spacer(flex: 10,),
              ],
            ),
          )),
    ));
  }
}
