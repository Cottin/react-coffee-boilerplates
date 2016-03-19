{PropTypes: {array, shape, func}} = React = require 'react'
{connect} = require 'react-redux'
{bindActionCreators} = require 'redux'
{map, type} = require 'ramda' #auto_require:ramda
{div, input, br} = React.DOM
actions = require '../actions'
{sortedTodos} = require '../base/selectors'

TodoView = React.createFactory require './TodoView'

MainSection = React.createClass
	displayName: 'MainSection'

	propTypes:
		todos: array
		actions: shape
			addTodo: func

	render: ->
		{todos} = @props
		div {},
			div {}, 'Todos:'
			br()
			input {type: 'text', onKeyPress: @keyPress}
			map @renderTodo, (todos || [])

	renderTodo: (todo) ->
		TodoView {todo, key: todo.id}

	keyPress: (e) ->
		if e.key == 'Enter'
			@props.actions.addTodo(e.currentTarget.value)

# stateToProps = (state) -> {todos: state.todos}
stateToProps = (state) -> sortedTodos
dispatchToProps = (dispatch) ->
	{actions: bindActionCreators(actions, dispatch)}

MainSection_default = connect(stateToProps, dispatchToProps)(MainSection)

module.exports = {MainSection, MainSection_default}
