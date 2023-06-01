import 'package:flutter_player/generated/json/base/json_field.dart';
import 'package:flutter_player/generated/json/app_version_entity.g.dart';
import 'dart:convert';

@JsonSerializable()
class AppVersionEntity {
	 String? downloadUrl;
	 int? number;
	 String? name;

	AppVersionEntity();

	factory AppVersionEntity.fromJson(Map<String, dynamic> json) => $AppVersionEntityFromJson(json);

	Map<String, dynamic> toJson() => $AppVersionEntityToJson(this);

	@override
	String toString() {
		return jsonEncode(this);
	}
}