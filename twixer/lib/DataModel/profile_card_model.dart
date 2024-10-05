import 'package:json_annotation/json_annotation.dart';

part 'profile_card_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)

/// Used when loading a big amount of user profile, only loading username and
/// description reduces the server computing time as usually followers and
/// following have to be computed with a different request.
///
/// When displaying a profile, or loading the data of only one user, `UserModel`
/// should be used instead.
///
class ProfileCardModel {
  ProfileCardModel(this.username, this.description);

  String username;
  String description;

  factory ProfileCardModel.fromJson(Map<String, dynamic> json) {
    return _$ProfileCardModelFromJson(json);
  }

  Map<String, dynamic> toJson() => _$ProfileCardModelToJson(this);
}
