import 'package:asyncstate/asyncstate.dart';
import 'package:dw_barbershop/src/core/fp/either.dart';
import 'package:dw_barbershop/src/core/providers/application_providers.dart';
import 'package:dw_barbershop/src/features/home/adm/home_adm_state.dart';
import 'package:dw_barbershop/src/model/barbershop_model.dart';
import 'package:dw_barbershop/src/model/user_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'home_adm_vm.g.dart';

@riverpod
class HomeAdmVm extends _$HomeAdmVm {
  @override
  /*implementacao no build. quando carregar o HomeAdmVm
  ele vai buscar os dados dos colaboradores(employees*/
  Future<HomeAdmState> build() async {
    //1 - pegamos o provider
    final repository = ref.read(userRepositoryProvider);
    //2 - pegamos apenas o id da barbearia, nao precisamos do objeto puro inteiro
    final BarbershopModel(id: barbershopId) =
        await ref.read(getMyBarbershopProvider.future);
    /*4 - mas e se o ADM tambem for um colaborador? ele
    vai ter que aparecer na lista TAMBEM...
    entao temos que pegar o getMe tambem*/
    final me = await ref.watch(getMeProvider.future);
    //3 - buscar os employees. pegamos o metodo getEmployees do repository
    //e passamos o barbershopId*/
    final employeesResult = await repository.getEmployees(barbershopId);

    switch (employeesResult) {
      case Success(value: final employeesData):
        /*A lista ja está sendo retornada como UserModelEmployee, por causa do
      getEmployees. então já que o usuario ADM nao é subtipo de Employee,
      teremos que fazer um cast
      -ou, podemos criar essa variavel employees e que recebe UserModel,
      e ai pode entrar adm ou employee*/
        final employees = <UserModel>[];
        //se o me for um ADM cujo workdays e workHours NAO SÃO NULOS,
        if (me case UserModelADM(workDays: _?, workHours: _?)) {
          //então, adiciona ele na lista tambem
          employees.add(me);
        }
        //adicionar todos os employees normalmente
        employees.addAll(employeesData);
        return HomeAdmState(
            status: HomeAdmStateStatus.loaded, employees: employees);

      case Failure():
        return HomeAdmState(status: HomeAdmStateStatus.error, employees: []);
    }
  }

/*chamada de provedor de logout. Poderiamos colocar a logica do logout aqui mesmo,
mas como podemos usar em outros lugares, faremos um provedor

pode ser read pq nao vamos ficar escutando (watch) nossas alteraçoes.*/
  Future<void> logout() => ref.read(logoutProvider.future).asyncLoader();
}
