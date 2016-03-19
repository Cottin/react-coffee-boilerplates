{__} = require 'ramda' #auto_require:ramda
{cc} = require 'ramda-extras'
moment = require 'moment'
lo = require 'lodash'
___ = require './namedQueries'

url = (auth, url__query__page) ->
	# redirect to login if no session is active
	if !auth then return ___.URL_GO_LOGIN()

	# if seeing login page while already logged in, redirect to '/'
	if url__query__page == 'login' then return ___.URL_GO_HOME()
	# if logged in but no active page, go to week page by default
	else if !url__query__page then return ___.URL_GO_TODO()

module.exports = {url}
