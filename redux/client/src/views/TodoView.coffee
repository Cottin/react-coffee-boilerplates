{PropTypes: {shape, number, string, bool}} = React = require 'react'
{div, span} = React.DOM
yun = require 'yun'
{build} = yun.react
{Link} = yun.ThemeMaterialDesign


TodoView = React.createClass
	displayName: 'TodoView'

	propTypes:
		todo: shape
			id: number
			text: string
			completed: bool

	render: ->
		{todo} = @props
		div {},
			span {}, todo.text
			span {}, ' '
			span {}, if todo.completed then '[X]' else '[ ]'
			build Link, {to: {test:123}}, 'Click me'


module.exports = TodoView
