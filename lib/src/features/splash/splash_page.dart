import 'dart:developer';

import 'package:dw_barbershop/src/core/ui/constants.dart';
import 'package:dw_barbershop/src/core/ui/helpers/messages.dart';
import 'package:dw_barbershop/src/features/auth/login/login_page.dart';
import 'package:dw_barbershop/src/features/splash/splash_vm.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SplashPage extends ConsumerStatefulWidget {
  const SplashPage({super.key});

  @override
  ConsumerState<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends ConsumerState<SplashPage> {
  //duas variaveis de estado para as animaçoes
  var _scale = 10.0;
  var _animationOpacityLogo = 0.0;

/*getter inves de variaveis diretas, pois nao representam valores estaticos,
 mas sim um valor que dependem de outras variaves, formulas ou logicas*/
  double get _logoAnimationWidth => 100 * _scale;
  double get _logoAnimationHeight => 120 * _scale;

  @override
  void initState() {
    /*para agendar uma função que será executada após o primeiro quadro (frame) de renderização ter sido concluído.
     garantir que as atualizações de estado ocorram após o primeiro quadro de renderização ter sido concluído. 
     Isso é importante em casos em que você deseja realizar ações que dependem da interface do usuário ter sido 
     completamente construída, como animações, ajustes de layout 
     ou outras operações que afetam a aparência ou o comportamento do widget.*/
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        //animação começa com 0.0 e vai pra 1.0 (aparecendo)
        _animationOpacityLogo = 1.0;
        //escala da imagem começa 100 e 120 vezes maior, e vai pra 1.0 (diminuindo)
        _scale = 1.0;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(splashVmProvider, (_, state) {
      //o metodo build é assincrono(Future), então tem essas funcoes when
      /*escutar as alteracoes do estao, se der error - mensagens + loginPage
      se der success(data) - redirects */
      state.whenOrNull(error: (error, stackTrace) {
        log('Erro ao validar login', error: error, stackTrace: stackTrace);
        Messages.showError('Erro ao validar o login', context);
        Navigator.of(context)
            .pushNamedAndRemoveUntil('/auth/login', (route) => false);
      }, data: (data) {
        switch (data) {
          case SplashState.loggedADM:
            Navigator.of(context)
                .pushNamedAndRemoveUntil('/home/adm', (route) => false);
          case SplashState.loggedEmployee:
            Navigator.of(context)
                .pushNamedAndRemoveUntil('/home/employee', (route) => false);
          case _:
            Navigator.of(context)
                .pushNamedAndRemoveUntil('/auth/login', (route) => false);
        }
      });
    });

    //1 ------------imagem de fundo--------------
    return Scaffold(
      backgroundColor: Colors.black,
      body: DecoratedBox(
        decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage(
                ImageConstants.backgroundChair,
              ),
              opacity: 0.2,
              fit: BoxFit.cover),
        ),
        child: Center(
          //2 --------animando a opacidade da logo--------
          child: AnimatedOpacity(
            opacity: _animationOpacityLogo,
            curve: Curves.easeIn,
            duration: const Duration(seconds: 1),
            //quando a animação terminar, fazer o redirect por aqui
            //pushNamed fica feio. com esse PageRouteBulder, dá pra decorar a transicao de telas com fade.
            onEnd: () {
              Navigator.of(context).pushAndRemoveUntil(
                PageRouteBuilder(
                  settings: const RouteSettings(name: '/auth/login'),
                  pageBuilder: (
                    context,
                    animation,
                    secondaryAnimation,
                  ) {
                    return const LoginPage();
                  },
                  transitionsBuilder: (_, animation, __, child) {
                    return FadeTransition(opacity: animation, child: child);
                  },
                ),
                (route) => false,
              );
            },
            //2 ------------animando a logo--------------
            //animatedContainer - qualquer alteraçao no container, ele vai animar por x segundos
            child: AnimatedContainer(
              width: _logoAnimationWidth,
              height: _logoAnimationHeight,
              duration: const Duration(seconds: 1),
              curve: Curves.linearToEaseOut,
              //1 ------------imagem da logo--------------
              child: Image.asset(
                ImageConstants.imageLogo,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
