from flask import request
from db import follow
from logic import browsing
from api.api_utils import *

from __main__ import app
from logic import browsing


@app.route("/search", methods=["GET"])
@get_headers(["search-string", "order-by", "user-limit", "user-offset", "tweet-limit", "tweet-offset"])
@get_optional_header(["token"])
def search(output, optional=None):
    users,code = browsing.search_user(output[0], output[2], output[3])
    if code != 200:
        return error(users), code
    tweets,code = browsing.search_tweet(output[0], output[1], output[4], output[5], token=optional["token"])
    if code != 200:
        return error(tweets), code
    return {"users":users, "tweets":tweets}

@app.route("/home", methods=["GET"])
@get_headers(["token", "limit", "offset"])
def get_homepage(output):
    tweets,code = browsing.get_homepage_tweets(output[0], output[1], output[2])
    if code != 200:
        return error(tweets), code
    print(tweets)
    return {"tweets":tweets}, code

@app.route("/response", methods=["GET"])
@get_headers(["tweet-id","limit", "offset", "order-by"])
def get_response(output):
    tweets,code = browsing.get_response_to(output[0], output[1], output[2], output[3])
    if code != 200:
        return error(tweets), code
    return {"tweets":tweets}, code

@app.route("/tweet", methods=["GET"])
@get_headers(["tweet-id"])
@get_optional_header(["token"])
def get_tweet(output, optional = None):
    tweet, code = browsing.get_tweet_by_id(output[0], token=optional["token"])
    if code != 200:
        return error(tweet), code
    return {"tweet" : tweet}, code

@app.route("/follower")
@get_headers(["user-id", "limit", "offset"])
def get_followers(output):
    followers, code = browsing.get_followers(*output)
    return {"followers" : followers}, code

@app.route("/following")
@get_headers(["user-id", "limit", "offset"])
def get_following(output):
    followers, code = browsing.get_following(*output)
    return {"following" : followers}, code
