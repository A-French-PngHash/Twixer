import 'package:json_annotation/json_annotation.dart';

part 'tweet_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class TweetModel {
  TweetModel(this.id, this.content, this.retweetId, this.authorId, this.likeCount, this.numberOfResponse, this.postDate,
      this.replyingTo, this.authorUsername, this.isLiked);

  int id;
  @JsonKey(name: "author")
  int authorId;
  @JsonKey(name: "username")
  String authorUsername;
  String content;
  int? retweetId;
  int likeCount;
  int numberOfResponse;
  int postDate;
  int? replyingTo;
  int isLiked;

  factory TweetModel.fromJson(Map<String, dynamic> json) {
    return _$TweetModelFromJson(json);
  }

  Map<String, dynamic> toJson() => _$TweetModelToJson(this);
}
