import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:untitledlogin/shared/components/components.dart';

bool showPsw = true;
var emailController = TextEditingController();
var pswController = TextEditingController();
var formKey = GlobalKey<FormState>();

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Center(
          child: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Login',
                    style: TextStyle(
                      color: Colors.blueAccent,
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  defaultTextFormField(
                    prefixIcon: Icons.email_outlined,
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'please enter your email';
                      }
                    },
                    label: 'email address',
                    onFieldSubmitted: (value) => print(value),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  defaultTextFormField(
                    showData: showPsw,
                    controller: pswController,
                    keyboardType: TextInputType.visiblePassword,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'please enter your password';
                      }
                    },
                    suffixIcon: showPsw
                        ? Icons.remove_red_eye_outlined
                        : Icons.visibility_off_outlined,
                    suffixPressed: () {
                      setState(() {
                        showPsw = !showPsw;
                      });
                    },
                    label: 'password',
                    prefixIcon: Icons.lock,
                    onFieldSubmitted: (value) => print(value),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const SizedBox(height: 10),
                  defaultMaterialButton(
                    width: double.infinity,
                    background: Colors.blue,
                    text: 'login',
                    onPressed: () {
                      if (formKey.currentState!.validate()) {
                        print(emailController.text);
                        print(pswController.text);
                      }
                    },
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Don\'t have an account?',
                      ),
                      TextButton(
                        onPressed: () {},
                        child: const Text('Register Now!'),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
