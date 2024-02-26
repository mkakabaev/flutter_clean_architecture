---
to: <%= feature_dir %>/domain/repositories/<%= name_file %>_repository.dart
---
<% if (locals.entity) { -%>
import '../entities/<%= entity_file %>.dart'; 
<% } -%>    
abstract interface class <%= name_type %>Repository {
  <% if (locals.entity) { -%> <%= entity_type %> getEntity(); <% } -%>    
}
