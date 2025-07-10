import 'package:flutter/material.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationState();
}

class _NotificationState extends State<NotificationPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.zero,
        child: AppBar(
          scrolledUnderElevation: 0.0,
          backgroundColor: Colors.white,
        ),
      ),
      body: SingleChildScrollView(
        child: Center(child: Text("Halaman Notofikasi")),
      ),
    );
  }
}
