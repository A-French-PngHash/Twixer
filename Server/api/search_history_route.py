from api.api_utils import *
from logic import search_history
from __main__ import app

@app.route("/search/history", methods=["POST"])
@get_headers(["token", "content"])
def record_search(output):
    res, code = search_history.add_search(output[0], output[1])
    if code != 200:
        return error(res), code
    return "", 200

@app.route("/search/history", methods = ["GET"])
@get_headers(["token"])
def get_recent_searches(output):
    """
    Return the 30 most recent search
    """
    res, code = search_history.get_recent_search(output[0], 30)
    if code != 200:
        return error(res), code
    return {"searches" : res}, 200

@app.route("/search/history", methods = ["DELETE"])
@get_headers(["token"])
def delete_recent_searches(output):
    """
    Return the 30 most recent search
    """
    res, code = search_history.delete_recent_search(output[0])
    if code != 200:
        return error(res), code
    return "", 200