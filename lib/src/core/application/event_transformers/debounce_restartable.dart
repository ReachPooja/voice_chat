import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart';

const debounceDuration = Duration(milliseconds: 400);

EventTransformer<E> debounceRestartable<E>([
  Duration duration = debounceDuration,
]) {
  return (events, mapper) {
    return restartable<E>().call(events.debounceTime(duration), mapper);
  };
}
