class Todo {
  final String id;
  final String title;
  final String? description;
  final String? priority;
  final bool isDone;
  final DateTime? date; // ✅ tambahkan properti date

  Todo({
    required this.id,
    required this.title,
    this.description,
    this.priority,
    this.isDone = false,
    this.date,
    required String notes,
    DateTime? time,
    required String category, // ✅ masukkan ke constructor
  });

  get notes => null;

  get category => null;

  Todo copyWith({
    String? id,
    String? title,
    String? description,
    String? priority,
    bool? isDone,
    DateTime? date, // ✅ tambahkan di copyWith
  }) {
    return Todo(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      priority: priority ?? this.priority,
      isDone: isDone ?? this.isDone,
      date: date ?? this.date,
      notes: '',
      category: '', // ✅ simpan date lama jika tidak diubah
    );
  }
}
