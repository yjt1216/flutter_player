import 'package:flutter_player/generated/json/base/json_field.dart';
import 'package:flutter_player/generated/json/update_info_entity.g.dart';
import 'dart:convert';

@JsonSerializable()
class UpdateInfoEntity {
	bool? hasUpdate;
	bool? isIgnorable;
	int? versionCode;
	String? versionName;
	String? updateLog;
	String? apkUrl;
	int? apkSize;

	UpdateInfoEntity();

	factory UpdateInfoEntity.fromJson(Map<String, dynamic> json) => $UpdateInfoEntityFromJson(json);

	Map<String, dynamic> toJson() => $UpdateInfoEntityToJson(this);

	@override
	String toString() {
		return jsonEncode(this);
	}
}