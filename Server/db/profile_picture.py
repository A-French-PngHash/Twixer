from db.user import User
import db.base_model
from peewee import *

class ProfilePicture(db.base_model.BaseModel):
    """
    The profile picture is stored in storage/profile_picture under the file name {user_id}.jpg
    """
    user = ForeignKeyField(User)
