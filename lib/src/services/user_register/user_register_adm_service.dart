import '../../core/exceptions/service_exception.dart';
import '../../core/fp/either.dart';
import '../../core/fp/nil.dart';

abstract interface class UserRegisterAdmService {
  /*parametros do record igual o do repostory.login */
  Future<Either<ServiceException, Nil>> execute(
      ({String name, String email, String password}) userData);
}
