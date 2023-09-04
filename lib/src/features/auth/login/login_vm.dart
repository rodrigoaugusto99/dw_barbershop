import 'package:asyncstate/asyncstate.dart';
import 'package:dw_barbershop/src/core/exceptions/service_exception.dart';
import 'package:dw_barbershop/src/core/fp/either.dart';
import 'package:dw_barbershop/src/core/providers/application_providers.dart';
import 'package:dw_barbershop/src/model/user_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'login_state.dart';

part 'login_vm.g.dart';

@riverpod
/*é um async Notifier do proprio riverpod */
//extentando a classe que o build runner criou com o riverpod
class LoginVM extends _$LoginVM {
  @override

  //obrigatorio metodo buld = qual o tipo q vamos retornar
  LoginState build() => LoginState.initial();

  Future<void> login(String email, String password) async {
    //loader do package q pode ser controlado manualmente
    final loaderHandler = AsyncLoaderHandler()..start();
    /*depois de chamar o metodo login da VM,aqui temos que 
    chamar o metodo execute do Service. Pra isso vamos aqui TAMBEM 
    fzr uma instancia do provedor do UserLoginService*/
    final loginService = ref.watch(userLoginServiceProvider);

    final result = await loginService.execute(email, password);
/*metodo execute retorna um either, entao temos que tratar os success e failure */
    switch (result) {
      /*se a requisição retornar success, instanciamos um usuario e
      e com o provider do Me, atribuimos esse usuario à um adm ou employee*/
      case Success():
        //invalidando os caches p evitare login c usuario errado
        ref.invalidate(getMeProvider);
        ref.invalidate(getMyBarbershopProvider);
        //buscar dados do usuario logado
        //fazer uma analise para qual o tipo de login

        /*como saber se quem logou é adm ou employee?
        APENAS TENHO O TOKEN QUE VEIO DO SERVICE! 
        então vamos usar o metodo "me" do json rest server
        pois ele retorna todos os dados do usuario
        -Para isso, vamos criar o UserModel, que é exatamente
        o que o backend retorna em formato json.
        -lá no json rest server, quando chega no '/me', o backend
        retorna os dados do usuario.
        -vamos no repositorio criar o metodo "me" que chama esse
        "me" do restCLient, e se for success, vamos retornar o UserModel.
        */
        final userModel = await ref.read(getMeProvider.future);
        switch (userModel) {
          case UserModelADM():
            //alterando o estado de acordo com o usuario retornado
            state = state.copyWith(status: LoginStateStatus.admLogin);
          case UserModelEmployee():
            state = state.copyWith(status: LoginStateStatus.employeeLogin);
        }
        break;
      case Failure(exception: ServiceException(:final message)):
        state = state.copyWith(
          status: LoginStateStatus.error,
          errorMessage: () => message,
        );
    }
    //ao acabar a requisicao toda, fechar o loader
    loaderHandler.close();
  }
}
