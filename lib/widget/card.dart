import 'package:flutter/material.dart';

class TaskHistoryCard extends StatelessWidget {
  final Map<String, dynamic> task;

  const TaskHistoryCard({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: ListTile(
        leading: const Icon(Icons.check_circle, color: Colors.green),
        title: Text(
          task["name"] ?? '',
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        subtitle: Text(
          "Selesai pada: ${task["timestamp"] ?? '-'}",
          style: const TextStyle(color: Colors.grey, fontSize: 12),
        ),
        trailing: const Icon(Icons.history, color: Colors.grey),
      ),
    );
  }
}
