import 'package:dw_barbershop/src/core/fp/either.dart';
import 'package:dw_barbershop/src/core/providers/application_providers.dart';
import 'package:dw_barbershop/src/features/auth/register/barbershop/barbershop_register_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'barbershop_register_vm.g.dart';

@riverpod
class BarbershopRegisterVm extends _$BarbershopRegisterVm {
  //inicialmente a tela só carrega sem fazer nada
  @override
  BarbershopRegisterState build() => BarbershopRegisterState.initial();

//
  void addOrRemoveOpenDay(String weekDay) {
    //extraí do estado
    final openingDays = state.openingDays;

//adicionar ou remover dependendo de ja estar selecionado
    if (openingDays.contains(weekDay)) {
      openingDays.remove(weekDay);
    } else {
      openingDays.add(weekDay);
    }

//atualizando o estado, alterando somente o openays
    state = state.copyWith(openingDays: openingDays);
  }

  void addOrRemoveOpenHour(int hour) {
    final openingHours = state.openingHours;

    if (openingHours.contains(hour)) {
      openingHours.remove(hour);
    } else {
      openingHours.add(hour);
    }

    state = state.copyWith(openingHours: openingHours);
  }

/*registrar os elementos selecionados naquele momento do estado

-buscar as variaveis de instancia do estado, para colocar no dto
para mandar pro save*/
  Future<void> register(String name, String email) async {
    final repository = ref.watch(barbershopRepositoryProvider);

//conceito de destructino para pegar essas variaveis do estado
    final BarbershopRegisterState(:openingDays, :openingHours) = state;

    final dto = (
      name: name,
      email: email,
      openingDays: openingDays,
      openingHours: openingHours
    );
//dto tem que estar identico ao que nossa requisição precisa.
    final registerResult = await repository.save(dto);
    switch (registerResult) {
      //atualizando o estado
      case Success():
        ref.invalidate(getMyBarbershopProvider);
        state = state.copyWith(status: BarbershopRegisterStateStatus.success);
        break;
      case Failure():
        state = state.copyWith(status: BarbershopRegisterStateStatus.error);
    }
  }
}
