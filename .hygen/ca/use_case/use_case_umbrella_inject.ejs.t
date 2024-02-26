---
inject: true
to: <%= feature_dir %>/<%= feature_file %>.dart
skip_if: domain/use_cases/<%= name_file %>.dart
at_line: 1000
---
export 'domain/use_cases/<%= name_file %>.dart';