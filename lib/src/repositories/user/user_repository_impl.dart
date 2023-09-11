// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dw_barbershop/src/core/exceptions/repository_exception.dart';
import 'package:dw_barbershop/src/core/fp/nil.dart';
import 'package:dw_barbershop/src/model/user_model.dart';
import 'package:dw_barbershop/src/repositories/user/user_repository.dart';

import '../../core/exceptions/auth_exception.dart';
import '../../core/fp/either.dart';
import '../../core/restClient/rest_client.dart';

//estrutura pra fazer o login
//nao temos excecoes, temos uma resposta

class UserRepositoryImpl implements UserRepository {
  final RestClient restClient;

  UserRepositoryImpl({
    required this.restClient,
  });

  @override
  Future<Either<AuthException, String>> login(
      String email, String password) async {
    try {
      //acesso à esse serviço
      //restClient.unAuth(requisicao nao autorizada)

      /*atribuir a requisicao ao data do Response, 
      usando destructor(n precisa instanciar a classe toda, 
      só pega o que improta(:data) */
      final Response(:data) = await restClient.unAuth.post('/auth', data: {
        'email': email,
        'password': password,
      });
//quando mando certo os dados, recebo um acess_token( resposta numero 200)
      return Success(data['access_token']);
      //se nao retornar 200, retorna uma DioException
    } on DioException catch (e, s) {
      if (e.response != null) {
        //e.response.statusCode;
        final Response(:statusCode) = e.response!;
        if (statusCode == HttpStatus.forbidden) {
          log('Login ou senha invalidos', error: e, stackTrace: s);
          return Failure(AuthUnauthorizedException());
        }
      }
      //se esse if nao for forbidden ou for nulo, entra como authException
      log('Erro ao realizar login', error: e, stackTrace: s);
      return Failure(AuthError(message: 'erro ao realiar login'));
    }
  }

/*depois de fazer o UserModel com as conversoes, podemos usar o metodo 'me' do
json rest server para atribuir à um UserModel os dados retornados  */
  @override
  Future<Either<RepositoryException, UserModel>> me() async {
    try {
      //na url me, pega os dados do usuario
      final Response(:data) = await restClient.auth.get('/me');
      /*data é os dados em json, que serão atribuidos ao UserModel depois da conversao
      depois da conversao, esse UserModel é atriuido ao userModel, que lá no VM,
      foi lido o provider desse método(getMe)) que é o getMeProvider
      (getMe é o nome do provider. então para instancia-lo lá no vm, 
      usasse o getMeProvider)*/

      /*repare que ele retorna um UserModel.
      como entao há o retorno de UserModelADM ou employee?
      -lá no model, na classe pai,vamos mapear os usuario pela key 'profile'.
      há o fromMap que de acordo com o json['profile'], 
      vai retornar um UserModdel ou outro. */
      return Success(UserModel.fromMap(data));
    } on DioException catch (e, s) {
      log('Erro ao buscar usuario logado', error: e, stackTrace: s);
      return Failure(
        RepositoryException(message: 'Erro ao buscar usuario logado'),
      );
    } on ArgumentError catch (e, s) {
      log('Invalid json', error: e, stackTrace: s);
      return Failure(
        RepositoryException(message: e.message),
      );
    }
  }

  @override
  Future<Either<RepositoryException, Nil>> registerAdmin(
      ({String email, String name, String password}) userData) async {
    try {
      /*unAuth pois registrar um admin é "nao autenticado". 
      permite que seja nao autenticado
      
      INSERT no /users.
      é um post, entao temos que mandar parametros pra nossa requisição
      */
      await restClient.unAuth.post('/users', data: {
        //como acessa  o record? demos um nome p ele - userData
        //parece que ta recebendo como se fosse uma classe, mt bom
        'name': userData.name,
        'email': userData.email,
        'password': userData.password,
        //metodo que registrar adm, então: posso mandar fixo hard coded
        'profile': 'ADM'
      });
      //só registrei, nao quero resposta
      return Success(nil);
    } on DioException catch (e, s) {
      log('Erro ao registrar admin', error: e, stackTrace: s);
      return Failure(
        RepositoryException(message: 'Erro ao registrar admin'),
      );
    }
  }

  @override
  Future<Either<RepositoryException, List<UserModel>>> getEmployees(
      int barbershopId) async {
    try {
      /*busca inicial - 
      fazer a requisicao que recebe uma list(data),  
      pegar /users na query string 'barbershopId' com o 
      valor que veio da variavel*/
      final Response(:List data) = await restClient.auth
          .get('/users', queryParameters: {'barbershop_id': barbershopId});

      /* fazer a busca. no map tratar o UserModelEmployee.
      Nao quero que converta um adm, quero que converta apenas os colaboradores.
      retorna um UserModel mas podemos retornar um UserModelEmployee 
      pois é um UserModel*/
      final employees = data.map((e) => UserModelEmployee.fromMap(e)).toList();
      //caminho feliz, só retornar os employees
      return Success(employees);
      //ou é erro de REQUISIÇÃO
    } on DioException catch (e, s) {
      log('Errp ao buscar colaboradores', error: e, stackTrace: s);
      return Failure(
          RepositoryException(message: 'Erro ao buscar colaboradores'));
      //ou é erro de CONVERSÃO
      /*pois os nossos métodos fromMap VALIDAM nossos json.
          então se tiver invalido, lá vai retorar um ArgumentError*/
    } on ArgumentError catch (e, s) {
      log('Errp ao converter colaboradores(Invalid Json)',
          error: e, stackTrace: s);
      return Failure(RepositoryException(
          message: 'Erro ao buscar colaboradores(invalid Json)'));
    }
  }

  @override
  Future<Either<RepositoryException, Nil>> registerAdmAsEmployee(
      ({
        List<String> workdays,
        List<int> workhours,
      }) userModel) async {
    /*
    final userModelResult = await me();
    final UserModel userModel;
    switch (userModelResult) {
      case Success(value: final user):
        userModel = user;
      case Failure(:var exception):
        return Failure(exception);
    }

    await restClient.auth.put('/users/${userModel.id}');*/
    try {
      final userModelResult = await me();
      final int userId;
      switch (userModelResult) {
        case Success(value: UserModel(:var id)):
          userId = id;
        case Failure(:var exception):
          return Failure(exception);
      }

      await restClient.auth.put('/users/$userId', data: {
        'work_days': userModel.workdays,
        'work_hours': userModel.workhours,
      });

      return Success(nil);
    } on DioException catch (e, s) {
      log('Erro ao inserir administrador como colaborador',
          error: e, stackTrace: s);
      return Failure(RepositoryException(
          message: 'Erro ao inserir administrador como colaborador'));
    }
  }

  @override
  Future<Either<RepositoryException, Nil>> registerEmployee(
      ({
        int barbershopId,
        String email,
        String name,
        String password,
        List<String> workdays,
        List<int> workhours
      }) userModel) async {
    try {
      await restClient.auth.post('/users/', data: {
        'name': userModel.name,
        'email': userModel.email,
        'password': userModel.password,
        'barbershop_id': userModel.barbershopId,
        'profile': 'EMPLOYEE',
        'work_days': userModel.workdays,
        'work_hours': userModel.workhours,
      });

      return Success(nil);
    } on DioException catch (e, s) {
      log('Erro ao inserir administrador como colaborador',
          error: e, stackTrace: s);
      return Failure(RepositoryException(
          message: 'Erro ao inserir administrador como colaborador'));
    }
  }
}
