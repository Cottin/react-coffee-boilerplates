React = require 'react'
Radium = require 'radium'
{arrayOf, shape, int, string, bool} = React.PropTypes
{div, h1} = React.DOM
{Link} = require('yun').ThemeMaterialDesign
{isNil, map, props} = require 'ramda' #auto_require:ramda

{uiHelpers: {connect, build}} = require '../base/app'
s = require './style/TodoView.style'

TodoView = Radium React.createClass 
	displayName: 'TodoView'

	propTypes:
		todos: arrayOf shape
			id: int
			text: string
			isCompleted: bool

	render: ->
		console.log 'props', @props
		{todos} = @props
		console.log 'todos', todos
		if isNil todos
			return div {}, 'Loading...'

		div {style: s.container},
			map @renderTodo, todos

	renderTodo: (todo) ->
		div {key: todo.id},
			div {}, todo.text


TodoView_default = connect TodoView, 'TodoView_default', 'TodoView_'

module.exports = {TodoView_default}
