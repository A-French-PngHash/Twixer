import os
import time
from flask import request, send_file
from api import api_utils
from logic import browsing
from api.api_utils import *

from __main__ import app
from logic import browsing
from logic.profile import get_profile_picture_path, update_profile, update_profile_picture

@app.route("/profile", methods=['POST'])
@get_headers(["token"])
def update_profile_route(output):
    change = request.headers
    result1, code1 = update_profile(output[0], change)
    print(request.files)
    if "profile-picture" in request.files:
        file = request.files["profile-picture"]
        result2, code2 = update_profile_picture(output[0], file)
    if code1 != 200:
        return error(result1), code1
    if code2 != 200:
        return error(result2), code2
    
    return "", 200
        

@app.route("/profile", methods=["GET"])
@get_headers(["username", "length", "offset", "order-by"])
def get_profile(output):
    username = output[0]
    profile_data, code = browsing.get_profile_data(username)
    if code != 200:
        return error(profile_data), code
    tweets, code = browsing.view_tweets_on_profile(output[0], output[1], output[2], output[3])
    if code != 200:
        return error(tweets), code
    

    profile_data["tweets"] = tweets
    return profile_data, 200

@app.route("/profile/picture", methods = ["GET"])
@get_headers(["username"])
def get_profile_picture(output):


    filename, code = get_profile_picture_path(output[0])
    if code != 200:
        return error(filename), code
    
    if os.path.isfile(filename):
        return send_file(filename), 200
    else:
        return "", 200

