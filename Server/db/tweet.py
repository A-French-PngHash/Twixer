from peewee import *
import db.base_model
import db.user

class Tweet(db.base_model.BaseModel):
    author = ForeignKeyField(db.user.User)
    replying_to = ForeignKeyField('self', null = True)
    content = CharField()
    post_date = IntegerField()
    number_of_response = IntegerField(default=0)
    like_count = IntegerField(default=0)
    deleted = BooleanField(default=False) # Deleting the object from the database would mess up the reply chain.
    retweet_id = IntegerField(null = True) # If this tweet is a retweet, the retweet_id field points to the original tweet.

    @classmethod
    def create_table(cls, fail_silently=False):
        """Create this table in the underlying database."""
        super(Tweet, cls).create_table(fail_silently)
        drop_trigger_like= """
        DROP TRIGGER IF EXISTS like_trigger;
        """
        drop_trigger_removed="""
        DROP TRIGGER IF EXISTS like_removed_trigger;"""
        new_like_trigger = """
        CREATE TRIGGER like_trigger 
        AFTER INSERT ON Heart 
        BEGIN UPDATE Tweet SET like_count = like_count + 1 
        WHERE NEW.tweet_id = Tweet.id; END
        """
        

        like_removed_trigger = """

        CREATE TRIGGER like_removed_trigger 
        AFTER DELETE ON Heart 
        BEGIN UPDATE Tweet SET like_count = like_count - 1 
        WHERE OLD.tweet_id = Tweet.id; END
        """
        cls._meta.database.execute_sql(drop_trigger_like)
        cls._meta.database.execute_sql(drop_trigger_removed)
        cls._meta.database.execute_sql(like_removed_trigger)
        cls._meta.database.execute_sql(new_like_trigger)


