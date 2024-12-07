"""
All types of actions that can be done (tweeting, liking, deleting...)
"""
from db.tweet import Tweet
from db.heart import Heart
from db.follow import Follow
from logic.rights import *
import time

from logic.utils import need_login


def new_reply_to(tweet):
    tweet.number_of_response += 1
    tweet.save()
    if tweet.replying_to:
        new_reply_to(tweet.replying_to)

def reply_deleted_to(tweet):
    tweet.number_of_response -= 1
    tweet.save()
    if tweet.replying_to:
        reply_deleted_to(tweet.replying_to)

@need_login
def tweet(token : str, content : str, replies_to : int = None, rights = None) -> (int, str):
    """
    Creates a tweet with the account of the user associated with the connection provided (token).
    
    - token : Connection
    - content : Must be under 260 characters.
    - replies_to : id of the tweet it is replying to (may be None).

    Returns an http status code and eventually an error message.
    """
    if len(content) > 260:
        return 413, "Tweet length must be under 260 characters"
    tweet = None
    if replies_to:
        tweets = (Tweet
            .select()
            .where(Tweet.id == replies_to)
            )
        if len(tweets) == 0 or tweets[0].deleted:
            return 400, "The tweet you are trying to reply to does not exist."
        tweet = tweets[0]
        new_reply_to(tweet)
    print(time.time())
    Tweet.create(author=rights.associated_user,replying_to = tweet, content=content, post_date=time.time())
    return 200, ""




def delete_tweet(token : str, tweet_id : int) -> (str, int):
    rights = get_rights(token)
    tweet = (Tweet 
        .select()
        .where(Tweet.id == tweet_id))
    if len(tweet) == 0:
        return "Trying to delete non existing tweet.", 400
    tweet_author = (User
        .select()
        .join(Tweet)
        .where(Tweet.id == tweet_id))
    if len(tweet_author) == 0:
        return "INTERNAL ERROR : Tweet with non existing author", 500

    if rights.has_full_access_for(tweet_author[0].username):
        tweet[0].deleted = True
        tweet[0].save()
        if tweet[0].replying_to:
            reply_deleted_to(tweet[0].replying_to)
        return "", 200
    else:
        return "You are not allowed to delete this tweet", 403

@need_login
def like(token:str, tweet_id : int, rights = None):
    tweet = (Tweet
        .select()
        .where(Tweet.id == tweet_id))
    if len(tweet) == 0 or tweet[0].deleted:
        return "Non existing tweet", 400

    hearts = (Heart
        .select()
        .where((Heart.tweet == tweet[0]) & (Heart.author_id == rights.associated_user.id)))
    if len(hearts) == 0:
        Heart.create(tweet=tweet[0], date=time.time(), author=rights.associated_user)
        return {"like_status" : 1}, 200
    else:
        hearts[0].delete_instance()
        return {"like_status" : 0}, 200

@need_login
def retweet(token:str, tweet_id : int, content : str, rights):
    tweet = (Tweet
        .select()
        .where(Tweet.id == tweet_id))
    if len(tweet) == 0 or tweet[0].deleted:
        return "Non existing tweet", 400

    if tweet[0].author == rights.associated_user:
        return "You cannot retweet your own tweet", 403

    retweets = (Tweet
        .select()
        .where((Tweet.retweet_id == tweet_id) & (Tweet.author_id == rights.associated_user.id)))

    if len(retweets) == 0:
        Tweet.create(tweet=tweet[0], author=rights.associated_user, retweet_id = tweet_id, content = "" if content == None else content, post_date=time.time())
        return {"retweet_status" : 1}, 200
    else:
        return "You already retweeted this tweet", 403


@need_login
def follow(token:str, user_to_follow_username : str, rights = None):

    user_to_follow = (User
                      .select()
                      .where(User.username == user_to_follow_username))
    if len(user_to_follow) == 0:
        return "Unknown user", 400
    
    existing = (Follow
                .select()
                .where(Follow.followed == user_to_follow[0])
                .where(Follow.following == rights.associated_user))
    if len(existing) == 0:
        Follow.create(
            followed = user_to_follow[0], 
            following = rights.associated_user, 
            follow_date = time.time()
            )
    else:
        existing[0].delete_instance()
    return "", 200