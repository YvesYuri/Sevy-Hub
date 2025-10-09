import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:sevyhub/firebase_options.dart';
import 'package:sevyhub/src/app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

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
