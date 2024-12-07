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
    
    Can update : description, birth_date, name
    birth_date needs to be formatted using the iso format.
    """
    rights = get_rights(token)
    if rights is GuestRight:
        return "You need to be logged in to update your profile", 401
    keys = list(map(lambda x : x.lower(), fields.keys()))
    print(keys)
    print(fields.items)

    if "profile-banner-color" in keys:
        color = fields["profile-banner-color"]
        color_is_valid = True
        if len(color) == 6:
            for c in color:
                if not (c.lower() in "1234567890abcdef"):
                    color_is_valid = False
        else:
            color_is_valid = False
        if color_is_valid:
            rights.associated_user.profile_banner_color = fields["profile-banner-color"]
        else:
            return "The hex color code you submitted is invalid", 400
    if "birth-date" in keys:
        print("birth")
        print(fields["birth-date"])
        rights.associated_user.birth_date = datetime.datetime.fromisoformat(fields["birth-date"])
    if "description" in keys:
        print(fields["description"])
        rights.associated_user.description = fields["description"]
    if "name" in keys:
        rights.associated_user.name = fields["name"]

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
        return f"Unknown user : {username}", 400
    else:
        return f"storage/profile_picture/{user[0].id}.jpg", 200