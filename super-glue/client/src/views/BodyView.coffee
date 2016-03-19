React = require 'react'
{string} = React.PropTypes
{div, h1} = React.DOM
Radium = require 'radium'
s = require './style/BodyView.style'
{Link} = require('yun').ThemeMaterialDesign
{always} = require 'ramda' #auto_require:ramda

{uiHelpers: {connect, build}} = require('../base/app')
{LoginView_default} = require './LoginView'
{TodoView_default} = require './TodoView'

BodyView = Radium React.createClass
	displayName: 'BodyView'

	propTypes:
		page: string

	render: ->
		{page} = @props
		console.log 'page', page
		div {style: s.body},
			# MyThemedComponent {}
			# LinkFactory {},
			# 	span {}, 'Ett'
			# 	span {}, 'Två'
			# ThemedLink {}, 'Themed link er'
			switch page
				when 'login' then build LoginView_default
				when 'todo' then build TodoView_default
				when null || undefined then @renderLoading()
				else @renderNotFound()

	renderLoading: ->
		div {style: s.fullPage},
			h1 {}, 'Laddar...'

	renderNotFound: ->
		div {style: s.fullPage},
			h1 {}, '404 - Sidan finns inte'
			# build Link, {to: always({})}, 'Gå till startsidan'

BodyView_default = connect BodyView, 'BodyView_default',
(data, actions, liftedData) ->
	page: data.url.query.page

module.exports = {BodyView_default}
