// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tweet_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TweetModel _$TweetModelFromJson(Map<String, dynamic> json) => TweetModel(
      (json['id'] as num).toInt(),
      json['content'] as String,
      (json['retweet_id'] as num?)?.toInt(),
      (json['author'] as num).toInt(),
      (json['like_count'] as num).toInt(),
      (json['number_of_response'] as num).toInt(),
      (json['post_date'] as num).toInt(),
      (json['replying_to'] as num?)?.toInt(),
      json['username'] as String,
      (json['is_liked'] as num?)?.toInt(),
      (json['is_retweeted'] as num?)?.toInt(),
    );

Map<String, dynamic> _$TweetModelToJson(TweetModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'author': instance.authorId,
      'username': instance.authorUsername,
      'content': instance.content,
      'retweet_id': instance.retweetId,
      'like_count': instance.likeCount,
      'number_of_response': instance.numberOfResponse,
      'post_date': instance.postDate,
      'replying_to': instance.replyingTo,
      'is_liked': instance.isLiked,
      'is_retweeted': instance.isRetweeted,
    };
