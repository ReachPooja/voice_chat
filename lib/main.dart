import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:voice_chat/app/app.dart';
import 'package:voice_chat/app/bootstrap.dart';
import 'package:voice_chat/app/injector/injector.dart';
import 'package:voice_chat/src/chat/models/chat/chat.dart';
import 'package:voice_chat/src/chat/models/conversation/conversation.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  configureInjector();

  await Hive.initFlutter();
  Hive
    ..registerAdapter(ConversationAdapter())
    ..registerAdapter(ChatAdapter());

  await bootstrap(MyApp.new);
}
