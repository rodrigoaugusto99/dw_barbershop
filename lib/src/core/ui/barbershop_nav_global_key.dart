import 'package:flutter/material.dart';

class BarbershopNavGlobalKey {
  static BarbershopNavGlobalKey? _instance;
  // Avoid self instance
  //global key do tipo NavigatorState!
  final navKey = GlobalKey<NavigatorState>();
  BarbershopNavGlobalKey._();
  static BarbershopNavGlobalKey get instance =>
      _instance ??= BarbershopNavGlobalKey._();
}
/*contexto estatico e metodo estatico de instante, e tudo
que eu guardar dentro dessa instancia, vai ser estatico,
uma unica instancioa*/