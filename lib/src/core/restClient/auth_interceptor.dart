import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dw_barbershop/src/core/ui/barbershop_nav_global_key.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants/local_storage_keys.dart';

class AuthInterceptor extends Interceptor {
  @override
  void onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    final RequestOptions(:headers, :extra) = options;

    const authHeaderKey = 'Authorization';

    headers.remove(authHeaderKey);

    if (extra case {'DIO_AUTH_KEY': true}) {
      final sp = await SharedPreferences.getInstance();
      headers.addAll({
        authHeaderKey: 'Bearer ${sp.getString(LocalStorageKeys.accessToken)}'
      });
    }
    handler.next(options);
  }

/*Ciclo de vida da requisicao http, passa pelo onRequest que é a 
pré requisicao, na volta pode ter o onRespose, que é o sucesso, 
e o onError q é uma volta com erro.
onResponse podemos implementar aqui no interceptor para caso a gente 
queira fazer alguma coisa antes de responder pra quem me chamou.

foi feito o onRequest p adicionar o token nas requisiçoes.requisicoes autenticaas

mas e se o token expirar? vai dar error 403 forbidden
podemos fazer um refresh no token, ou pedir pro usuario logar de novo

Vamos pedir p usuario logar de novo!

Para mandar o usuario para a tela de login, nãot emos um context
para fazer o redirect, entao teremos que fazer com base numa globalKey
-global key será feito em outro arquivo com o conceito de singletown
terá uma unica instancia por toda a aplicacao*/
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final DioException(requestOptions: RequestOptions(:extra), :response) = err;

    if (extra case {'DIO_AUTH_KEY': true}) {
      if (response != null && response.statusCode == HttpStatus.forbidden) {
        Navigator.of(BarbershopNavGlobalKey.instance.navKey.currentContext!)
            .pushNamedAndRemoveUntil('/auth/login', (route) => false);
      }
    }
    handler.reject(err);
  }
}
