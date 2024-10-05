from flask import request
from __main__ import app
from logic import auth
from api.api_utils import get_headers, get_params, error

@app.route('/login', methods=["GET"])
@get_headers(["username", "digest"])
def login_route(output):
    username, digest = output[0], output[1]
    result, token = auth.get_token(username, digest)
    
    if result:
        return {"token" : token}, 200
    else:
        return {"error" : "Username/password is incorrect."}, 401 # Unauthorized

@app.route('/signup', methods=["POST"])
@get_headers(["username", "digest"])
def signup_route(output):
    username, digest = output[0], output[1]
    if len(username) > 40:
        return error("Username length must not exceed 40 characters"), 400
    # Creates a new user
    auth.signup(username, digest)

    result, token = auth.get_token(username, digest)
    if result:
        return {"token" : token}, 200
    else:
        return {"error" : "Username/password is incorrect."}, 401 # Unauthorized