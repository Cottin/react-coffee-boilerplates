{URL_SET_QUERY} = require '../constants/ActionTypes'
{assoc} = require 'ramda' #auto_require:ramda
{cc, maxIn} = require 'ramda-extras'

initialState = {query: {}}

url = (state = initialState, action) ->
	switch action.type
		when URL_SET_QUERY
			assoc 'query', action.query, state
		else
			state

module.exports = url
