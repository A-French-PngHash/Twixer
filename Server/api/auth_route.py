from flask import request
from __main__ import app
from logic import auth
from api.api_utils import get_headers, get_params, error
from logic.utils import user_exist

@app.route('/login', methods=["GET"])
@get_headers(["username", "digest"])
def login_route(output):
    username, digest = output[0], output[1]
    result, token, id = auth.get_token(username.lower(), digest)
    
    if result:
        return {"token" : token, "user-id" : id}, 200
    else:
        return {"error" : "Username/password is incorrect."}, 401 # Unauthorized

@app.route('/signup', methods=["POST"])
@get_headers(["username", "digest", "name"])
def signup_route(output):
    username, digest, name = output[0].lower(), output[1], output[2]
    if len(username) > 40 or len(name) > 40:
        return error("Username/name length must not exceed 40 characters"), 400
    if user_exist(username):
        return error("Username is already taken"), 400
    # Creates a new user
    auth.signup(username.lower(), digest, name)

    result, token, id = auth.get_token(username.lower(), digest)
    if result:
        return {"token" : token, "user-id" : id}, 200
    else:
        return {"error" : "Username/password is incorrect."}, 401 # Unauthorized