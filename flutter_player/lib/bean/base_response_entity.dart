import 'package:flutter_player/generated/json/base/json_field.dart';
import 'package:flutter_player/generated/json/base_response_entity.g.dart';
import 'dart:convert';

@JsonSerializable()
class BaseResponseEntity {
	int? code;
	String? message;
	dynamic data;

	BaseResponseEntity();

	factory BaseResponseEntity.fromJson(Map<String, dynamic> json) => $BaseResponseEntityFromJson(json);

	Map<String, dynamic> toJson() => $BaseResponseEntityToJson(this);

	@override
	String toString() {
		return jsonEncode(this);
	}
}