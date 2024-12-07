import datetime
import hashlib
import random
import select
from api.api_utils import error
from db.connection import *
import time
from db.user import User
import logic.browsing

letters = "azertyuiopqsdfghjklmwxcvbn"

def generate_token(length):
    token = ""
    for _ in range(length):
        token += letters[random.randint(0,25)]
    return token

def get_token(username : str, hashe : str):
    """
    Logs the user in by returning a token if the login data is correct. If a connection already exists for this user, it deletes the other connection and creates a new one.

    Returns:
     - a boolean indicating if the login was sucessful
     - the token if the login is sucessful.
     - the user id if the login is sucessful.
    """
    username = username.lower()
    hexdigest = hashlib.md5(f"{username}:{hashe}".encode("utf-8")).hexdigest()
    users = (User
        .select()
        .where(
            User.username == username and User.hashpass == hexdigest))
    if len(users) == 0:
        return False, None, None
    else:
        connections = (Connection
            .select()
            .where(Connection.expired == False and Connection.user == users[0]))
        if len(connections) >= 1:
            # Expires all existing connection
            for i in connections:
                i.expired = True
                i.save()

        # Generates a new connection.
        token = generate_token(20)
        Connection.create(user=users[0], token = token, expired = False, delivery_date=time.time())
        return True, token, users[0].id

def signup(username: str, digest: str, name: str):
    """
    Creates a new user in the database. A user with such username must not already exist.
    """
    hexdigest = hashlib.md5(f"{username}:{digest}".encode("utf-8")).hexdigest()
    usr = User.create(username=username, hashpass = hexdigest, rights=1, join_date=datetime.datetime.now(), name=name)
    data, code = logic.browsing.get_profile_data(username)
    if code != 200:
        return error(data), code
    usr.follower_count = data["follower"]
    return usr
    

    
