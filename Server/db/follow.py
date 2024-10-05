import db.base_model
from peewee import *
from db.user import User


class Follow(db.base_model.BaseModel):
    followed = ForeignKeyField(User)
    following = ForeignKeyField(User)
    follow_date = IntegerField()
    