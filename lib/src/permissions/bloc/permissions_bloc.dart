import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import 'package:voice_chat/src/core/domain/status/status.dart';
import 'package:voice_chat/src/permissions/repository/permissions_repository.dart';

part 'permissions_event.dart';
part 'permissions_state.dart';

@injectable
class PermissionsBloc extends Bloc<PermissionsEvent, PermissionsState> {
  PermissionsBloc(this._permissionsRepository)
      : super(const PermissionsState()) {
    on<MicPermissionRequested>(_onMicPermissionRequested);
  }

  final IPermissionsRepository _permissionsRepository;

  Future<void> _onMicPermissionRequested(
    MicPermissionRequested event,
    Emitter<PermissionsState> emit,
  ) async {
    emit(
      state.copyWith(
        micStatus: const Status.loading(),
        micPermissionStatus: MicPermissionStatus.none,
      ),
    );
    final permission = await _permissionsRepository.requestMicPermissions();
    emit(
      state.copyWith(
        micStatus: const Status.success(),
        micPermissionStatus: permission,
      ),
    );
  }
}
