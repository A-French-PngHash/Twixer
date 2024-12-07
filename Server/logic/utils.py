from db.heart import Heart
from db.retweet import Retweet
from db.tweet import Tweet
from db.user import User
import PIL.Image

from logic.rights import GuestRight, get_rights
from peewee import Case, fn, JOIN


def user_exist(username:str):
    users = (User
        .select()
        .where(User.username == username))
    return len(users) > 0


def tweet_select(author_id=None):
    """
    Selects the rights field for the tweet object.

    - author_id : The id of the author executing the request.

    WARNING : Already joins the user table.
    """
    subqueryHeart = (Heart 
        .select(Heart.id)
        .where(author_id == Heart.author_id)
        .where(Tweet.id == Heart.tweet_id)
    )
    subqueryRetweet = (Retweet
                       .select(Retweet.id)
                       .where(Retweet.author_id == author_id)
                       .where(Tweet.id == Retweet.baseTweet_id))
    arguments = [User.username, 
                    Tweet.id, 
                    Tweet.author, 
                    Tweet.replying_to, 
                    Tweet.content, 
                    Tweet.post_date, 
                    Tweet.number_of_response, 
                    Tweet.like_count, 
                    Tweet.retweet_id,]
    if author_id != None:
        arguments.append(fn.exists(subqueryHeart).alias("is_liked"))
        arguments.append(fn.exists(subqueryRetweet).alias("is_retweeted"))
    returning = (Tweet
            .select(*arguments)
            .join(User)
            )
    return returning
        


def resize_image(image: PIL.Image, length: int) -> PIL.Image:
    """
    Resize an image to a square. Can make an image bigger to make it fit or smaller if it doesn't fit. It also crops
    part of the image.

    :param image: Image to resize.
    :param length: Width and height of the output image.
    :return: Return the resized image.
    """

    """
    Resizing strategy : 
     1) We resize the smallest side to the desired dimension (e.g. 1080)
     2) We crop the other side so as to make it fit with the same length as the smallest side (e.g. 1080)
    """
    if image.size[0] < image.size[1]:
        # The image is in portrait mode. Height is bigger than width.

        # This makes the width fit the LENGTH in pixels while conserving the ratio.
        resized_image = image.resize((length, int(image.size[1] * (length / image.size[0]))))

        # Amount of pixel to lose in total on the height of the image.
        required_loss = (resized_image.size[1] - length)

        # Crop the height of the image so as to keep the center part.
        resized_image = resized_image.crop(
            box=(0, required_loss / 2, length, resized_image.size[1] - required_loss / 2))

        # We now have a 1080x1080 pixels image.
        return resized_image
    else:
        # The image is in landscape mode or already squared. The width is bigger than the heihgt.

        # This makes the height fit the LENGTH in pixels while conserving the ratio.
        resized_image = image.resize((int(image.size[0] * (length / image.size[1])), length))

        # Amount of pixel to lose in total on the width of the image.
        required_loss = resized_image.size[0] - length

        # Crop the width of the image so as to keep length pixels of the center part.
        resized_image = resized_image.crop(
            box=(required_loss / 2, 0, resized_image.size[0] - required_loss / 2, length))

        # We now have a lengthxlength pixels image.
        return resized_image

def need_login(func):
    """
    For this decorator to work, the token must be the first positional argument.

    Pass the `right` parameter to the function.
    """
    def wrapper(*args, **kwargs):
        if len(args) == 0:
            rights = get_rights(kwargs["token"])
        else:
            rights = get_rights(args[0])
        if isinstance(rights ,GuestRight):
            return "You need to be logged in.", 401
        return func(*args, **kwargs, rights = rights)

    wrapper.__name__ = func.__name__
    return wrapper

def optional_login(func):
    """
    For this decorator to work, the token must be a NAMED argument (kwarg).

    Pass the `right` parameter to the function.
    WARNING: Token must be passed as a kwarg to the function otherwise `optional_login` won't find it.
    """
    def wrapper(*args, **kwargs):
        print(kwargs)
        print(args)
        rights = None
        if "token" in kwargs and kwargs["token"] != None:
            print("token is in, getting rgiths")
            rights = get_rights(kwargs["token"])
        return func(*args, **kwargs, rights = rights)

    wrapper.__name__ = func.__name__
    return wrapper