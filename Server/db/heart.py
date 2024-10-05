from peewee import *
import db.base_model
from db.tweet import Tweet


class Heart(db.base_model.BaseModel):
    author = ForeignKeyField(db.user.User)

    tweet = ForeignKeyField(Tweet)
    date = TimestampField()