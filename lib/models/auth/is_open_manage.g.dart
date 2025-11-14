// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'is_open_manage.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

IsOpenManageResponse _$IsOpenManageResponseFromJson(
        Map<String, dynamic> json) =>
    IsOpenManageResponse(
      isOpenManage: json['isOpenManage'] as bool,
      token: json['token'] as String,
      refreshToken: json['refreshToken'] as String,
    );

Map<String, dynamic> _$IsOpenManageResponseToJson(
        IsOpenManageResponse instance) =>
    <String, dynamic>{
      'isOpenManage': instance.isOpenManage,
      'token': instance.token,
      'refreshToken': instance.refreshToken,
    };

IsOpenManagePayload _$IsOpenManagePayloadFromJson(Map<String, dynamic> json) =>
    IsOpenManagePayload(
      id: json['id'] as String,
      sig: json['sig'] as String,
      iv: json['iv'] as String,
    );

Map<String, dynamic> _$IsOpenManagePayloadToJson(
        IsOpenManagePayload instance) =>
    <String, dynamic>{
      'id': instance.id,
      'sig': instance.sig,
      'iv': instance.iv,
    };
