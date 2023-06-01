import 'package:flutter_player/generated/json/base/json_convert_content.dart';
import 'package:flutter_player/bean/app_version_entity.dart';

AppVersionEntity $AppVersionEntityFromJson(Map<String, dynamic> json) {
	final AppVersionEntity appVersionEntity = AppVersionEntity();
	final String? downloadUrl = jsonConvert.convert<String>(json['downloadUrl']);
	if (downloadUrl != null) {
		appVersionEntity.downloadUrl = downloadUrl;
	}
	final int? number = jsonConvert.convert<int>(json['number']);
	if (number != null) {
		appVersionEntity.number = number;
	}
	final String? name = jsonConvert.convert<String>(json['name']);
	if (name != null) {
		appVersionEntity.name = name;
	}
	return appVersionEntity;
}

Map<String, dynamic> $AppVersionEntityToJson(AppVersionEntity entity) {
	final Map<String, dynamic> data = <String, dynamic>{};
	data['downloadUrl'] = entity.downloadUrl;
	data['number'] = entity.number;
	data['name'] = entity.name;
	return data;
}