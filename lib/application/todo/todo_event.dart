import 'package:praktikum/model/todo_model.dart';

abstract class TodoEvent {}

class AddTodo extends TodoEvent {
  final Todo todo;
  AddTodo(this.todo);
}

class UpdateTodo extends TodoEvent {
  final Todo todo;
  UpdateTodo(this.todo);
}

class DeleteTodo extends TodoEvent {
  final String id;
  DeleteTodo(this.id);
}

class ToggleTodoStatus extends TodoEvent {
  final String id;
  final bool isDone;
  ToggleTodoStatus(this.id, this.isDone);
}

/// ✅ Tambahan: Reset semua todo
class DeleteAllTodo extends TodoEvent {}
