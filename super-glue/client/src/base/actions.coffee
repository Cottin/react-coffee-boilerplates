{__} = require 'ramda' #auto_require:ramda
{cc} = require 'ramda-extras'
___ = require './namedQueries'

ui =
	favorites:
		push: (id) ->
			return ___.UI_FAVORITES_PUSH id

auth =
	loginWithFake: -> ___.AUTH_LOGIN_FAKE()

module.exports = {auth}
