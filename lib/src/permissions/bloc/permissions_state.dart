part of 'permissions_bloc.dart';

class PermissionsState extends Equatable {
  const PermissionsState({
    this.micStatus = const Status.initial(),
    this.micPermissionStatus = MicPermissionStatus.none,
  });

  final Status micStatus;
  final MicPermissionStatus micPermissionStatus;

  @override
  List<Object> get props => [micStatus, micPermissionStatus];

  PermissionsState copyWith({
    Status? micStatus,
    MicPermissionStatus? micPermissionStatus,
  }) {
    return PermissionsState(
      micStatus: micStatus ?? this.micStatus,
      micPermissionStatus: micPermissionStatus ?? this.micPermissionStatus,
    );
  }

  @override
  String toString() => 'PermissionsState(micStatus: $micStatus,'
      ' micPermissionStatus: $micPermissionStatus)';
}
