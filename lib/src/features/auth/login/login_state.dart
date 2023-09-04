// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

//status que a tela vai passar
enum LoginStateStatus {
  initial,
  error,
  admLogin,
  employeeLogin,
}

//criando o estado
class LoginState {
  final LoginStateStatus status;
  final String? errorMessage;

//construtor nomeado
//contrutor padrão é aquele em que o valor é initial.
  LoginState.initial() : this(status: LoginStateStatus.initial);

  LoginState({
    required this.status,
    this.errorMessage,
  });

//metodo copyWith que é usado para NOTIFICAR e ALTERAR o estado e retorna-lo de forma modificada
  LoginState copyWith({
    LoginStateStatus? status,
    ValueGetter<String?>? errorMessage,
  }) {
    return LoginState(
      status: status ?? this.status,
      errorMessage: errorMessage != null ? errorMessage() : this.errorMessage,
    );
  }
}
