import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login/flutter_login.dart';
import 'package:qrscan/pages/homepage.dart';
import 'package:http/http.dart' as http;

// const users = {
//   'dribbble@gmail.com': '12345',
//   'hunter@gmail.com': 'hunter',
// };

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  var urlBase = "https://api.daveget.tech/api";

  // Duration get loginTime => const Duration(milliseconds: 2250);
  // Future<String?> _authUser(LoginData data) {
  //   debugPrint('Name: ${data.name}, Password: ${data.password}');
  //   return Future.delayed(loginTime).then((_) {
  //     if (!users.containsKey(data.name)) {
  //       return 'User not exists';
  //     }
  //     if (users[data.name] != data.password) {
  //       return 'Password does not match';
  //     }
  //     return null;
  //   });
  // }

  Future<String?> login(LoginData data) async {
    final dio = Dio();
    dio.options.baseUrl = urlBase;
    print("$urlBase/auth/login");
    var abc = {
      "email": data.name,
      "password": data.password,
    };
    print(abc);
    try {
      // var response = await dio.post(
      //   "$urlBase/auth/login",
      //   data: {
      //     "email": data.name,
      //     "password": data.password,
      //   },
      // );
      var url = Uri.parse(urlBase);
      var response = await http.post(
        url,
        body: {
          "email": data.name.toString().trim(),
          "password": data.password.toString().trim(),
        },
      );
      print("===========================================");
      print(response.statusCode);
      print(response.headers);
      print(response.body);
      print("===========================================");

      // if (response.statusCode == 200 || response.statusCode == 201) {
      //   return null;
      // } else {
      //   return "Password does not match";
      // }
    } catch (e) {
      print(e);
      return "Unknown error encountered!";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FlutterLogin(
        theme: LoginTheme(
          pageColorLight: Colors.white,
          primaryColor: Colors.green,
        ),
        logo: const AssetImage('assets/airlines-logo.png'),
        onLogin: login,
        // onSignup: _signupUser,
        hideForgotPasswordButton: true,
        onSubmitAnimationCompleted: () {
          Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (context) => const HomePage(),
          ));
        },
        onRecoverPassword: (string) {
          return null;
        },
      ),
    );
  }
}
