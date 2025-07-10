import 'package:equatable/equatable.dart';

abstract class LoginEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class LoginRequest extends LoginEvent {
  final String email;
  final String password;

  LoginRequest({required this.email, required this.password});

  @override
  List<Object> get props => [email, password];
}

class LogoutRequest extends LoginEvent {
  LogoutRequest();

  @override
  List<Object> get props => [];
}
