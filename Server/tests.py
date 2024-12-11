from db.retweet import Retweet
from db.base_model import *
from db.search import Search
from db.user import *
from db.tweet import Tweet
from db.heart import Heart
from db.profile_picture import ProfilePicture
from logic import actions
import hashlib
from db.follow import Follow
from db.connection import *
import time
from logic import browsing
from playhouse.shortcuts import model_to_dict, dict_to_model

from logic.auth import signup
datab.connect()


datab.drop_tables([Tweet, User, Connection, Follow, Search, Retweet, Heart])
datab.create_tables([Follow])
datab.create_tables([Heart])

datab.create_tables([Tweet, User, Connection, Search])
datab.create_tables([Retweet])
hash1 = hashlib.md5(f"titouan:password".encode("utf-8")).hexdigest()
hash2 = hashlib.md5(f"john:password".encode("utf-8")).hexdigest()
hash3 = hashlib.md5(f"francis:password".encode("utf-8")).hexdigest()

titouan = signup("titouan", hash1, "Titouan Thomson")
tymeo = signup("john", hash2, "John Dupuy")
elouan = signup("francis", hash3, "Francis Joule")
elouan.description = "Bonjour, moi c'est elouan"
tymeo.description = " Lorem ipsum dolor sit amet, consectetur adipiscing elit. Ut urna dui, sollicitudin sed interdum sed, gravida eu est. Donec porta arcu at sollicitudin sodales. Nulla vulputate enim vulputate metus egestas mollis. Vivamus in bibendum lacus. Quisque vel condimentum turpis. Quisque sed mauris quis lorem gravida sodales in sed massa. Integer eget purus orci. Morbi at pulvinar leo, eu dignissim metus. Nullam vel magna eget velit aliquet imperdiet. Vivamus vel fermentum ex, sed tempus mauris. Pellentesque id vulputate risus. "
elouan.save()
tymeo.save()

Connection.create(user=titouan, token="titouan", delivery_date=time.time())
Connection.create(user=tymeo, token="tymeo", delivery_date=time.time())
Connection.create(user=elouan, token="elouan", delivery_date=time.time())



tweet1 = Tweet.create(author=titouan, content=" Maître Corbeau, sur un arbre perché,", post_date=time.time())
Tweet.create(author = elouan, content = "Et bonjour, Monsieur du Corbeau.", post_date = time.time(), retweet_id = tweet1.id)
tweet2 = Tweet.create(author=tymeo, content=" Tenait en son bec un fromage.", post_date=time.time(), retweet_id=tweet1.id)
tweet3 = Tweet.create(author=elouan, content="Maître Renard, par l'odeur alléché,", post_date=time.time(), replying_to=tweet2)
Tweet.create(author=elouan, content=" Lui tint à peu près ce langage :", post_date=time.time())

for i in range(50):
	Tweet.create(author=titouan, content=str(i), post_date=time.time())
actions.follow(token="titouan", user_to_follow_username="tymeo")
actions.follow(token="titouan", user_to_follow_username="elouan")

actions.like(token="titouan", tweet_id=tweet3.id)


#datab.create_tables([Follow])

print(browsing.view_tweets_on_profile("elouan", 4, 0, "date"))
print(browsing.get_profile_data("elouan"))
print("homepage : ")
print(browsing.get_homepage_tweets("tituan", 3, 0))
print(browsing.get_tweet_by_id(1))

