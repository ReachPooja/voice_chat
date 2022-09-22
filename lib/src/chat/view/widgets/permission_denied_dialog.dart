import 'package:flutter/material.dart';

Future<void> showPermissionDeniedDialog(BuildContext context) {
  return showDialog<void>(
    context: context,
    builder: (context) => const _PermissionDeniedDialog(),
  );
}

class _PermissionDeniedDialog extends StatelessWidget {
  const _PermissionDeniedDialog();

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
                'Permission Denied Permanently',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(
                height: 8,
              ),
              const Text(
                'You have been permanently denied access to the microphone'
                '\nNow to access the microphone, please go to the device '
                'settings and enable microphone permissions',
              ),
              const SizedBox(
                height: 4,
              ),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Ok'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
