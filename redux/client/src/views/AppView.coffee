React = require 'react'
{div} = React.DOM
yun = require 'yun'
{build} = yun.react
{BodyView_default} = require './BodyView'


AppView = React.createClass
	displayName: 'AppView'

	render: ->
		div {},
			build BodyView_default

module.exports = AppView
