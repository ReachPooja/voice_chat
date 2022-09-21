import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:voice_chat/src/chat/repository/speech/i_speech_repository.dart';
import 'package:voice_chat/src/core/domain/failures/failures.dart';

@LazySingleton(as: ISpeechRepository)
class SpeechRepository implements ISpeechRepository {
  SpeechRepository(this._speechToText);

  final SpeechToText _speechToText;

  @override
  Future<void> initialze() async => _speechToText.initialize();

  @override
  bool isListening() => _speechToText.isListening;

  @override
  Future<Either<Failure, String>> listen() async {
    try {
      var text = '';
      await _speechToText.listen(
        onResult: (result) {
          text = result.recognizedWords;
        },
      );
      return right(text);
    } on SpeechToTextNotInitializedException catch (_) {
      return left(
        const Failure.value('SpeechToText is not initialized'),
      );
    } on ListenFailedException catch (e) {
      return left(
        Failure.error(e.message.toString()),
      );
    } catch (e) {
      return left(
        Failure.unexpected(e.toString()),
      );
    }
  }

  @override
  Future<void> stop() async {
    await _speechToText.stop();
  }
}
