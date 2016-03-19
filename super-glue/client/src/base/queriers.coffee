{__, isNil} = require 'ramda' #auto_require:ramda
___ = require './namedQueries'

todos = (auth) ->
	if !isNil auth
		___.TODOS_ALL()

module.exports = {todos}

