import 'package:flutter/material.dart';

import '../validation.dart';

enum MyTextFieldRole {
  username,
  password,
}

class MyTextField extends StatefulWidget {
  final MyTextFieldRole role;
  final TextEditingController controller;
  final String? label;
  final bool? isRequired;
  final InputValidation validation;
  final bool autofocus;

  const MyTextField({
    super.key,
    required this.role,
    required this.controller,
    this.label,
    this.autofocus = false,
    this.isRequired = false,
    this.validation = const InputValidation.valid(),
  });

  @override
  State createState() => _MyTextFieldState();
}

class _MyTextFieldState extends State<MyTextField> {
  final _focusNode = FocusNode();

  // We show empty-field-error only when user leaves the field at least once.
  var _focusLeavedAtLeastOnce = false;

  @override
  void initState() {
    super.initState();

    _focusNode.addListener(() {
      setState(() {
        if (!_focusNode.hasFocus) {
          _focusLeavedAtLeastOnce = true;
        }
      });
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    Widget? labelWidget;
    final label = widget.label;
    if (label != null) {
      labelWidget = Row(children: [Text(label), Text("*", style: TextStyle(color: theme.colorScheme.error))]);
    }

    String? errorText;
    switch (widget.validation) {
      case InputValidationEmpty():
        errorText = widget.isRequired! && _focusLeavedAtLeastOnce ? 'This field is mandatory' : null;

      case InputValidationValid():
        break;

      case InputValidationInvalid(error: var error):
        errorText = error.message;
    }

    return TextField(
      controller: widget.controller,
      autocorrect: false,
      autofocus: widget.autofocus,
      textCapitalization: TextCapitalization.none,
      textInputAction: TextInputAction.next,
      focusNode: _focusNode,
      decoration: InputDecoration(
        label: labelWidget,
        error: errorText == null
            ? null
            : Text(
                errorText,
                style: TextStyle(
                  color: theme.colorScheme.error,
                ),
              ),
      ),
    );
  }
}
