from peewee import *
import db.base_model

import db.user, db.tweet

class Retweet(db.base_model.BaseModel):
    author = ForeignKeyField(db.user.User)
    baseTweet = ForeignKeyField(db.tweet.Tweet)
    retweet = ForeignKeyField(db.tweet.Tweet)


    @classmethod
    def create_table(cls, fail_silently=False):
        super(Retweet, cls).create_table(fail_silently)
        drop_trigger_new_retweet = """
        DROP TRIGGER IF EXISTS retweet_trigger;"""


        new_retweet_trigger = """
        CREATE TRIGGER retweet_trigger 
        AFTER INSERT ON Tweet WHEN NEW.retweet_id IS NOT NULL
     BEGIN INSERT INTO Retweet (author_id, baseTweet_id, retweet_id) VALUES (NEW.author_id, NEW.retweet_id, NEW.id); END
        """
        
        cls._meta.database.execute_sql(drop_trigger_new_retweet)

        cls._meta.database.execute_sql(new_retweet_trigger)