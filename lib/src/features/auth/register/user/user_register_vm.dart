import 'package:asyncstate/asyncstate.dart';
import 'package:dw_barbershop/src/core/fp/either.dart';
import 'package:dw_barbershop/src/core/providers/application_providers.dart';
import 'package:dw_barbershop/src/features/auth/register/user/user_register_providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part '../user_register_vm.g.dart';

/*o state vai ser aqui no VM mesmo.  

o VM precisa de um metodo build pois é @riverpod, que é um estado.
podemos criar aqui msm pq esse estado em especifico vai ser apenas
um numerado, nao n precisa de dados, de parametro ou lista ou qlqr coisa.
só precisa notificar a tela se foi um registro de sucesso ou deu erro.

diferentemente o login_state, onde alem do enumeraor, tbm teve 
status e parametro, uma classe state.
*/

enum UserRegisterStateStatus {
  initial,
  success,
  error,
}

@riverpod
class UserRegisterVm extends _$UserRegisterVm {
  @override

  //metodo build pra começar
  UserRegisterStateStatus build() => UserRegisterStateStatus.initial;
  /*view model pronta! agora precisamos conectar na pagina
  como? COnsumerStatefulWiget no register_page, pois precisamos
  acessar o riverpod(estados, ref etc)
  
  então lá no page, vamos acessar o userRegisterVmProvider,
  que é uma instancia desse UserRegisterVM atual*/

/*lá da page vamos chamar a VM! que vai chamar o service! */
  Future<void> register({
    required String name,
    required String email,
    required String password,
  }) async {
    //instancia o provider do register adm service
    final userRegisterAdmService = ref.watch(userRegisterAdmServiceProvider);

//vamos jogar oq no execute? vamos criar o dto
/*dto como se fosse uma classe mas sem precisar criar 
a classe com os atributos etc, esse é o bom do records */
    final userData = (
      name: name,
      email: email,
      password: password,
    );
    //podemos usar o execute do register adm service
    //chama asyncLoader pra esperar a requisicao ate o final
    final registerResult =
        await userRegisterAdmService.execute(userData).asyncLoader();
    switch (registerResult) {
      case Success():
        ref.invalidate(getMeProvider);
        state = UserRegisterStateStatus.success;
      case Failure():
        state = UserRegisterStateStatus.error;
    }
  }
}
