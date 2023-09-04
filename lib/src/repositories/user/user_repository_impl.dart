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

  @override
  Future<Either<RepositoryException, UserModel>> me() async {
    try {
      final Response(:data) = await restClient.auth.get('/me');
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
      await restClient.unAuth.post('/users', data: {
        'name': userData.name,
        'email': userData.email,
        'password': userData.password,
        'profile': 'ADM'
      });
      return Success(nil);
    } on DioException catch (e, s) {
      log('Erro ao registrar usuario', error: e, stackTrace: s);
      return Failure(
        RepositoryException(message: 'Erro ao registrar admin'),
      );
    }
  }

  @override
  Future<Either<RepositoryException, List<UserModel>>> getEmployees(
      int barbershopId) async {
    try {
      final Response(:List data) = await restClient.auth
          .get('/users', queryParameters: {'barbershop_id': barbershopId});

      final employees = data.map((e) => UserModelEmployee.fromMap(e)).toList();
      return Success(employees);
    } on DioException catch (e, s) {
      log('Errp ao buscar colaboradores', error: e, stackTrace: s);
      return Failure(
          RepositoryException(message: 'Erro ao buscar colaboradores'));
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
