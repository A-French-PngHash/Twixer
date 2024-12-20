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
      json['birth_date'] == null
          ? null
          : DateTime.parse(json['birth_date'] as String),
      json['name'] as String,
      json['profile_banner_color'] as String,
      (json['id'] as num).toInt(),
      isFollowing: json['is_following'] as bool?,
    );

Map<String, dynamic> _$UserModelToJson(UserModel instance) => <String, dynamic>{
      'id': instance.id,
      'follower': instance.follower,
      'following': instance.following,
      'name': instance.name,
      'profile_banner_color': instance.profileBannerColor,
      'username': instance.username,
      'description': instance.description,
      'join_date': instance.joinDate.toIso8601String(),
      'birth_date': instance.birthDate?.toIso8601String(),
      'is_following': instance.isFollowing,
    };
