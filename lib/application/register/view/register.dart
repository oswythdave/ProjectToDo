import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:praktikum/application/login/view/login.dart';
import 'package:praktikum/application/register/bloc/register_bloc.dart';
import 'package:praktikum/application/register/bloc/register_event.dart';
import 'package:praktikum/application/register/bloc/register_state.dart';
import 'package:praktikum/view/home.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
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
          child: BlocListener<RegisterBloc, RegisterState>(
            listener: (context, state) {
              if (state is RegisterLoading) {
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder:
                      (context) =>
                          const Center(child: CircularProgressIndicator()),
                );
              } else if (state is RegisterSuccess) {
                Navigator.of(context).pop(); // tutup loading dialog
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (_) => LoginPage(username: state.name),
                  ),
                );
              } else if (state is RegisterFailure) {
                Navigator.of(context).pop(); // tutup loading dialog
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Center(
                      child: Text(
                        state.error,
                        style: const TextStyle(
                          fontSize: 16.0,
                          color: Colors.white,
                        ),
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
                Column(
                  children: [
                    Container(
                      width: double.infinity,
                      height: 100.0,
                      child: Icon(Bootstrap.person, size: 100.0),
                    ),
                    const Text(
                      "Register",
                      style: TextStyle(
                        fontSize: 40.0,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF881FFF),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10.0),

                // Name Field
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Name",
                      style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 8.0),
                    TextField(
                      controller: nameController,
                      decoration: const InputDecoration(
                        hintText: 'Masukkan Nama',
                        contentPadding: EdgeInsets.symmetric(
                          vertical: 10.0,
                          horizontal: 20.0,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(6.0)),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 10.0),

                // Email Field
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Email",
                      style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.w500,
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
                          borderRadius: BorderRadius.all(Radius.circular(6.0)),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 10.0),

                // Password Field
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Password",
                      style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.w500,
                      ),
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
                          borderRadius: BorderRadius.all(Radius.circular(6.0)),
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

                const SizedBox(height: 30.0),

                // Register Button
                SizedBox(
                  width: double.infinity,
                  child: GestureDetector(
                    onTap: () {
                      final usernameText = nameController.text.trim();
                      final emailText = emailController.text.trim();
                      final passwordText = passwordController.text.trim();

                      if (usernameText.isNotEmpty &&
                          emailText.isNotEmpty &&
                          passwordText.isNotEmpty) {
                        context.read<RegisterBloc>().add(
                          RegisterRequest(
                            name: usernameText,
                            email: emailText,
                            password: passwordText,
                          ),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Field tidak boleh kosong'),
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
                          "Register",
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
