---
inject: true
to: <%= dtos_dir %>/dtos.dart
skip_if: <%= name_file %>_dto.dart
at_line: 1000
---
export '<%= name_file %>_dto.dart';