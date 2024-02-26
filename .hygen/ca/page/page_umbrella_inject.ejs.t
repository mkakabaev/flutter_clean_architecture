---
inject: true
to: <%= feature_dir %>/<%= feature_file %>.dart
skip_if: presentation/pages/<%= name_file %>/page.dart
at_line: 1000
---
export 'presentation/pages/<%= name_file %>/page.dart';