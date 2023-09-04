// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:dw_barbershop/src/core/constants/local_storage_keys.dart';
import 'package:dw_barbershop/src/core/exceptions/auth_exception.dart';
import 'package:dw_barbershop/src/core/exceptions/service_exception.dart';
import 'package:dw_barbershop/src/core/fp/either.dart';
import 'package:dw_barbershop/src/core/fp/nil.dart';
import 'package:dw_barbershop/src/repositories/user/user_repository.dart';
import 'package:dw_barbershop/src/services/user_login/user_login_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

//regra de negocio
/*o vm nao vai chamar direto o repositorio, que é dretamente ligada ao backend.
primeiro,vai chamar o service, que esse ai sim chama o repositorio para poder
tratar os retornos.*/

class UserLoginServiceImpl implements UserLoginService {
  final UserRepository userRepository;
  UserLoginServiceImpl({
    required this.userRepository,
  });

  @override
  Future<Either<ServiceException, Nil>> execute(
      String email, String password) async {
    final loginResult = await userRepository.login(email, password);
    /*-criamos uma variavel loginResult e chamamos o UserRepository.login, passando os dados
-nao sobe excecao, entao nao precisa de try-catdch, pois já está la no repositorio.
-como o eithe é uma classe selada, usando o switch, 
a gente pode fazer as checagens exaustivamente, temos 
que checar todas as possibilidades(Failure e Success)

-usar esse switch case ajuda pois ele informa quando está faltando um caso.

-dessa forma, temos uma seguranca de que tudo que deveria ser validado, será validado. */

    switch (loginResult) {
      case Success(value: final accessToken):
        /*no caso de sucesso, recuperamos o token e guarda0lo dentro do local storage, 
      pois mais pra frente, iremos criar um interceptor e adicionar esse 
      token automaticamente nas nossas requisicoes autenticadas. */
        final sp = await SharedPreferences.getInstance();
        sp.setString(LocalStorageKeys.accessToken, accessToken);
        return Success(nil);
      case Failure(:final exception):
        switch (exception) {
          case AuthError():
            return Failure(ServiceException(message: 'Erro ao realizar login'));
          case AuthUnauthorizedException():
            return Failure(
                ServiceException(message: 'Login ou senha invalidos'));
        }
    }
  }
}
