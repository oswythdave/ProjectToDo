import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:praktikum/application/todo/todo_bloc.dart';
import 'package:praktikum/application/todo/todo_event.dart';
import 'package:praktikum/application/todo/todo_state.dart';
import 'package:uuid/uuid.dart';
import '../model/todo_model.dart';
import '../widget/navigation.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController notesController = TextEditingController();
  final TextEditingController searchController = TextEditingController();
  String selectedPriority = 'Important & Urgent';
  String selectedCategory = 'Pribadi';
  String filter = 'All';
  bool isCalendarView = false;
  bool showBadge = true;
  DateTime selectedDate = DateTime.now();
  DateTime? selectedTodoDate;
  TimeOfDay? selectedTime;

  final List<String> priorities = [
    'Important & Urgent',
    'Important but Not Urgent',
    'Not Important but Urgent',
    'Not Important & Not Urgent',
  ];

  final List<String> categories = ['Kuliah', 'Kerja', 'Pribadi'];

  void showTodoDialog({Todo? todo, DateTime? date}) {
    if (todo != null) {
      titleController.text = todo.title;
      descriptionController.text = todo.description ?? '';
      notesController.text = todo.notes ?? '';
      selectedPriority = todo.priority ?? priorities[0];
      selectedCategory = todo.category ?? categories[0];
      selectedTodoDate = todo.date ?? DateTime.now();
      selectedTime = TimeOfDay.fromDateTime(todo.date ?? DateTime.now());
    } else {
      titleController.clear();
      descriptionController.clear();
      notesController.clear();
      selectedPriority = priorities[0];
      selectedCategory = categories[0];
      selectedTodoDate = date ?? DateTime.now();
      selectedTime = TimeOfDay.now();
    }

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text(todo == null ? 'Add Todo' : 'Edit Todo'),
              content: SingleChildScrollView(
                child: Column(
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
                        hintText:
                            'Description (e.g. checklist, catatan, deadline)',
                      ),
                      maxLines: 3,
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: notesController,
                      decoration: const InputDecoration(
                        labelText: 'Notes (opsional)',
                        border: OutlineInputBorder(),
                      ),
                      maxLines: 2,
                    ),
                    const SizedBox(height: 10),
                    DropdownButtonFormField<String>(
                      value: selectedCategory,
                      decoration: const InputDecoration(
                        labelText: 'Kategori',
                        border: OutlineInputBorder(),
                      ),
                      items:
                          categories
                              .map(
                                (cat) => DropdownMenuItem(
                                  value: cat,
                                  child: Text(cat),
                                ),
                              )
                              .toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedCategory = value!;
                        });
                      },
                    ),
                    const SizedBox(height: 10),
                    DropdownButtonFormField<String>(
                      value: selectedPriority,
                      decoration: const InputDecoration(
                        labelText: 'Prioritas',
                        border: OutlineInputBorder(),
                      ),
                      items:
                          priorities
                              .map(
                                (priority) => DropdownMenuItem(
                                  value: priority,
                                  child: Text(priority),
                                ),
                              )
                              .toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedPriority = value!;
                        });
                      },
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        const Text("Tanggal: "),
                        TextButton(
                          child: Text(
                            "${selectedTodoDate?.day}/${selectedTodoDate?.month}/${selectedTodoDate?.year}",
                          ),
                          onPressed: () async {
                            final picked = await showDatePicker(
                              context: context,
                              initialDate: selectedTodoDate ?? DateTime.now(),
                              firstDate: DateTime(2000),
                              lastDate: DateTime(2100),
                            );
                            if (picked != null) {
                              setState(() {
                                selectedTodoDate = picked;
                              });
                            }
                          },
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        const Text("Jam: "),
                        TextButton(
                          child: Text(selectedTime?.format(context) ?? '--:--'),
                          onPressed: () async {
                            final picked = await showTimePicker(
                              context: context,
                              initialTime: selectedTime ?? TimeOfDay.now(),
                            );
                            if (picked != null) {
                              setState(() {
                                selectedTime = picked;
                              });
                            }
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    titleController.clear();
                    descriptionController.clear();
                    notesController.clear();
                  },
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (titleController.text.isNotEmpty) {
                      final title = titleController.text;
                      final desc = descriptionController.text;
                      final notes = notesController.text;
                      final date = DateTime(
                        selectedTodoDate!.year,
                        selectedTodoDate!.month,
                        selectedTodoDate!.day,
                        selectedTime?.hour ?? 0,
                        selectedTime?.minute ?? 0,
                      );

                      final todoObj = Todo(
                        id: todo?.id ?? const Uuid().v4(),
                        title: title,
                        description: desc,
                        priority: selectedPriority,
                        date: date,
                        isDone: todo?.isDone ?? false,
                        notes: notes,
                        category: selectedCategory,
                      );

                      if (todo == null) {
                        context.read<TodoBloc>().add(AddTodo(todoObj));
                      } else {
                        context.read<TodoBloc>().add(UpdateTodo(todoObj));
                      }

                      Navigator.pop(context);
                      titleController.clear();
                      descriptionController.clear();
                      notesController.clear();
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

  String getCountdownText(DateTime deadline) {
    final now = DateTime.now();
    final diff = deadline.difference(now);
    if (diff.isNegative) {
      return "Sudah lewat deadline";
    } else {
      final hours = diff.inHours;
      final minutes = diff.inMinutes % 60;
      return "Sisa waktu: ${hours} jam ${minutes} menit";
    }
  }

  Color getPriorityColor(String? priority) {
    switch (priority) {
      case 'Important & Urgent':
        return Colors.red.shade300;
      case 'Important but Not Urgent':
        return Colors.orange.shade300;
      case 'Not Important but Urgent':
        return Colors.yellow.shade300;
      case 'Not Important & Not Urgent':
        return Colors.green.shade300;
      default:
        return Colors.grey.shade300;
    }
  }

  Widget _buildListView() {
    return BlocBuilder<TodoBloc, TodoState>(
      builder: (context, state) {
        List<Todo> filtered =
            state.todos.where((todo) {
              if (filter == 'Completed' && !todo.isDone) return false;
              if (filter == 'Incomplete' && todo.isDone) return false;
              final query = searchController.text.toLowerCase();
              final sameDate =
                  todo.date?.day == selectedDate.day &&
                  todo.date?.month == selectedDate.month &&
                  todo.date?.year == selectedDate.year;
              final matchQuery =
                  todo.title.toLowerCase().contains(query) ||
                  (todo.description?.toLowerCase().contains(query) ?? false) ||
                  (todo.priority?.toLowerCase().contains(query) ?? false);
              return (sameDate ||
                      (todo.date?.isAfter(DateTime.now()) ?? false)) &&
                  matchQuery;
            }).toList();

        int completedCount = filtered.where((t) => t.isDone).length;
        double progress =
            filtered.isEmpty ? 0 : completedCount / filtered.length;

        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Progress Hari Ini:"),
                  const SizedBox(height: 6),
                  LinearProgressIndicator(
                    value: progress,
                    backgroundColor: Colors.grey.shade300,
                    color: Colors.blueAccent,
                    minHeight: 10,
                  ),
                  const SizedBox(height: 4),
                  Text("${(progress * 100).toStringAsFixed(0)}% selesai"),
                ],
              ),
            ),
            Expanded(
              child:
                  filtered.isEmpty
                      ? const Center(child: Text('Tidak ada data'))
                      : ListView.builder(
                        itemCount: filtered.length,
                        itemBuilder: (context, index) {
                          final todo = filtered[index];
                          return Container(
                            margin: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: getPriorityColor(todo.priority),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Checkbox(
                                          value: todo.isDone,
                                          onChanged: (val) {
                                            context.read<TodoBloc>().add(
                                              ToggleTodoStatus(todo.id, val!),
                                            );
                                          },
                                        ),
                                        Text(
                                          todo.title,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        IconButton(
                                          icon: const Icon(Icons.edit),
                                          onPressed:
                                              () => showTodoDialog(todo: todo),
                                        ),
                                        IconButton(
                                          icon: const Icon(Icons.delete),
                                          onPressed:
                                              () => context
                                                  .read<TodoBloc>()
                                                  .add(DeleteTodo(todo.id)),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                if (todo.description != null &&
                                    todo.description!.isNotEmpty)
                                  Text('Deskripsi: ${todo.description!}'),
                                if (todo.notes != null &&
                                    todo.notes!.isNotEmpty)
                                  Text('Catatan: ${todo.notes!}'),
                                if (todo.priority != null)
                                  Text('Prioritas: ${todo.priority!}'),
                                if (todo.category != null)
                                  Text('Kategori: ${todo.category!}'),
                                if (todo.date != null)
                                  Text(
                                    'Tanggal: ${todo.date!.day}/${todo.date!.month}/${todo.date!.year}  '
                                    'Jam: ${todo.date!.hour.toString().padLeft(2, '0')}:${todo.date!.minute.toString().padLeft(2, '0')}',
                                  ),
                              ],
                            ),
                          );
                        },
                      ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildCalendarView() {
    final daysInWeek = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];

    int daysInMonth(DateTime date) {
      final firstDayNextMonth =
          (date.month < 12)
              ? DateTime(date.year, date.month + 1, 1)
              : DateTime(date.year + 1, 1, 1);
      return firstDayNextMonth.subtract(const Duration(days: 1)).day;
    }

    int getStartWeekdayOfMonth(DateTime date) {
      return DateTime(date.year, date.month, 1).weekday % 7;
    }

    final currentMonth = selectedDate.month;
    final currentYear = selectedDate.year;
    final totalDays = daysInMonth(selectedDate);
    final startWeekday = getStartWeekdayOfMonth(selectedDate);

    return Column(
      children: [
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              icon: const Icon(Icons.arrow_back_ios),
              onPressed: () {
                setState(() {
                  selectedDate = DateTime(
                    selectedDate.year,
                    selectedDate.month - 1,
                    selectedDate.day,
                  );
                });
              },
            ),
            Text(
              '${_monthName(currentMonth)} $currentYear',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            IconButton(
              icon: const Icon(Icons.arrow_forward_ios),
              onPressed: () {
                setState(() {
                  selectedDate = DateTime(
                    selectedDate.year,
                    selectedDate.month + 1,
                    selectedDate.day,
                  );
                });
              },
            ),
          ],
        ),
        const SizedBox(height: 5),
        GridView.count(
          crossAxisCount: 7,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          children: daysInWeek.map((day) => Center(child: Text(day))).toList(),
        ),
        Expanded(
          child: GridView.builder(
            padding: const EdgeInsets.all(10),
            itemCount: totalDays + startWeekday,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7,
              crossAxisSpacing: 4,
              mainAxisSpacing: 4,
            ),
            itemBuilder: (context, index) {
              if (index < startWeekday) return const SizedBox.shrink();
              final day = index - startWeekday + 1;
              final isSelected = selectedDate.day == day;
              return GestureDetector(
                onTap: () {
                  setState(() {
                    selectedDate = DateTime(currentYear, currentMonth, day);
                  });
                },
                onLongPress:
                    () => showTodoDialog(
                      date: DateTime(currentYear, currentMonth, day),
                    ),
                child: Container(
                  decoration: BoxDecoration(
                    color:
                        isSelected
                            ? Colors.green.shade400
                            : Colors.orange.shade300,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(child: Text('$day')),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  String _monthName(int month) {
    const monthNames = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];
    return monthNames[month - 1];
  }

  String _dayName(int weekday) {
    const dayNames = [
      'Senin',
      'Selasa',
      'Rabu',
      'Kamis',
      'Jumat',
      'Sabtu',
      'Minggu',
    ];
    return dayNames[(weekday - 1) % 7];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('QuickPlan Todo List App'),
        actions: [
          IconButton(
            icon: Icon(isCalendarView ? Icons.list : Icons.calendar_today),
            onPressed: () {
              setState(() {
                isCalendarView = !isCalendarView;
              });
            },
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
          StreamBuilder<DateTime>(
            stream: Stream.periodic(
              const Duration(seconds: 1),
              (_) => DateTime.now(),
            ),
            builder: (context, snapshot) {
              final now = snapshot.data ?? DateTime.now();
              final time =
                  "${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}:${now.second.toString().padLeft(2, '0')}";
              final date =
                  "${_dayName(now.weekday)}, ${now.day.toString().padLeft(2, '0')} ${_monthName(now.month)} ${now.year}";
              return Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 8.0,
                  horizontal: 16,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Tanggal: $date",
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "Jam: $time",
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
          if (!isCalendarView)
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
            child: isCalendarView ? _buildCalendarView() : _buildListView(),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showTodoDialog(date: selectedDate),
        child: const Icon(Icons.add),
      ),
      bottomNavigationBar: const CustomNavigationBar(
        selectedIndex: 0,
        selectIndex: 0,
      ),
    );
  }
}
