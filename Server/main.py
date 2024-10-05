from werkzeug.exceptions import HTTPException
from flask import Flask, json, request
from flask_cors import CORS

app = Flask("twixer" )
CORS(app)
import api.auth_route
import api.action_route
import api.browsing_route
import api.profile_route
import api.search_history_route


@app.errorhandler(HTTPException)
def handle_exception(e):
    """Return JSON instead of HTML for HTTP errors."""
    # start with the correct headers and status code from the error
    response = e.get_response()
    # replace the body with JSON
    response.data = json.dumps({
        "code": e.code,
        "error": e.name,
        "description": e.description,
    })
    response.content_type = "application/json"
    return response


if __name__ == '__main__':
   app.run(port=5000, host="0.0.0.0")

