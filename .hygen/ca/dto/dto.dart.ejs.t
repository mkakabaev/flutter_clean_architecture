---
to: <%= dto_dir %>/<%= name_file %>_dto.dart
---
import 'dart:async';
import 'package:json_annotation/json_annotation.dart';

part '<%= name_file %>_dto.g.dart'; 
<% nt = name_type + "Dto" -%>

@JsonSerializable()
class <%= nt %> {
  <%= nt %>({ 
    required this.string1, 
    required this.string2, 
    this.string3 = "",
  });

  @JsonKey(required: true)
  final String string1;

  @JsonKey(required: true)
  final String string2;

  @JsonKey(name: 'other_key', includeFromJson: false, includeToJson: true, defaultValue: "")
  final String string3;    

  factory <%= nt %>.fromJson(Map<String, dynamic> json) => _$<%= nt %>FromJson(json);
  Map<String, dynamic> toJson() => _$<%= nt %>ToJson(this);
}

// This is for compute() to be used by retrofit
FutureOr<%- h.lt() %><%= nt %>> deserialize<%= nt %>(Map<String, dynamic> json) => <%= nt %>.fromJson(json);
FutureOr<Map<String, dynamic>> serialize<%= nt %>(<%= nt %> object) => object.toJson();

