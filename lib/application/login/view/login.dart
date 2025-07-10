import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:praktikum/application/login/bloc/login_bloc.dart';
import 'package:praktikum/application/login/bloc/login_event.dart';
import 'package:praktikum/application/login/bloc/login_state.dart';
import 'package:praktikum/application/register/view/register.dart';
import 'package:praktikum/view/home.dart';
import 'package:praktikum/view/task_history.dart' hide MyHomePage;

class LoginPage extends StatefulWidget {
  const LoginPage({super.key, required String username});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool passwordVisible = false;

  @override
  void initState() {
    super.initState();
    passwordVisible = true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: Size.zero,
        child: AppBar(
          scrolledUnderElevation: 0.0,
          backgroundColor: Colors.white,
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 16.0),
          child: BlocListener<LoginBloc, LoginState>(
            listener: (context, state) {
              if (state is LoginLoading) {
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder:
                      (context) =>
                          const Center(child: CircularProgressIndicator()),
                );
              } else if (state is LoginSuccess) {
                Navigator.of(context).pop();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => MyHomePage()),
                );
              } else if (state is LoginFailure) {
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Center(
                      child: Text(
                        state.error,
                        style: TextStyle(fontSize: 16.0, color: Colors.white),
                      ),
                    ),
                    backgroundColor: Colors.red,
                    duration: const Duration(seconds: 3),
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    margin: const EdgeInsets.all(10),
                    padding: const EdgeInsets.symmetric(
                      vertical: 10,
                      horizontal: 20,
                    ),
                  ),
                );
              }
            },
            child: Column(
              children: <Widget>[
                Container(
                  child: Column(
                    children: [
                      Container(
                        width: double.infinity,
                        height: 100.0,
                        child: Icon(Bootstrap.person, size: 100.0),
                      ),
                      const Text(
                        "Login",
                        style: TextStyle(
                          fontSize: 40.0,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF881FFF),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10.0),
                Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        child: Text(
                          "Email",
                          style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8.0),
                      TextField(
                        controller: emailController,
                        decoration: const InputDecoration(
                          hintText: 'Masukkan Email',
                          contentPadding: EdgeInsets.symmetric(
                            vertical: 10.0,
                            horizontal: 20.0,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(6.0),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10.0),
                Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const SizedBox(
                            child: Text(
                              "Password",
                              style: TextStyle(
                                fontSize: 16.0,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          // GestureDetector(
                          //   onTap: null,
                          //   child: const Text(
                          //     "Lupa Kata Sandi",
                          //     style: TextStyle(
                          //       fontSize: 14.0,
                          //       fontWeight: FontWeight.w500,
                          //       color: Color(0xFF881FFF),
                          //     ),
                          //   ),
                          // ),
                        ],
                      ),
                      const SizedBox(height: 8.0),
                      TextField(
                        controller: passwordController,
                        obscureText: passwordVisible,
                        decoration: InputDecoration(
                          hintText: 'Masukkan Password',
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 10.0,
                            horizontal: 20.0,
                          ),
                          border: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(6.0),
                            ),
                          ),
                          suffixIcon: GestureDetector(
                            onTap: () {
                              setState(() {
                                passwordVisible = !passwordVisible;
                              });
                            },
                            child: Icon(
                              passwordVisible
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10.0),
                SizedBox(
                  width: double.infinity,
                  child: GestureDetector(
                    onTap: () {
                      final emailText = emailController.text.trim();
                      final passwordText = passwordController.text.trim();
                      print(emailText);
                      print(passwordText);
                      if (emailText.isNotEmpty && passwordText.isNotEmpty) {
                        context.read<LoginBloc>().add(
                          LoginRequest(
                            email: emailText,
                            password: passwordText,
                          ),
                        );
                      }
                    },
                    child: Container(
                      decoration: const BoxDecoration(
                        color: Color(0xFF881FFF),
                        borderRadius: BorderRadius.all(Radius.circular(6.0)),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 10.0),
                      child: const Center(
                        child: Text(
                          "Masuk",
                          style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 30.0),
                SizedBox(
                  width: double.infinity,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Belum Punya Akun?",
                        style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const Text(" "),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const Register(),
                            ),
                          );
                        },
                        child: const Text(
                          "Daftar Di Sini",
                          style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF881FFF),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
