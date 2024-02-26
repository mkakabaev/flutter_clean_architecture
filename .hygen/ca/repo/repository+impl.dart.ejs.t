---
to: <%= feature_dir %>/data/repositories/<%= name_file %>_repository+impl.dart
---
import 'package:mk_clean_architecture/core/core.dart';
<% if (locals.entity) { -%>import '../../domain/entities/<%= entity_file %>.dart';<% } -%> 
import '../../domain/repositories/<%= name_file %>_repository.dart';

@LazySingleton(as: <%= name_type %>Repository)
class <%= name_type %>RepositoryImpl implements <%= name_type %>Repository {
  <%= name_type %>RepositoryImpl() {
      //
  }
  <% if (locals.entity) { -%> 
  @override
  <%= entity_type %> getEntity() => throw UnimplementedError("Unimplemented");
  <% } %>
}
