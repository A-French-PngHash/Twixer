// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserModel _$UserModelFromJson(Map<String, dynamic> json) => UserModel(
      (json['follower'] as num).toInt(),
      (json['following'] as num).toInt(),
      json['username'] as String,
      json['description'] as String,
      DateTime.parse(json['join_date'] as String),
      json['birth_date'] == null ? null : DateTime.parse(json['birth_date'] as String),
    );

Map<String, dynamic> _$UserModelToJson(UserModel instance) => <String, dynamic>{
      'follower': instance.follower,
      'following': instance.following,
      'username': instance.username,
      'description': instance.description,
      'join_date': instance.joinDate.toIso8601String(),
      'birth_date': instance.birthDate?.toIso8601String(),
    };
