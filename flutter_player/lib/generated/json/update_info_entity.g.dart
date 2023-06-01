import 'package:flutter_player/generated/json/base/json_convert_content.dart';
import 'package:flutter_player/bean/update_info_entity.dart';

UpdateInfoEntity $UpdateInfoEntityFromJson(Map<String, dynamic> json) {
	final UpdateInfoEntity updateInfoEntity = UpdateInfoEntity();
	final bool? hasUpdate = jsonConvert.convert<bool>(json['hasUpdate']);
	if (hasUpdate != null) {
		updateInfoEntity.hasUpdate = hasUpdate;
	}
	final bool? isIgnorable = jsonConvert.convert<bool>(json['isIgnorable']);
	if (isIgnorable != null) {
		updateInfoEntity.isIgnorable = isIgnorable;
	}
	final int? versionCode = jsonConvert.convert<int>(json['versionCode']);
	if (versionCode != null) {
		updateInfoEntity.versionCode = versionCode;
	}
	final String? versionName = jsonConvert.convert<String>(json['versionName']);
	if (versionName != null) {
		updateInfoEntity.versionName = versionName;
	}
	final String? updateLog = jsonConvert.convert<String>(json['updateLog']);
	if (updateLog != null) {
		updateInfoEntity.updateLog = updateLog;
	}
	final String? apkUrl = jsonConvert.convert<String>(json['apkUrl']);
	if (apkUrl != null) {
		updateInfoEntity.apkUrl = apkUrl;
	}
	final int? apkSize = jsonConvert.convert<int>(json['apkSize']);
	if (apkSize != null) {
		updateInfoEntity.apkSize = apkSize;
	}
	return updateInfoEntity;
}

Map<String, dynamic> $UpdateInfoEntityToJson(UpdateInfoEntity entity) {
	final Map<String, dynamic> data = <String, dynamic>{};
	data['hasUpdate'] = entity.hasUpdate;
	data['isIgnorable'] = entity.isIgnorable;
	data['versionCode'] = entity.versionCode;
	data['versionName'] = entity.versionName;
	data['updateLog'] = entity.updateLog;
	data['apkUrl'] = entity.apkUrl;
	data['apkSize'] = entity.apkSize;
	return data;
}