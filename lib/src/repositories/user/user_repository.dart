import 'package:dw_barbershop/src/core/exceptions/auth_exception.dart';

import '../../core/exceptions/repository_exception.dart';
import '../../core/fp/either.dart';
import '../../core/fp/nil.dart';
import '../../model/user_model.dart';
/*essa camada é onde colcoamos todas as classes que  fazem acesso ao backend, 
vamos sair do sistema para buscar dados, iserir, atualizar, etc

tudo que tem relacao à ida ao backend fica nessa camada que chamamos de repositories */

//CONTRATOS:

abstract interface class UserRepository {
  /*inves de colocar uma Exception generica, criar uma classe que extende a Exception
  para poder diferenciar melhor*/
  Future<Either<AuthException, String>> login(String email, String password);

  Future<Either<RepositoryException, UserModel>> me();

  Future<Either<RepositoryException, Nil>> registerAdmin(
    ({String name, String email, String password}) userData,
  );

  Future<Either<RepositoryException, List<UserModel>>> getEmployees(
      int barbershopId);

  Future<Either<RepositoryException, Nil>> registerAdmAsEmployee(
      ({
        List<String> workdays,
        List<int> workhours,
      }) userModel);

  Future<Either<RepositoryException, Nil>> registerEmployee(
      ({
        int barbershopId,
        String name,
        String email,
        String password,
        List<String> workdays,
        List<int> workhours,
      }) userModel);
}
