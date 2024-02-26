import 'package:mk_clean_architecture/core/core.dart';
import 'package:flutter/material.dart';

class MyErrorWidget extends StatelessWidget {
  final VoidCallback onRetry;
  final MyError error;

  const MyErrorWidget({
    super.key,
    required this.onRetry,
    required this.error,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Something went wrong',
            style: theme.textTheme.headlineMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          Text(
            error.message,
            style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.secondary),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          MyButton.secondary(title: 'Retry', onTap: onRetry)
        ],
      ),
    );
  }
}
