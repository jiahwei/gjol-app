// lib/models/bulletins/bulletin_db.dart
import 'package:json_annotation/json_annotation.dart';

part 'bulletin_db.g.dart';

@JsonSerializable()
class BulletinDB {
  @JsonKey(name: 'id')
  final int? id;

  @JsonKey(name: 'bulletin_date')
  final String bulletinDate;

  @JsonKey(name: 'original_date')
  final String originalDate;

  @JsonKey(name: 'total_leng')
  final int totalLeng;

  @JsonKey(name: 'content_total_arr')
  final String contentTotalArr;

  @JsonKey(name: 'bulletin_name')
  final String? bulletinName;

  @JsonKey(name: 'version_id')
  final int versionId;

  @JsonKey(name: 'type')
  final String type;

  BulletinDB({
    required this.id,
    required this.bulletinDate,
    required this.originalDate,
    required this.totalLeng,
    required this.contentTotalArr,
    required this.bulletinName,
    required this.versionId,
    required this.type,
  });

  factory BulletinDB.fromJson(Map<String, dynamic> json) =>
      _$BulletinDBFromJson(json);

  Map<String, dynamic> toJson() => _$BulletinDBToJson(this);
}