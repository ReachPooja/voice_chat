import 'package:flutter/material.dart';
import 'package:voice_chat/app/app.dart';
import 'package:voice_chat/app/injector/injector.dart';
import 'package:voice_chat/bootstrap.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  configureInjector();

  bootstrap(MyApp.new);
}
