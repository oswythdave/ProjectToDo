import 'package:bloc/bloc.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:praktikum/application/login/bloc/login_event.dart';
import 'package:praktikum/application/login/bloc/login_state.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import '../../../config/config.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc() : super(LoginInitial()) {
    on<LoginRequest>(_onLoginRequest);
    on<LogoutRequest>(_onLogputRequest);
  }

  Future<void> _onLoginRequest(
    LoginRequest event,
    Emitter<LoginState> emit,
  ) async {
    emit(LoginLoading());
    print("awal");
    try {
      final response = await http.post(
        Uri.parse('https://be-todos.vercel.app/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': event.email, 'password': event.password}),
      );
      print("hampur");
      if (response.statusCode == 200) {
        print("oke");
        final data = jsonDecode(response.body);
        final accessToken = data['token'];

        print("dikit lagi");

        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', accessToken);
        print("Login berhasil, mengirim status");
        emit(LoginSuccess(message: "Login berhasil"));
      } else {
        final errorData =
            response.body.isNotEmpty
                ? jsonDecode(response.body)
                : {'error': 'Tidak ada detail error dari server'};
        emit(LoginFailure(error: errorData['message'] ?? 'Login gagal'));
      }
    } catch (e) {
      print("error");
      print('Exception caught: $e');

      emit(LoginFailure(error: 'Terjadi kesalahan, coba lagi.'));
    }
  }

  Future<void> _onLogputRequest(
    LogoutRequest event,
    Emitter<LoginState> emit,
  ) async {
    emit(LogoutLoading());
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();

      emit(LoginSuccess(message: 'Logout berhasil'));
    } catch (e) {
      emit(LogoutFailure(error: 'Logout gagal, coba lagi.'));
    }
  }
}
