import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:voice_chat/app/injector/injector.dart';
import 'package:voice_chat/src/home/bloc/chat_history_bloc.dart';
import 'package:voice_chat/src/home/view/home_view.dart';
import 'package:voice_chat/src/permissions/bloc/permissions_bloc.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => getIt<ChatHistoryBloc>()
            ..add(
              DataChecked(),
            ),
        ),
        BlocProvider(
          create: (context) => getIt<PermissionsBloc>(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const HomeView(),
      ),
    );
  }
}
