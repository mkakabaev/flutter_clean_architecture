---
to: <%= dto_dir %>/<%= name_file %>_dto.dart
---
import 'package:json_annotation/json_annotation.dart';

part '<%= name_file %>_dto.g.dart'; 
<% nt = name_type + "Dto" -%>

@JsonSerializable()
class <%= nt %> {
  <%= nt %>({ 
    required this.string1, 
    this.optionalBool = false,
    this.conditionalString1 = "",
  });

  @JsonKey(required: true)
  final String string1;

  @JsonKey(name: 'other_key', defaultValue: false)
  final bool optionalBool;

  @JsonKey(includeFromJson: false, includeToJson: true)
  final String conditionalString1;    

  factory <%= nt %>.fromJson(Map<String, dynamic> json) => _$<%= nt %>FromJson(json);
  Map<String, dynamic> toJson() => _$<%= nt %>ToJson(this);
}
