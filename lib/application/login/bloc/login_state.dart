import 'package:equatable/equatable.dart';

abstract class LoginState extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoginInitial extends LoginState {}

class LoginLoading extends LoginState {}

class LoginSuccess extends LoginState {
  final String? message;

  LoginSuccess({required this.message});

  @override
  List<Object?> get props => [message];
}

class LoginFailure extends LoginState {
  final String error;

  LoginFailure({required this.error});

  @override
  List<Object> get props => [error];
}

class LogoutLoading extends LoginState {}

class LogoutSuccess extends LoginState {
  final String? message;

  LogoutSuccess({required this.message});

  @override
  List<Object?> get props => [message];
}

class LogoutFailure extends LoginState {
  final String error;

  LogoutFailure({required this.error});

  @override
  List<Object> get props => [error];
}
