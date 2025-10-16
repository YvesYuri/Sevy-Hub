// ignore: deprecated_member_use, avoid_web_libraries_in_flutter
import 'dart:html' as html;
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:sevyhub/firebase_options.dart';
import 'package:sevyhub/src/app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  FlutterError.onError = (FlutterErrorDetails details) {
    if (details.exceptionAsString().contains(
      'org-dartlang-sdk:///lib/_engine/engine/window.dart',
    )) {
      return;
    }
    FlutterError.presentError(details);
  };

  html.document.onContextMenu.listen((event) => event.preventDefault());

  runApp(const App());
}
