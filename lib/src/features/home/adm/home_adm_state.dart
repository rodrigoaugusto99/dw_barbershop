import 'package:dw_barbershop/src/model/user_model.dart';

/*logo no build da aplicacao a gente ja vai buscar os dados.
nao tem estado inicial. o estado inicial ja eh a lista carregada */
enum HomeAdmStateStatus { loaded, error }

class HomeAdmState {
  final HomeAdmStateStatus status;
  final List<UserModel> employees;

  HomeAdmState({
    required this.status,
    required this.employees,
  });

  HomeAdmState copyWith(
      {HomeAdmStateStatus? status, List<UserModel>? employees}) {
    return HomeAdmState(
      status: status ?? this.status,
      employees: employees ?? this.employees,
    );
  }
}
/*estado retorna um status E uma lista. */