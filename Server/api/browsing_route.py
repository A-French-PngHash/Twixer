from flask import request
from logic import browsing
from api.api_utils import *

from __main__ import app
from logic import browsing


@app.route("/search", methods=["GET"])
@get_headers(["search-string", "order-by", "user-limit", "user-offset", "tweet-limit", "tweet-offset"])
def search(output):
    users,code = browsing.search_user(output[0], output[2], output[3])
    if code != 200:
        return error(users), code
    tweets,code = browsing.search_tweet(output[0], output[1], output[4], output[5])
    if code != 200:
        return error(tweets), code
    return {"users":users, "tweets":tweets}

@app.route("/home", methods=["GET"])
@get_headers(["token", "limit", "offset"])
def get_homepage(output):
    tweets,code = browsing.get_homepage_tweets(output[0], output[1], output[2])
    if code != 200:
        return error(tweets), code
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
def get_tweet(output):
    tweet, code = browsing.get_tweet_by_id(output[0])
    if code != 200:
        return error(tweet), code
    return {"tweet" : tweet}, code

