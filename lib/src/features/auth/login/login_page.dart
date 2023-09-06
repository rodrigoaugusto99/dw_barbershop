import 'package:dw_barbershop/src/core/ui/constants.dart';
import 'package:dw_barbershop/src/core/ui/helpers/form_helper.dart';
import 'package:dw_barbershop/src/core/ui/helpers/messages.dart';
import 'package:dw_barbershop/src/features/auth/login/login_state.dart';
import 'package:dw_barbershop/src/features/auth/login/login_vm.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:validatorless/validatorless.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final formKey = GlobalKey<FormState>();
  final emailEC = TextEditingController();
  final passwordEC = TextEditingController();

  @override
  void dispose() {
    emailEC.dispose();
    passwordEC.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    /*precisamos usar Consumer para ter acesso ao wiget ref
    que é uma referencia pra gente buscar as coisas do riverpod. */

//dessa forma, retorna o estado
    //final loginVM = ref.watch(loginVMProvider);

    //dentro do metodo build, pois vamos ouir as alteracoes desse ref.watch
    //e desse forma, retorna o acesso à classe LoginVM, onde podemos usar os metodos
    final LoginVM(:login) = ref.watch(loginVMProvider.notifier);
    /*depois de fazer essa instancia do view model(VM) com o metodo login,
    podemos analisar qual é o estado retornado pelo ref.watch(state do VM)
    e fazer as ações necessárias
    */

    /*as alteraçoes do estados que são retornadas pelo vm,
    descobertas na vm de acordo com retorno do Service, que depende
    do retorno do repository...
    serão todas ouvidas a todo instante,  */

//olhando o loginVMProvider, que é o estado. queremos ficar olhando esse provider
//esse metodo listen alem de precisar do estado, tbm precisa da varivel state
//vamos analisar o que vai vir da variavel state.
    ref.listen(loginVMProvider, (_, state) {
      switch (state) {
        case LoginState(status: LoginStateStatus.initial):
          break;
        case LoginState(status: LoginStateStatus.error, :final errorMessage?):
          //Messages, alem da mensagem do proprio validatorless em cada campo,
          //tbm será exibido top snack bar do package.
          Messages.showError(errorMessage, context);
        case LoginState(status: LoginStateStatus.error):
          Messages.showError('Erro ao realizar login', context);
        case LoginState(status: LoginStateStatus.admLogin):
          Navigator.of(context)
              .pushNamedAndRemoveUntil('/home/adm', (route) => false);
          break;
        case LoginState(status: LoginStateStatus.employeeLogin):
          Navigator.of(context)
              .pushNamedAndRemoveUntil('/home/employee', (route) => false);
          break;
      }
    });
    return Scaffold(
      backgroundColor: Colors.black,
      body: Form(
        key: formKey,
        child: DecoratedBox(
          decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage(
                  ImageConstants.backgroundChair,
                ),
                opacity: 0.2,
                fit: BoxFit.cover),
          ),
          child: Padding(
            padding: const EdgeInsets.all(30.0),
            child: CustomScrollView(
              slivers: [
                //o cara que ocupa a tela como um todo
                SliverFillRemaining(
                  //nao tem body, pra ele poder esticar a tela
                  //customScroll + sliver é ajuda mt
                  hasScrollBody: false,
                  //os filhos flutuam na tela, entao podemos mexe-los com align
                  child: Stack(
                    //alinhar todo o resto no centro
                    alignment: Alignment.center,
                    children: [
                      Column(
                        //alinhar todos os filhos da column no centro, pois tudo começa la em cima
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(ImageConstants.imageLogo),
                          const SizedBox(
                            height: 24,
                          ),
                          TextFormField(
                            controller: emailEC,
                            onTapOutside: (_) => unfocus(context),
                            validator: Validatorless.multiple([
                              Validatorless.required('Email obrigatorio'),
                              Validatorless.email('Email invalido'),
                            ]),
                            decoration: const InputDecoration(
                                label: Text('Email'),
                                hintText: 'E-mail',
                                hintStyle: TextStyle(color: Colors.black),
                                /*para tirar o label ao focar no textfield, pois quando foca, 
                                ele saí ali de cima do hintText e fica um pouco mais em cima */
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.never,
                                labelStyle: TextStyle(color: Colors.black)),
                          ),
                          const SizedBox(
                            height: 24,
                          ),
                          TextFormField(
                            controller: passwordEC,
                            onTapOutside: (_) => unfocus(context),
                            validator: Validatorless.multiple([
                              Validatorless.required('Senha obrigatorio'),
                              Validatorless.min(6,
                                  'Senha deve conter pelo menos 6 caracteres'),
                            ]),
                            obscureText: true,
                            decoration: const InputDecoration(
                                label: Text('Senha'),
                                hintText: 'Senha',
                                hintStyle: TextStyle(color: Colors.black),
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.never,
                                labelStyle: TextStyle(color: Colors.black)),
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          const Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'Esqueceu a senha?',
                              style: TextStyle(
                                color: ColorsConstants.brown,
                                fontSize: 12,
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 24,
                          ),
                          ElevatedButton(
                            onPressed: () {
                              //ações com a validação
                              switch (formKey.currentState?.validate()) {
                                case (false || null):
                                  //mandando msg pro usuario
                                  Messages.showError(
                                      'Campos invalidos!', context);
                                  break;
                                case true:
                                  login(emailEC.text, passwordEC.text);
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              //height = 56, width = double.infinity
                              minimumSize: const Size.fromHeight(56),
                              //minimumSize = Size(double.infinity, 56)(mesma coisa)
                            ),
                            child: const Text('accessar'),
                          ),
                        ],
                      ),
                      Align(
                        alignment: Alignment.bottomCenter,
                        /*rota para a tela de registrar user 
                        
                        inkwell pq é um widget que trás o poder do click
                        sem nenhuma formatação, nao muda nada no texto,
                        e o front ja ta pronto. se colocar tipo textbutton, 
                        ja vai vir uns padding padrao doido*/
                        child: InkWell(
                          onTap: () {
                            Navigator.of(context)
                                .pushNamed('/auth/register/user');
                          },
                          child: const Text(
                            'Criar conta',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
