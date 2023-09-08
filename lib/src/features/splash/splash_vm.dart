import 'package:dw_barbershop/src/core/constants/local_storage_keys.dart';
import 'package:dw_barbershop/src/core/providers/application_providers.dart';
import 'package:dw_barbershop/src/model/user_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'splash_vm.g.dart';

/*classe de estado nao vai guardar nada, 
so vai ser enumerador mesmo p dizer ql tela está*/
enum SplashState {
  initial,
  login,
  loggedADM,
  loggedEmployee,
  error;
}

@riverpod
class SplashVm extends _$SplashVm {
  @override
  Future<SplashState> build() async {
    //checar se no sharedPreferences se já há token
    final sp = await SharedPreferences.getInstance();

//se tiver,
    if (sp.containsKey(LocalStorageKeys.accessToken)) {
      ref.invalidate(getMeProvider);
      ref.invalidate(getMyBarbershopProvider);

      try {
        /*futuro, pois quero dar um await 
        quero ja pegar o cara, nao quero que ele
        fique esperando ele passar nas entranhas 
        do riverpod. me da um futuro pq eu preciso
        usar agora, nao quero yum asyncvalue*/
        final userModel = await ref.watch(getMeProvider.future);

//depoois e pegar o usuario, manda pra tela
        return switch (userModel) {
          UserModelADM() => SplashState.loggedADM,
          UserModelEmployee() => SplashState.loggedEmployee
        };
      } catch (e) {
        /*se nao comseguiu pegar usuario logado, se der uma exceçao,
        tenho que capturar ela. n importa erro, eu mando pro SplashLogin*/
        return SplashState.login;
      }
    }
    return SplashState.login;
  }
}
