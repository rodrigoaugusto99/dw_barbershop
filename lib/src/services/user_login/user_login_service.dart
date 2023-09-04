import '../../core/exceptions/service_exception.dart';
import '../../core/fp/either.dart';
import '../../core/fp/nil.dart';

abstract interface class UserLoginService {
  Future<Either<ServiceException, Nil>> execute(String email, String password);
}

/*vamos para a camada de regra de negocio(segunda camada). quando houer uma regra, 
teremos que criar uma classe especifica pra ela. na grande maioria dos casos, 
a tela faz acesso diretamente ao modelo(repotiry), busca os dados e recebe.
em alguns casos temos regras de negocio(no login por exemplo, temos um caso de 
regra de negoico. pois nao vai apenas fazer o login. vai bater, fzr login, 
recuperar access otken, guardar no storage - tem um PASSO A MAIS, entao nao 
vamos delegar isso pro viewModel(se estamos usando MVVM ou controller(MVC), 
dependendod a arquitetura quee stamos usando. nao faz sentido 
jgoar essa regra pra um bloc por exxemplo

essa regra tem que estar em uma camada de service, service layer,use case, 
que é onde vai ser chamado e pode ser reaproveitado,. no caso, vai ser 
reaproveitado, pois na hora que fizermos o cadastro, nao iremos obrigar 
ele a logar. ele ja vai estar logado. Por isso é importante ter essa camada.

repositories - camada de dados, buscar, tirar, deletar, atgualizar

services - regras de negocio pra fazer antes da acao do repositories */