// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:dw_barbershop/src/core/exceptions/service_exception.dart';
import 'package:dw_barbershop/src/core/fp/either.dart';
import 'package:dw_barbershop/src/core/fp/nil.dart';
import 'package:dw_barbershop/src/repositories/user/user_repository.dart';
import 'package:dw_barbershop/src/services/user_login/user_login_service.dart';

import 'user_register_adm_service.dart';

class UserRegisterAdmServiceImpl implements UserRegisterAdmService {
  /*para a regra de negocio de logar AO cadastrar,
  precisamos do userRepository e
  o cara que faz o  LOGIN, que já foi feito no LoginService*/
  final UserRepository userRepository;
  final UserLoginService userLoginService;
  UserRegisterAdmServiceImpl({
    required this.userRepository,
    required this.userLoginService,
  });

  @override
  Future<Either<ServiceException, Nil>> execute(
      ({String email, String name, String password}) userData) async {
    /*o que queremos nessa regra de negocio é o login
        do usuario adm logo após cadastrar.
        Para isso, temos que DEPOIS de fazer o registro(registerAdmin),
        fazer o execute do LoginService logo em seguida em caso de success.
        -userRepository para registrar
        -userLoginService para logar */

    final registerResult = await userRepository.registerAdmin(userData);

    switch (registerResult) {
      case Success():
        return userLoginService.execute(userData.email, userData.password);
      case Failure(:final exception):
        /*trocar a exceção. a exceção que pode vir no registerResult é 
      RepositoryExxception(pois chama userRepository.registerAdmin). 
      Mas precisamos retornar ServiceException(ta la no either) */
        return Failure(ServiceException(message: exception.message));
    }
  }
}
