import 'package:flutter_bloc/flutter_bloc.dart';
import 'todo_event.dart';
import 'todo_state.dart';
import '../../model/todo_model.dart';

class TodoBloc extends Bloc<TodoEvent, TodoState> {
  TodoBloc() : super(const TodoState(todos: [])) {
    on<AddTodo>((event, emit) {
      final updatedTodos = List<Todo>.from(state.todos)..add(event.todo);
      emit(TodoState(todos: updatedTodos));
    });

    on<UpdateTodo>((event, emit) {
      final updatedTodos =
          state.todos.map((todo) {
            return todo.id == event.todo.id ? event.todo : todo;
          }).toList();
      emit(TodoState(todos: updatedTodos));
    });

    on<DeleteTodo>((event, emit) {
      final updatedTodos =
          state.todos.where((todo) => todo.id != event.id).toList();
      emit(TodoState(todos: updatedTodos));
    });

    on<ToggleTodoStatus>((event, emit) {
      final updatedTodos =
          state.todos.map((todo) {
            if (todo.id == event.id) {
              return todo.copyWith(isDone: event.isDone);
            }
            return todo;
          }).toList();
      emit(TodoState(todos: updatedTodos));
    });
  }
}
