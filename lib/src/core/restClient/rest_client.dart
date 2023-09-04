import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:dw_barbershop/src/core/restClient/auth_interceptor.dart';

/*é uma classe final, nao pode ser extendida, é do jeito que está

essa classee estará linkada diretamente ao dio, que é nosso https client, 
que faz acesso ao backend, vamos encapsular ele nessa classe */
final class RestClient extends DioForNative {
  //customizar algumas coisas - criar um construtor padrao onde passaremos no super(o nosso dio)
  RestClient()
      : super(BaseOptions(
          baseUrl: 'http://192.168.0.7:8080/',
          connectTimeout: const Duration(seconds: 10),
          receiveTimeout: const Duration(seconds: 60),
        )) {
    interceptors.addAll([
      //pra ele mostrar no log algumas coisas
      LogInterceptor(
        requestBody: true,
        responseBody: true,
      ),
      AuthInterceptor(),
    ]);
  }
//dois metodos auxiliares get(importantes para autenticacao)
  RestClient get auth {
    options.extra['DIO_AUTH_KEY'] = true;
    return this;
  }

  RestClient get unAuth {
    options.extra['DIO_AUTH_KEY'] = false;
    return this;
  }
}

/*-baseUrl - http + o ip da maquina, por que vou estar dentro de um emulador, 
e esse emulador nao vai ter acesso localHost, entao ele vai acessar pela minha rede, 
só assim pra ele acessar o backend

-connectionTimeOut - o tempo que gostariamos de esperar. 
o dio vai esperar pra receber uma resposta. se ele demorar mais de 10 segundos, 
entao ele vai cortar a conexao

-receiveTimOut - tempo de resposta do nosso backend - 
pode demorar no maximo 1minuto para retornar uma requisicao - o maximo que a gente espera, que o dio vai esperarbaseUrl - 
http + o ip da maquina, por que vou estar dentro de um emulador, e esse emulador nao vai ter acesso localHost, 
entao ele vai acessar pela minha rede, só assim pra ele acessar o backend

-connectionTimeOut - o tempo que gostariamos de esperar. o dio vai esperar pra receber uma resposta. 
se ele demorar mais de 10 segundos, entao ele vai cortar a conexao

-receiveTimOut - tempo de resposta do nosso backend - pode demorar no maximo 1minuto para retornar uma requisicao - 
o maximo que a gente espera, que o dio vai esperar*/
