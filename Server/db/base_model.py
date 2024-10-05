from peewee import *

datab = SqliteDatabase("storage/dbvers1.db")

class BaseModel(Model):
    class Meta:
        database = datab