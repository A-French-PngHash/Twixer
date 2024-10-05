from datetime import datetime
import time
from db.search import Search
from db.user import User
from logic.rights import GuestRight, Right, get_rights
from logic.utils import need_login


@need_login
def add_search(token:str, content:str, rights : Right):
    Search.create(user=rights.associated_user, content=content, date=time.time())
    return "", 200

@need_login
def get_recent_search(token:str, limit : int, rights:Right):
    searches = (Search
                .select(Search.content, Search.date, User.id)

                .join(User)
                .where(Search.user_id == rights.associated_user.id)
                .where(Search.date >= time.time() - 3600 * 24 * 7)
                .where(Search.deleted == False)
                .limit(limit)
                .order_by(Search.date.desc())
                .dicts()
                )
    return list(searches), 200

@need_login
def delete_recent_search(token : str, rights : Right):
    res = (Search

     .update({Search.deleted: True})
     .where(Search.deleted == False)
     .where(Search.user_id == rights.associated_user.id))
    res.execute()
    return "", 200