from peewee import *
import db.base_model
from db.user import User

class Search(db.base_model.BaseModel):
    user = ForeignKeyField(User)
    content = TextField()
    date = IntegerField()
    deleted = BooleanField(default=False)