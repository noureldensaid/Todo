import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LoginTest extends StatefulWidget {
  const LoginTest({Key? key}) : super(key: key);

  @override
  _LoginTestState createState() => _LoginTestState();
}

class _LoginTestState extends State<LoginTest> {
  var emailContoller = TextEditingController();
  var pswContoller = TextEditingController();
  var formKey = GlobalKey<FormState>();
  bool showPsw = true;
  IconData? eyeIcon;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Login',
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Login',
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'email mus\'t be empty';
                      }
                      return null;
                    },
                    controller: emailContoller,
                    keyboardType: TextInputType.emailAddress,
                    onFieldSubmitted: (value) {
                      print(value);
                    },
                    decoration: const InputDecoration(
                      labelText: 'email address',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(
                        Icons.email,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'password mus\'t be empty';
                      }
                      return null;
                    },
                    controller: pswContoller,
                    onFieldSubmitted: (value) {
                      print(value);
                    },
                    keyboardType: TextInputType.visiblePassword,
                    obscureText: showPsw,
                    decoration: InputDecoration(
                      labelText: 'password',
                      border: const OutlineInputBorder(),
                      prefixIcon: const Icon(Icons.lock),
                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            showPsw = !showPsw;
                          });
                        },
                        icon: showPsw
                            ? const Icon(Icons.visibility_sharp)
                            : const Icon(Icons.visibility_off_sharp),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  MaterialButton(
                    child: const Text(
                      'LOGIN',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    onPressed: () {
                      if (formKey.currentState!.validate()) {
                        print('email: ${emailContoller.text}');
                        print('password: ${pswContoller.text}');
                      }
                    },
                    color: Colors.blue,
                    height: 40,
                    minWidth: double.infinity,
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
