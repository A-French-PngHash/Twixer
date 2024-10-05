import db.base_model
import db.user
from peewee import *

class Connection(db.base_model.BaseModel):
    user = ForeignKeyField(db.user.User)
    token = CharField(unique=True)
    expired = BooleanField(default=False)
    delivery_date = IntegerField()
    