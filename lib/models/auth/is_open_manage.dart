import 'package:json_annotation/json_annotation.dart';

part 'is_open_manage.g.dart';

@JsonSerializable()
class IsOpenManageResponse {
  @JsonKey(name: 'isOpenManage')
  final bool isOpenManage;

  IsOpenManageResponse({required this.isOpenManage});

  factory IsOpenManageResponse.fromJson(Map<String, dynamic> json) => _$IsOpenManageResponseFromJson(json);

  Map<String, dynamic> toJson() => _$IsOpenManageResponseToJson(this);
}

@JsonSerializable()
class IsOpenManagePayload {
  @JsonKey(name: 'id')
  final String id;
  @JsonKey(name: 'sig')
  final String sig;
  @JsonKey(name: 'iv')
  final String iv;

  IsOpenManagePayload({required this.id, required this.sig, required this.iv});

  factory IsOpenManagePayload.fromJson(Map<String, dynamic> json) => _$IsOpenManagePayloadFromJson(json);

  Map<String, dynamic> toJson() => _$IsOpenManagePayloadToJson(this);
}