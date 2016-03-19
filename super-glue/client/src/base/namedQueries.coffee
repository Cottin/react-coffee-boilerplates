namedQueries =
	# URL
	URL_GO_LOGIN: -> {url__page: {$set: 'login'}}
	URL_GO_HOME: -> {url__page: {$set: ''}}
	URL_GO_TODO: -> {url__page: {$set: 'todo'}}

	# AUTH
	AUTH_LOGIN_FAKE: -> {auth: {$set: {username: 'Victor'}}}

	# DATA - reading
	TODOS_ALL: -> {todos: {$get: {}}}

module.exports = namedQueries
