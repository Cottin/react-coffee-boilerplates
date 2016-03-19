types = require '../constants/ActionTypes'

module.exports =
	addTodo: (text) -> {type: types.ADD_TODO, text}
	setQuery: (query) -> {type: types.URL_SET_QUERY, query}
