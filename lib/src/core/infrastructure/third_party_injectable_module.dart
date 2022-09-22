import 'package:injectable/injectable.dart';
import 'package:speech_to_text/speech_to_text.dart';

@module
abstract class ThirdPartyInjectableModule {
  @lazySingleton
  SpeechToText get speechToText => SpeechToText();
}
