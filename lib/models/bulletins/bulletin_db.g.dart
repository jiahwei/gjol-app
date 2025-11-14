// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bulletin_db.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BulletinDB _$BulletinDBFromJson(Map<String, dynamic> json) => BulletinDB(
      id: (json['id'] as num?)?.toInt(),
      bulletinDate: json['bulletin_date'] as String,
      originalDate: json['original_date'] as String,
      totalLeng: (json['total_leng'] as num).toInt(),
      contentTotalArr: json['content_total_arr'] as String,
      bulletinName: json['bulletin_name'] as String?,
      versionId: (json['version_id'] as num).toInt(),
      type: json['type'] as String,
    );

Map<String, dynamic> _$BulletinDBToJson(BulletinDB instance) =>
    <String, dynamic>{
      'id': instance.id,
      'bulletin_date': instance.bulletinDate,
      'original_date': instance.originalDate,
      'total_leng': instance.totalLeng,
      'content_total_arr': instance.contentTotalArr,
      'bulletin_name': instance.bulletinName,
      'version_id': instance.versionId,
      'type': instance.type,
    };
