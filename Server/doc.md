## Dependencies

- peewee : for the database
- flask : for implementing the api endpoint

## Login

The hash algorithm used is MD5. The username:password must be hashed one time client side before being sending the hex digest. Upon receival on the server, the username:clienthash is hashed one more time.

## Rights

There are three types of privileges available : 

- 0 : Guest, can only access public information/action
- 1 : User, can acccess public and user related(only for a specific user) information/action
- 2 : Admin, can access everything

# API

## Auth

### GET /login
Logs a user in by returning a token.

Parameters in headers:
	- username
	- digest (see login section for how to compute it)


### POST /signup
Creates a user and returns a connection token.

Parameters in headers:
	- username
	- digest (see login section)

## Common actions

### POST /tweet
Creates a new tweet.

Parameters in headers:
	- token : for authentication
	- content (must be under 260 characters of length)
	- replies-to : id of the tweet it is replying to (-1 otherwise)

### DELETE /tweet
Deletes a tweet.

Parameters in headers:
	- token : for authentication.
	- tweet-id : Id of the tweet to delete.

### POST /retweet
Retweets. The author of a tweet is not allowed to retweet his own tweet.

Parameters in headers : 
	- token : for authentication
	- tweet-id : tweet to retweet
	- content : Content of the retweet

### POST /like
Likes a tweet. If the tweet is already liked, deletes the like.

Parameters in headers : 
	- token : for authentication
	- tweet-id : tweet to like

### POST /follow
Follows a user.
Parameters in headers : 
	- token : for authentication
	- user-to-follow

## Browsing


### GET /search
Search for a specific string among users and tweet. Users are sorted according to number of followers. Relevant tweets are ordered according to the order_tweets-by field. Limits at 20 users and 50 tweets.

Parameters in headers:
	- search-string
	- order-by : ["date", "popularity", "number_of_response"]
	- user-limit
	- user-offset
	- tweet-limit
	- tweet-offset

returns : 
{"users":[], "tweets":[]}

### GET /response
Gets the tweets that respond to the given tweet.

Parameters in headers:
	- tweet-id
	- limit
	- offset
	- order-by: ["date", "popularity", "number_of_response"]

{"tweets" : []}

### GET /home
Gets the tweets on the feed.

Parameters in headers:
	- token
	- limit
	- offset

{"tweets" : []}

### GET /tweet
Gets the requested tweet.

Parameters in headers:
	- tweet-id

{"tweet" : {}}

## Profile Browsing And Updating

### GET /profile
Return data on the given user as well as tweets ordered by date (most recent first)

Parameters in headers:
	- username
	- length : Number of tweet to retrieve.
	- offset
	- order-by : ["date", "popularity", "number_of_response"]

Returns :
{
	"username": ""
	"following":
	"follower":
	"join_date" : iso 8601 format,
	"birth_date" : iso 8601 format (field may not be there if the user did not set a birth_date)
	description : ""
	"tweets": []
}

### POST /profile
Updates the profile data for the user.

Parameters in headers :
	- token

Optionnal parameters in headers : 
	- description : to update the user's description.
	- birth-date  : to update the user's birht date. (use iso format)

Optionnal file (in body):
	- profile-picture : if provided updates the user's profile picture. Will resize and truncate the image if necessary to make it 200x200.

### GET /profile/picture
Gets the profile picture of the user

Parameters in headers:
	- username

Returns the profile picture in body as file under the key profile-picture. If the profile picture does not exist, returns an empty response using code 200

## Search History

### GET /search/history
Gets recent searches for the user.

Parameters in headers:
	- token

Returns {"searches" : []}

### POST /search/history
Add a new search entry.

Parameters in headers:
	- token
	- content

### DELETE /search/history
Delete all recent searches.

Parameters in headers:
	- token