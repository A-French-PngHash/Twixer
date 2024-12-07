import db.base_model
from peewee import *

class User(db.base_model.BaseModel):
    username = CharField(unique=True)
    name = CharField()
    profile_banner_color = CharField(default="1DA1F2")
    hashpass = CharField()
    rights = IntegerField() # 1 or 2 (cannot be 0)
    follower_count = IntegerField(default=0)
    description = TextField(default="")
    birth_date = DateTimeField(null=True)
    join_date = DateTimeField()


    @classmethod
    def create_table(cls, fail_silently=False):
        """Create this table in the underlying database."""
        super(User, cls).create_table(fail_silently)
        drop_trigger_follow= """
        DROP TRIGGER IF EXISTS follow_trigger;
        """
        drop_trigger_removed="""
        DROP TRIGGER IF EXISTS follow_removed_trigger;"""
        new_follow_trigger = """
        CREATE TRIGGER follow_trigger 
        AFTER INSERT ON Follow 
        BEGIN UPDATE User SET follower_count = follower_count + 1 
        WHERE NEW.followed_id = User.id; END
        """
        

        follow_removed_trigger = """

        CREATE TRIGGER follow_removed_trigger 
        AFTER DELETE ON Follow 
        BEGIN UPDATE User SET follower_count = follower_count - 1 
        WHERE OLD.followed_id = User.id; END
        """
        cls._meta.database.execute_sql(drop_trigger_follow)
        cls._meta.database.execute_sql(drop_trigger_removed)
        cls._meta.database.execute_sql(follow_removed_trigger)
        cls._meta.database.execute_sql(new_follow_trigger)    
