import 'package:json_annotation/json_annotation.dart';

part 'search_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class SearchModel {
  @JsonKey(name: "id")
  int userId;
  String content;
  int date;

  SearchModel(this.userId, this.content, this.date);

  factory SearchModel.fromJson(Map<String, dynamic> json) {
    return _$SearchModelFromJson(json);
  }

  Map<String, dynamic> toJson() => _$SearchModelToJson(this);
}
