// ignore_for_file: depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:praktikum/application/todo/todo_bloc.dart';
import 'package:praktikum/application/todo/todo_event.dart';
import 'package:praktikum/application/todo/todo_state.dart';
import 'package:uuid/uuid.dart';
import '../model/todo_model.dart';
import '../widget/navigation.dart';
import 'package:praktikum/service/helper/cart.provider.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController searchController = TextEditingController();
  String selectedPriority = 'Important & Urgent';
  String filter = 'All';

  final CartHelper _cartHelper = CartHelper();

  final List<String> priorities = [
    'Important & Urgent',
    'Important but Not Urgent',
    'Not Important but Urgent',
    'Not Important & Not Urgent',
  ];

  @override
  Widget build(BuildContext context) {
    void showTodoDialog({Todo? todo}) {
      if (todo != null) {
        titleController.text = todo.title;
        descriptionController.text = todo.description ?? '';
        selectedPriority = todo.priority ?? priorities[0];
      } else {
        selectedPriority = priorities[0];
      }

      showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(
            builder: (context, setState) {
              return AlertDialog(
                title: Text(todo == null ? 'Add Todo' : 'Edit Todo'),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: titleController,
                      decoration: const InputDecoration(hintText: 'Todo title'),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: descriptionController,
                      decoration: const InputDecoration(
                        hintText: 'Description',
                      ),
                    ),
                    const SizedBox(height: 10),
                    DropdownButtonFormField<String>(
                      value: selectedPriority,
                      decoration: const InputDecoration(
                        labelText: 'Prioritas',
                        border: OutlineInputBorder(),
                      ),
                      items:
                          priorities.map((priority) {
                            return DropdownMenuItem(
                              value: priority,
                              child: Text(priority),
                            );
                          }).toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedPriority = value!;
                        });
                      },
                    ),
                  ],
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      titleController.clear();
                      descriptionController.clear();
                    },
                    child: const Text('Cancel'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      if (titleController.text.isNotEmpty) {
                        final title = titleController.text;
                        final desc = descriptionController.text;

                        if (todo == null) {
                          context.read<TodoBloc>().add(
                            AddTodo(
                              Todo(
                                id: const Uuid().v4(),
                                title: title,
                                description: desc,
                                priority: selectedPriority,
                                date: null,
                                notes: '',
                                category: '',
                              ),
                            ),
                          );
                        } else {
                          context.read<TodoBloc>().add(
                            UpdateTodo(
                              Todo(
                                id: todo.id,
                                title: title,
                                description: desc,
                                priority: selectedPriority,
                                isDone: todo.isDone,
                                date: null,
                                notes: '',
                                category: '',
                              ),
                            ),
                          );
                        }

                        Navigator.pop(context);
                        titleController.clear();
                        descriptionController.clear();
                      }
                    },
                    child: Text(todo == null ? 'Add' : 'Update'),
                  ),
                ],
              );
            },
          );
        },
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Todo List'),
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: () => Navigator.pushNamed(context, '/history'),
          ),
          DropdownButton<String>(
            value: filter,
            onChanged: (value) {
              if (value != null) {
                setState(() {
                  filter = value;
                });
              }
            },
            items:
                ['All', 'Completed', 'Incomplete']
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: searchController,
              decoration: const InputDecoration(
                hintText: 'Search by title, description or priority',
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: (value) => setState(() {}),
            ),
          ),
          Expanded(
            child: BlocBuilder<TodoBloc, TodoState>(
              builder: (context, state) {
                final filtered =
                    state.todos.where((todo) {
                      if (filter == 'Completed' && !todo.isDone) return false;
                      if (filter == 'Incomplete' && todo.isDone) return false;
                      final query = searchController.text.toLowerCase();
                      return todo.title.toLowerCase().contains(query) ||
                          (todo.description?.toLowerCase().contains(query) ??
                              false) ||
                          (todo.priority?.toLowerCase().contains(query) ??
                              false);
                    }).toList();

                if (filtered.isEmpty) {
                  return const Center(child: Text('Tidak ada data'));
                }

                return ListView.builder(
                  itemCount: filtered.length,
                  itemBuilder: (context, index) {
                    final todo = filtered[index];
                    return ListTile(
                      tileColor: const Color.fromARGB(255, 179, 69, 69),
                      leading: Checkbox(
                        value: todo.isDone,
                        onChanged: (val) async {
                          context.read<TodoBloc>().add(
                            ToggleTodoStatus(todo.id, val!),
                          );

                          if (val == true) {
                            // ✅ Tambahkan ke riwayat
                            final completedTask = {
                              'id': DateTime.now().millisecondsSinceEpoch,
                              'name': todo.title,
                              'quantity': 1,
                              'price': 0,
                              'timestamp': DateTime.now().toIso8601String(),
                            };
                            await _cartHelper.insertCartItem(completedTask);
                          }
                        },
                      ),
                      title: Text(
                        todo.title,
                        style: const TextStyle(color: Colors.white),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (todo.description != null)
                            Text(
                              todo.description!,
                              style: const TextStyle(color: Colors.white70),
                            ),
                          if (todo.priority != null)
                            Text(
                              'Prioritas: ${todo.priority}',
                              style: const TextStyle(color: Colors.white70),
                            ),
                        ],
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit, color: Colors.white),
                            onPressed: () => showTodoDialog(todo: todo),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.white),
                            onPressed:
                                () => context.read<TodoBloc>().add(
                                  DeleteTodo(todo.id),
                                ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showTodoDialog(),
        child: const Icon(Icons.add),
      ),
      bottomNavigationBar: const CustomNavigationBar(
        selectedIndex: 0,
        selectIndex: 0,
      ),
    );
  }
}
