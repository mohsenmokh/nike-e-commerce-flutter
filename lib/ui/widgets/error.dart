import 'package:flutter/material.dart';
import 'package:flutter_application_2/common/exceptions.dart';

class AppErrorWidget extends StatelessWidget {
  final AppException exception;
  final GestureTapCallback onPressed;
  const AppErrorWidget({
    super.key,
    required this.exception,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(exception.message),
          ElevatedButton(
              onPressed: onPressed, child: const Text('تلاش دوباره')),
        ],
      ),
    );
  }
}
