import datetime
from unittest import result
from db.profile_picture import ProfilePicture
from db.tweet import Tweet
from db.user import User
from db.follow import Follow
from logic.rights import *
from logic.utils import need_login, optional_login, tweet_select
"""
Calls related to browsing the platform (viewing the feed, a user profile...)
"""

def _order_tweet_by(order_by):
    # Default ordering is by date
    ordering = Tweet.post_date
    if order_by == "popularity":
        ordering = Tweet.like_count
    elif order_by == "number_of_response":
        ordering = Tweet.number_of_response
    return ordering

@optional_login
def view_tweets_on_profile(username : str, content_length : int, offset : int, order_by, token = None, rights : Right = None):
    """
    Returns a list of tweets made by the given user. Sorts the data according to order_by.
    
    """
    allowed_orders = ["date", "popularity", "number_of_response"]
    
    tweets = (tweet_select(None if rights == None else rights.associated_user.id)
        .where(User.username == username)

        .dicts()
        .limit(content_length)
        .offset(offset)
        .order_by(_order_tweet_by(order_by).desc()))


    return list(tweets), 200

def get_profile_picture(username):
    exist = (ProfilePicture
             .select(User.id)
             .join(User)
             .where(User.username == username))
    if len(exist) == 0:
        return None, 200
    else:
        return open(f"storage/profile_picture/{exist[0].user_id}.jpg"), 200

@optional_login
def get_profile_data(username, token = None, rights : Right = None):
    arguments = [
        User.id, User.username,
                User.name,
                User.profile_banner_color, 
                User.join_date,
                User.description,
                User.birth_date]
    if rights != None:
        subquery = (Follow
                    .select()
                    .where(Follow.followed_id == User.id)
                    .where(Follow.following == rights.associated_user.id))
        arguments.append(fn.exists(subquery).alias("is_following"))
    users = (User
        .select(*arguments)
        .where(User.username == username)
    )
    if len(users) == 0:
        return "No user with such username", 400
    user = users[0]
    # TODO : Optimize this query to make a single one (using subqueries)
    number_of_following = (Follow
                .select()
                .where(Follow.following_id == user.id)
                .count())
    print(number_of_following)
    number_of_follower = (Follow
                .select()
                .where(Follow.followed_id == user.id)
                .count())
    result_dic =  {
        "id" : user.id,
        "username": user.username.lower(),
        "name":user.name,
        "profile_banner_color":user.profile_banner_color,
        "following":number_of_following,
        "follower":number_of_follower,
        "join_date":user.join_date.isoformat(),
        "description" : user.description,
        }
    print(result_dic)
    if rights != None:
        result_dic["is_following"] = user.is_following == 1

    if user.birth_date != None :
        result_dic["birth_date"] = user.birth_date.isoformat() 
    return result_dic, 200

def _prepare_search_string(search_string : str):
    search_sql = "%" + "%".join(list(search_string)) + "%"
    return search_sql

def search_user(search_string, limit, offset):
    """
    Search for a user using the given search string.

    If succeeds, returns a list of dict : [{"username":},] and status code 200.
    """
    if len(search_string) > 100:
        return "Search string too long (over 100 characters)", 400
    # POSSIBLE SQL INJECTION THREAT
    users = (User
             .select(User.username, User.description, User.name)
             .where(User.username ** _prepare_search_string(search_string))
             .limit(limit)
             .offset(offset)
             .dicts()
             )
    # case-INsensitive search
    return list(users), 200

@optional_login
def search_tweet(search_string, order_by, limit, offset, token = None, rights : Right = None):

    if len(search_string) > 100:
        return "Search string too long (over 100 characters)", 400
    
    tweets = (tweet_select(None if rights == None else rights.associated_user.id)
              .where(Tweet.content ** _prepare_search_string(search_string))
              .limit(limit)
              .order_by(_order_tweet_by(order_by).desc())
              .offset(offset)
              .dicts())
    return list(tweets), 200

@optional_login
def get_response_to(tweet_id : int, limit : int, offset : int, order_by:str, token = None, rights : Right = None):
    tweet = (Tweet
             .select()
             .where(Tweet.id == tweet_id)
        )
    if len(tweet) == 0:
        return "Non existing tweet", 400
    tweet = tweet[0]
    responses = (tweet_select(None if rights == None else rights.associated_user.id)
                 .where(Tweet.replying_to == tweet)
                 .order_by(_order_tweet_by(order_by).desc())
                 .limit(limit)
                 .offset(offset)
                 .dicts()
        )
    return list(responses), 200

@need_login
def get_homepage_tweets(token:str, limit : int, offset : int, rights : Right = None):
    """
    The tweets are sorted according to date. Ideally, here comes an advanced algorithm. This is the piece of code that distinguish a good social media from a bad one; its feed algorithm.

    Algorithm:
    sort by date published the tweets/retweets posted by the accounts followed by the user making the query.
    """
    feed = (tweet_select(rights.associated_user.id)
            .join(Follow, on=(Follow.followed_id == User.id))
            .where(Follow.following_id == rights.associated_user.id)
            .order_by(Tweet.post_date.desc())
            .limit(limit)
            .offset(offset)

            .dicts()
            )
    return list(feed), 200


@optional_login
def get_tweet_by_id(tweet_id : int, token = None, rights : Right = None):
    tweet = (tweet_select(None if rights == None else rights.associated_user.id)
             .where(Tweet.id == tweet_id)
             .dicts())
    if len(tweet) == 0:
        return "Unknown tweet", 400
    return tweet[0], 200


def get_followers(user_id, limit:int, offset:int):
    users = (User
             .select(User.username, User.description)
             .join(Follow, on = (Follow.following_id == User.id))
             .where(Follow.followed_id == user_id)
             .limit(limit)
             .offset(offset)
             .dicts()
             )
    return list(users), 200

# followed et following

def get_following(user_id, limit:int, offset:int):
    users = (User
             .select(User.username, User.description)
             .join(Follow, on = (Follow.followed_id == User.id))
             .where(Follow.following_id == user_id)
             .limit(limit)
             .offset(offset)
             .dicts()
             )
    return list(users),200


