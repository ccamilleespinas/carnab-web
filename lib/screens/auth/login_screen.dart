import 'package:flutter/material.dart';
import 'package:sunspark_web/screens/home_screen.dart';
import 'package:sunspark_web/widgets/button_widget.dart';
import 'package:sunspark_web/widgets/textfield_widget.dart';

class LoginScreen extends StatelessWidget {
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/carnab.png',
              height: 150,
            ),
            const SizedBox(
              height: 20,
            ),
            TextFieldWidget(
                width: 375, label: 'Username', controller: usernameController),
            const SizedBox(
              height: 10,
            ),
            TextFieldWidget(
                width: 375,
                isObscure: true,
                isPassword: true,
                label: 'Password',
                controller: passwordController),
            const SizedBox(
              height: 30,
            ),
            ButtonWidget(
              width: 375,
              color: Colors.blue,
              label: 'Login',
              onPressed: () {
                // if (usernameController.text == 'username' &&
                //     passwordController.text == 'password') {
                //   Navigator.of(context).pushReplacement(MaterialPageRoute(
                //       builder: (context) => const HomeScreen()));
                //   showToast('Logged in Succesfully!');
                // } else {
                //   showToast('INVALID ACCOUNT!');
                // }
                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => HomeScreen()));
              },
            ),
          ],
        ),
      ),
    );
  }
}
