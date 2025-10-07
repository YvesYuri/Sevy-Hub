import 'package:flutter/material.dart';
import 'package:sevyhub/src/app.dart';

void main() {
  FlutterError.onError = (FlutterErrorDetails details) {
    // filtra por parte do stack que você quer ignorar
    if (details.exceptionAsString().contains(
      'org-dartlang-sdk:///lib/_engine/engine/window.dart',
    )) {
      // ignora
      return;
    }
    FlutterError.presentError(details); // mostra outros erros
  };
  
  runApp(const App());
}
