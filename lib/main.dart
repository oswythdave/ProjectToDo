import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:praktikum/account/account_bloc.dart';
import 'package:praktikum/application/login/bloc/login_bloc.dart';
import 'package:praktikum/application/login/view/login.dart';
import 'package:praktikum/application/register/bloc/register_bloc.dart';
import 'package:praktikum/application/todo/todo_bloc.dart';
import 'package:praktikum/view/home.dart';
import 'package:praktikum/view/settings.dart';
import 'package:praktikum/view/task_history.dart' hide MyHomePage;

// Dummy TaskHistory Widget, ganti dengan file asli kamu kalau ada
class TaskHistory extends StatelessWidget {
  const TaskHistory({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Task History')),
      body: const Center(child: Text('Riwayat tugas tampil di sini')),
    );
  }
}

void main() async {
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider<LoginBloc>(create: (context) => LoginBloc()),
        BlocProvider<RegisterBloc>(create: (context) => RegisterBloc()),
        BlocProvider<TodoBloc>(create: (context) => TodoBloc()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Todo App with Bloc',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.grey[100],
      ),
      home: const LoginPage(username: ''),
      routes: {
        '/home': (context) => const MyHomePage(),
        '/history': (context) => const TaskHistory(),
        '/settings': (context) => const Settings(),
      },
    );
  }
}
