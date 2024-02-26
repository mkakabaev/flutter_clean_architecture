import 'package:mk_clean_architecture/core/core.dart';
import 'package:flutter/material.dart';

class PageController1 {
  final BuildContext _buildContext;

  PageController1({required BuildContext buildContext}) : _buildContext = buildContext;

  void showError(MyError error) {
    if (!_buildContext.mounted) {
      return;
    }

    final theme = Theme.of(_buildContext);
    ScaffoldMessenger.maybeOf(_buildContext)?.showSnackBar(
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
    if (!_buildContext.mounted) {
      return;
    }
    ScaffoldMessenger.maybeOf(_buildContext)?.hideCurrentSnackBar();
  }

  bool get isTopmost {
    if (_buildContext.mounted) {
      if (ModalRoute.of(_buildContext)?.isCurrent == true) {
        return true;
      }
    }
    return false;
  }

  void dropFocus() {
    FocusScope.of(_buildContext).requestFocus(FocusNode());
  }
}
