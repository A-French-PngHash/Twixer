import 'package:json_annotation/json_annotation.dart';

part 'user_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class UserModel {
  UserModel(this.follower, this.following, this.username, this.description, this.joinDate, this.birthDate, this.name,
      this.profileBannerColor,
      {this.isFollowing});

  int follower;
  int following;
  String name;
  String profileBannerColor;
  String username;
  String description;
  DateTime joinDate;
  DateTime? birthDate;

  /// Wether the current logged in account is following this user.
  bool? isFollowing;

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return _$UserModelFromJson(json);
  }

  Map<String, dynamic> toJson() => _$UserModelToJson(this);
}
