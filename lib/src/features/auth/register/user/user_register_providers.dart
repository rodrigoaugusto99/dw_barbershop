import 'package:dw_barbershop/src/core/providers/application_providers.dart';
import 'package:dw_barbershop/src/services/user_register/user_register_adm_service.dart';
import 'package:dw_barbershop/src/services/user_register/user_register_adm_service_impl.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part '../user_register_providers.g.dart';

/*Colocamos os providers do registerAdm aqui, pois
nao precisaremos usar ele em outro lugar  do app */

@riverpod
UserRegisterAdmService userRegisterAdmService(UserRegisterAdmServiceRef ref) =>
    UserRegisterAdmServiceImpl(
        userRepository: ref.watch(userRepositoryProvider),
        userLoginService: ref.watch(userLoginServiceProvider));
