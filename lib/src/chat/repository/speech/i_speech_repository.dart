import 'package:dartz/dartz.dart';
import 'package:voice_chat/src/core/domain/failures/failures.dart';

abstract class ISpeechRepository {
  Future<void> initialze();
  bool isListening();
  Future<Either<Failure, Unit>> listen({
    required void Function(String) onResult,
  });
  Future<void> stop();
}
