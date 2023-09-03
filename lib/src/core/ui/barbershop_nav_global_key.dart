import 'package:flutter/material.dart';

class BarbershopNavGlobalKey {
  static BarbershopNavGlobalKey? _instance;
  // Avoid self instance
  final navKey = GlobalKey<NavigatorState>();
  BarbershopNavGlobalKey._();
  static BarbershopNavGlobalKey get instance =>
      _instance ??= BarbershopNavGlobalKey._();
}
