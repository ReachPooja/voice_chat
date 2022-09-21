// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:get_it/get_it.dart' as _i1;
import 'package:injectable/injectable.dart' as _i2;
import 'package:speech_to_text/speech_to_text.dart' as _i5;

import '../../src/chat/bloc/chat_bloc.dart' as _i9;
import '../../src/chat/repository/chat/chat_repository.dart' as _i4;
import '../../src/chat/repository/chat/i_chat_repository.dart' as _i3;
import '../../src/chat/repository/speech/i_speech_repository.dart' as _i7;
import '../../src/chat/repository/speech/speech_repository.dart' as _i8;
import '../../src/core/infrastructure/third_party_injectable_module.dart'
    as _i10;
import '../../src/home/bloc/chat_history_bloc.dart'
    as _i6; // ignore_for_file: unnecessary_lambdas

// ignore_for_file: lines_longer_than_80_chars
/// initializes the registration of provided dependencies inside of [GetIt]
_i1.GetIt $initGetIt(
  _i1.GetIt get, {
  String? environment,
  _i2.EnvironmentFilter? environmentFilter,
}) {
  final gh = _i2.GetItHelper(
    get,
    environment,
    environmentFilter,
  );
  final thirdPartyInjectableModule = _$ThirdPartyInjectableModule();
  gh.lazySingleton<_i3.IChatRepository>(() => _i4.ChatRepository());
  gh.lazySingleton<_i5.SpeechToText>(
      () => thirdPartyInjectableModule.speechToText);
  gh.factory<_i6.ChatHistoryBloc>(
      () => _i6.ChatHistoryBloc(get<_i3.IChatRepository>()));
  gh.lazySingleton<_i7.ISpeechRepository>(
      () => _i8.SpeechRepository(get<_i5.SpeechToText>()));
  gh.factory<_i9.ChatBloc>(() => _i9.ChatBloc(
        get<_i7.ISpeechRepository>(),
        get<_i3.IChatRepository>(),
      ));
  return get;
}

class _$ThirdPartyInjectableModule extends _i10.ThirdPartyInjectableModule {}
