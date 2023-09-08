import 'package:dw_barbershop/src/core/exceptions/repository_exception.dart';
import 'package:dw_barbershop/src/model/barbershop_model.dart';
import 'package:dw_barbershop/src/model/user_model.dart';

import '../../core/fp/either.dart';
import '../../core/fp/nil.dart';

abstract interface class BarbershopRepository {
  //Nil porque no success só queremos registrar e mais nada.
  Future<Either<RepositoryException, Nil>> save(
      /*ao salvar, mandar nome e email 
    e datas e horarios isponieis */
      ({
        String name,
        String email,
        List<String> openingDays,
        List<int> openingHours
      }) data);

/*metodo para recuperar o barbershop, passando como
parametro o usuario corrente */
  Future<Either<RepositoryException, BarbershopModel>> getMyBarbershop(
      UserModel userModel);
}
