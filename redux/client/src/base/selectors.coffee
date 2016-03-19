{createSelector} = require 'reselect'
{compose, prop, sortBy, toLower} = require 'ramda' #auto_require:ramda


todoSelector = (state) ->
	state.todos

sortedTodos = createSelector todoSelector, (todos) ->
	{todos: sortBy(compose(toLower, prop('text')), todos)}

module.exports = {sortedTodos}

