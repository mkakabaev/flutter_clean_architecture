---
inject: true
to: <%= feature_dir %>/<%= feature_file %>.dart
skip_if: domain/entities/<%= name_file %>.dart
at_line: 1000
---
export 'domain/entities/<%= name_file %>.dart';
