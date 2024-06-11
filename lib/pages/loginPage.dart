import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login/flutter_login.dart';
import 'package:qrscan/pages/homepage.dart';
import 'package:http/http.dart' as http;

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  var urlBase = "https://api.daveget.tech/api";

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
      var response = await dio.post(
        "$urlBase/auth/login",
        data: {
          "email": data.name,
          "password": data.password,
        },
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        print(response.data);
      }
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
