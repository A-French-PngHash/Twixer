import datetime
from db.profile_picture import ProfilePicture
from db.tweet import Tweet
from db.user import User
from db.follow import Follow
from logic.rights import *
from logic.utils import need_login, tweet_select
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

def view_tweets_on_profile(username : str, content_length : int, offset : int, order_by):
    """
    Returns a list of tweets made by the given user. Sorts the data according to order_by.
    
    """
    allowed_orders = ["date", "popularity", "number_of_response"]
    
    tweets = (tweet_select()
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

def get_profile_data(username):
    users = (User
        .select()
        .where(User.username == username)
    )
    if len(users) == 0:
        return "No user with such username", 400
    user = users[0]
    number_of_following = (Follow
                .select()
                .where(Follow.following == user)
                .count())
    number_of_follower = (Follow
                .select()
                .where(Follow.followed == user)
                .count())
    result_dic =  {
        "username": user.username, 
        "following":number_of_following, 
        "follower":number_of_follower, 
        "join_date":user.join_date.isoformat(),
        "description" : user.description
        }

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
             .select(User.username, User.description)
             .where(User.username ** _prepare_search_string(search_string))
             .limit(limit)
             .offset(offset)
             .dicts()
             )
    # case-INsensitive search
    return list(users), 200

def search_tweet(search_string, order_by, limit, offset):

    if len(search_string) > 100:
        return "Search string too long (over 100 characters)", 400
    
    tweets = (tweet_select()
              .where(Tweet.content ** _prepare_search_string(search_string))
              .limit(limit)
              .order_by(_order_tweet_by(order_by).desc())
              .offset(offset)
              .dicts())
    return list(tweets), 200

def get_response_to(tweet_id : int, limit : int, offset : int, order_by:str):
    tweet = (Tweet
             .select()
             .where(Tweet.id == tweet_id)
        )
    if len(tweet) == 0:
        return "Non existing tweet", 400
    tweet = tweet[0]
    responses = (tweet_select()
                 .where(Tweet.replying_to == tweet)
                 .order_by(_order_tweet_by(order_by).desc())
                 .limit(limit)
                 .offset(offset)
                 .dicts()
        )
    return list(responses), 200

@need_login
def get_homepage_tweets(token:str, limit : int, offset : int, rights = None):
    """
    The tweets are sorted according to date. Ideally, here comes an advanced algorithm. This is the piece of code that distinguish a good social media from a bad one; its feed algorithm.

    Algorithm:
    sort by date published the tweets/retweets posted by the accounts followed by the user making the query.
    """
    feed = (tweet_select()
            .join(Follow, on=(Follow.followed_id == User.id))
            .where(Follow.following_id == rights.associated_user.id)
            .order_by(Tweet.post_date.desc())
            .limit(limit)
            .offset(offset)

            .dicts()
            )
    print(feed)
    return list(feed), 200

def get_tweet_by_id(tweet_id : int):
    tweet = (tweet_select()
             .where(Tweet.id == tweet_id)
             .dicts())
    if len(tweet) == 0:
        return "Unknown tweet", 400
    return tweet[0], 200





