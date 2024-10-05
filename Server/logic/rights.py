from typing import Protocol
from db.user import *
from db.connection import *

class Right(Protocol):

    rights : int
    associated_user: User = None

    def has_full_access_for(self,username) -> bool:
        pass


class GuestRight(Right):	
    rights = 0

    def has_full_access_for(self,username):
        return False

class UserRight(Right):
    rights = 1


    def __init__(self, associated_user):
        self.associated_user = associated_user

    def has_full_access_for(self,username):
        if self.associated_user.username == username:
            return True
        else:
            return False

class AdminRight(Right):
    rights = 2

    def __init__(self, associated_user):
        self.associated_user = associated_user

    def has_full_access_for(self,username):
        return True


def get_rights(token = None) -> Right:
    """
    Returns the rights that are available for the token given (may be null).
    """
    if token:
        users = (User
            .select()
            .join(Connection)
            .where(Connection.token.in_([token]))
            .where(Connection.expired == False)
            )
        if len(users) == 0:
            print("No active connection for this token")
            return GuestRight()
        if len(users) >= 2:
            print(f"WARNING : Multiple connection for token {token}. Taking the first one retrieved.")
        if users[0].rights == 2: # admin
            return AdminRight(associated_user=users[0])
        else:
            return UserRight(associated_user=users[0])
    else:
        return GuestRight()
