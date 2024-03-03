import 'package:mk_clean_architecture/core/core.dart';
import 'package:flutter/material.dart';

class PageController1 {
  final BuildContext _context;

  PageController1({
    required BuildContext buildContext,
  }) : _context = buildContext;

  void showError(MyError error) {
    if (!_context.mounted) {
      return;
    }

    final theme = Theme.of(_context);
    ScaffoldMessenger.maybeOf(_context)?.showSnackBar(
      SnackBar(
        content: Text(
          error.message,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onError,
          ),
        ),
        backgroundColor: theme.colorScheme.error,
      ),
    );
  }

  void hideErrors() {
    if (!_context.mounted) {
      return;
    }
    ScaffoldMessenger.maybeOf(_context)?.hideCurrentSnackBar();
  }

  bool get isTopmost {
    if (_context.mounted) {
      if (ModalRoute.of(_context)?.isCurrent == true) {
        return true;
      }
    }
    return false;
  }

  void dropFocus() {
    FocusScope.of(_context).requestFocus(FocusNode());
  }
}
