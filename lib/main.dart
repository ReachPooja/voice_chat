import 'package:flutter/material.dart';
import 'package:voice_chat/app/app.dart';
import 'package:voice_chat/app/injector/injector.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  configureInjector();

  runApp(const MyApp());
}
