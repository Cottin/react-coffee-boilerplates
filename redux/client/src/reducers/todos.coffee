{ADD_TODO} = require '../constants/ActionTypes'
{append, inc, pluck} = require 'ramda' #auto_require:ramda
{cc, maxIn} = require 'ramda-extras'

initialState = [
	{text: 'Use coffee', completed: false, id: 0}
]

todos = (state = initialState, action) ->
	switch action.type
		when ADD_TODO
			newTodo =
				id: cc inc, maxIn, pluck('id'), state
				completed: false
				text: action.text
			append newTodo, state
		else
			state

module.exports = todos
