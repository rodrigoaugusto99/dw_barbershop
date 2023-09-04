import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:dw_barbershop/src/core/exceptions/repository_exception.dart';

import 'package:dw_barbershop/src/core/fp/either.dart';
import 'package:dw_barbershop/src/core/fp/nil.dart';

import 'package:dw_barbershop/src/model/barbershop_model.dart';
import 'package:dw_barbershop/src/model/user_model.dart';

import '../../core/restClient/rest_client.dart';
import './barbershop_repository.dart';

class BarbershopRepositoryImpl implements BarbershopRepository {
  final RestClient restClient;
  BarbershopRepositoryImpl({
    required this.restClient,
  });

  /*mesma ideia que foi usado para a busca do usuario, porem a busca 
  do barbershop referente ao usuario, são feitas de formas diferentes 
  nos casos de Adm e Employee.
  
  se for employee, a busca é pelo barbershopId
  
  porem o adm não tem um barbershopId, pois ele não é
  associado à uma barberia, e sim o contrário.
  Até porque, de acordo com o fluxo de telas, a crioação do usuario vem 
  depois do registro a barbearia.*/
  @override
  Future<Either<RepositoryException, BarbershopModel>> getMyBarbershop(
      UserModel userModel) async {
    switch (userModel) {
      //auto-promoçãoo de tipo
      case UserModelADM():
        /*se for adm, busca o barbershop atraves do filtro
      o user_id do Barbershop tem que ser igual ao '#userAuthRef',
      que é um coringa que no json rest server, vai ser substituido
      pelo id do usuario logado*/

        /*se buscar pelo barbershopId, vem um objeto normal, apenas a 
      barbearia que corresponde àquele barbershopId do usuario corrente.
      
      porem, se pesquisar por query, vem uma lista. então tem que pegar o first.
      
      Como sabemos que vai retornar uma lista, entao ja podemos converter o retorno
      do response para List*/
        final Response(data: List(first: data)) = await restClient.auth.get(
          '/barbershop',
          queryParameters: {'user_id': '#userAuthRef'},
        );
        //assim como no UserModel, retorna a conversao
        return Success(BarbershopModel.fromMap(data));
      case UserModelEmployee():
        //no employee, basta buscar pelo barbershopId do userModel
        final Response(:data) = await restClient.auth.get(
          '/barbershop/${userModel.barbershopId}',
        );
        return Success(BarbershopModel.fromMap(data));
    }
  }

  @override
  Future<Either<RepositoryException, Nil>> save(
      ({
        String email,
        String name,
        List<String> openingDays,
        List<int> openingHours,
      }) data) async {
    try {
      await restClient.auth.post('/barbershop', data: {
        'user_id': '#userAuthRef',
        'name': data.name,
        'email': data.email,
        'opening_days': data.openingDays,
        'opening_hours': data.openingHours,
      });
      return Success(nil);
    } on DioException catch (e, s) {
      log('Erro ao registrar barbearia', error: e, stackTrace: s);
      return Failure(
          RepositoryException(message: 'Erro ao registrar barbearia'));
    }
  }
}
