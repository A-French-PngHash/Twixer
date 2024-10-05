import datetime
from db.user import User
from logic.rights import GuestRight, get_rights
from PIL import Image
from io import StringIO

from logic import utils
from logic.search_history import need_login
def update_profile(token : str, fields : dict, rights = None):
    """
    Update the given fields for the profile associated with the token.
    
    Can update : description, birth_date
    birth_date needs to be formatted using the iso format.
    """
    rights = get_rights(token)
    if rights is GuestRight:
        return "You need to be logged in to update your profile", 401
    keys = list(map(lambda x : x.lower(), fields.keys()))
    print(keys)
    if "birth-date" in keys:
        rights.associated_user.join_date = datetime.datetime.fromisoformat(fields["birth_date"])
    if "description" in keys:
        print("modifying")
        rights.associated_user.description = fields["description"]
    rights.associated_user.save()
    return "", 200

@need_login
def update_profile_picture(token : str, file, rights = None):
    im = Image.open(file)
    im : Image = utils.resize_image(im, 200)
    im.save(f"storage/profile_picture/{rights.associated_user.id}.jpg")
    return "", 200
    
def get_profile_picture_path(username : str):
    user = (User
            .select()
            .where(User.username == username))
    if len(user) == 0:
        return "Unknown user", 400
    else:
        return f"storage/profile_picture/{user[0].id}.jpg", 200