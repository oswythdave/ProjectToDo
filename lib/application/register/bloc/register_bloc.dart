import 'package:bloc/bloc.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:praktikum/application/register/bloc/register_event.dart';
import 'package:praktikum/application/register/bloc/register_state.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  RegisterBloc() : super(RegisterInitial()) {
    on<RegisterRequest>(_onRegisterRequest);
  }

  Future<void> _onRegisterRequest(
    RegisterRequest event,
    Emitter<RegisterState> emit,
  ) async {
    emit(RegisterLoading());
    try {
      final response = await http.post(
        Uri.parse('https://be-todos.vercel.app/register'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'name': event.name,
          'email': event.email,
          'password': event.password,
        }),
      );

      if (response.statusCode == 201) {
        final data = jsonDecode(response.body);
        final message = data['message'];

        emit(RegisterSuccess(event.name));
      } else if (response.statusCode == 400) {
        final errorData = jsonDecode(response.body);

        emit(
          RegisterFailure(
            error: errorData['errors']['password'] ?? 'Validasi gagal',
          ),
        );
      } else {
        final errorData =
            response.body.isNotEmpty
                ? jsonDecode(response.body)
                : {'error': 'Tidak ada detail error dari server'};
        emit(RegisterFailure(error: errorData['message'] ?? 'Register gagal'));
      }
    } catch (e) {
      print(e);
      emit(RegisterFailure(error: 'Terjadi kesalahan, coba lagi.'));
    }
  }
}
