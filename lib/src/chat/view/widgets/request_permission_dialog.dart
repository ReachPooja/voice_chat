import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:voice_chat/src/permissions/bloc/permissions_bloc.dart';

Future<void> showRequestPermissionDialog(BuildContext context) {
  return showDialog<void>(
    context: context,
    builder: (context) => const _RequestPermissionDialog(),
  );
}

class _RequestPermissionDialog extends StatelessWidget {
  const _RequestPermissionDialog();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        margin: const EdgeInsets.all(20),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Permission Denied',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(
                height: 8,
              ),
              const Text(
                'You have been denied access to the microphone.\nPlease grant'
                ' permission to access the microphone',
              ),
              const SizedBox(
                height: 4,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(
                        context,
                      );
                    },
                    child: const Text(
                      'Cancel',
                    ),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  TextButton(
                    onPressed: () {
                      context
                          .read<PermissionsBloc>()
                          .add(MicPermissionRequested());
                      Navigator.popUntil(
                        context,
                        (route) => route.settings.name == 'ChatView',
                      );
                    },
                    child: const Text('Allow'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
