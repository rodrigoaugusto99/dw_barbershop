// ignore_for_file: public_member_api_docs, sort_constructors_first

/*sealed class pois se for um adm que nao trabalha, weekDays e weekHours nao irao existir,
entao pra evitar colocar o ? para possibilitar nulo, vamos usar a orientacao a objetos 
com o sealedd class */
sealed class UserModel {
  final int id;
  final String name;
  final String email;
  final String? avatar;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    this.avatar,
  });

//mapeando os usuarios pelo key 'profile' do banco
  factory UserModel.fromMap(Map<String, dynamic> json) {
    return switch (json['profile']) {
      'ADM' => UserModelADM.fromMap(json),
      'EMPLOYEE' => UserModelEmployee.fromMap(json),
      _ => throw ArgumentError('User profile not found')
    };
  }
}

class UserModelADM extends UserModel {
  //nulo pois o adm pode nao trabalhar
  final List<String>? workDays;
  final List<int>? workHours;
  UserModelADM({
    this.workDays,
    this.workHours,
    required super.id,
    required super.name,
    required super.email,
    super.avatar,
  });

  /*cada UserModel precisa ter seu fromMap para converter os dados do json em objeto.
  aqui, com o switch, podemos ao fazer a conversao, garantir os tipos que serão atribuidos às variaveis do objeto.
  sendo assim, se algum tipo o json nao bater com o objeto, 
  entra no case coringa, que é como se fosse um else, e retorna um Argument error. */

  factory UserModelADM.fromMap(Map<String, dynamic> json) {
    return switch (json) {
      {
        'id': final int id,
        'name': final String name,
        'email': final String email,
        /*nao podemos colocar avatar, work days e workHours pq eles podem ser nulos,
        entao se colocar aqui no pattern matching e forem nulos, pode dar erro.
        então, tem que colocar direto lá na atribuição embaixo. */
      } =>
        UserModelADM(
          id: id,
          name: name,
          email: email,
          avatar: json['avatar'],
          workDays: json['work_days']?.cast<String>(),
          workHours: json['work_hours']?.cast<int>(),
        ),
      //se nao atendeu ao pattern matching...
      _ => throw ArgumentError('Invalid json'),
    };
  }
}

class UserModelEmployee extends UserModel {
  //obrigatorio pois um employee necessariamente tem workdays e workhours
  final int barbershopId;
  final List<String> workDays;
  final List<int> workHours;
  UserModelEmployee({
    required this.barbershopId,
    required this.workDays,
    required this.workHours,
    required super.id,
    required super.name,
    required super.email,
    super.avatar,
  });

  factory UserModelEmployee.fromMap(Map<String, dynamic> json) {
    return switch (json) {
      {
        'id': final int id,
        'name': final String name,
        'email': final String email,
        //esses abaixo podem estar aqui diretos pois sao obrigatorios de virem.
        'barbershop_id': final int barbershopId,
        'work_days': final List workDays,
        'work_hours': final List workHours,
      } =>
        UserModelEmployee(
          id: id,
          name: name,
          email: email,
          avatar: json['avatar'],
          barbershopId: barbershopId,
          workDays: workDays.cast<String>(),
          workHours: workHours.cast<int>(),
        ),
      _ => throw ArgumentError('Invalid json'),
    };
  }
}
