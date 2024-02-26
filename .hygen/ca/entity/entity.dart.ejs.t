---
to: <%= feature_dir %>/domain/entities/<%= name_file %>.dart
---
import 'package:equatable/equatable.dart';

class <%= name_type %> extends Equatable {
  const <%= name_type %>();

  @override
  List<Object?> get props => throw UnimplementedError("Implement props in <%= name_type %>!");
}
