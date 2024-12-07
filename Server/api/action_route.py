from flask import request

from __main__ import app
from logic import actions
from api.api_utils import get_headers, get_params, error

@app.route('/tweet', methods=["POST"])
@get_headers(["token", "content", "replies-to"], additional_error_message=". (replies-to must be set to -1 if the tweet is not replying to any other tweet.)")
def tweet_route(output):
    token,content=output[0],output[1]
    replies_to = int(output[2]) if output[2] != "-1" else None
    code, message = actions.tweet(token, content, replies_to)
    if code != 200:
        return error(message), code
    else:
        return "", 200

@app.route('/tweet', methods=["DELETE"])
@get_headers(["token", "tweet_id"])
def delete_tweet(output):
    message, code = actions.delete_tweet(output[0], output[1])
    if code != 200:
        return error(message), code
    else:
        return "", 200

@app.route('/retweet', methods=["POST"])
@get_headers(["token", "tweet-id"])
def retweet(output):
    message,code = actions.retweet(output[0], output[1], request.headers.get("content"))
    if code != 200:
        return error(message), code
    else:
        return message, 200

@app.route('/like', methods=["POST"])
@get_headers(["token", "tweet-id"])
def like(output):
    message,code = actions.like(output[0], output[1])
    if code != 200:
        return error(message), code
    else:
        return message, 200

@app.route('/follow', methods=["POST"])
@get_headers(["username-to-follow", "token"])
def follow(output):
    message, code = actions.follow(token = output[1], user_to_follow_username=output[0].lower())
    if code != 200:
        return error(message), code
    else:
        return message, 200