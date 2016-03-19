React = require 'react'
Radium = require 'radium'
{func} = React.PropTypes
{div, h1} = React.DOM
{Link} = require('yun').ThemeMaterialDesign

{uiHelpers: {connect, build}} = require '../base/app'
s = require './style/LoginView.style'

LoginView = Radium React.createClass 
	displayName: 'LoginView'

	propTypes:
		login: func

	render: ->
		{login} = @props
		div {style: s.container},
			h1 {}, 'Login please'
			build Link, {
				href: 'javascript:void(0)',
				onClick: (e) ->
					debugger
					login()}, 'Logga in'


LoginView_default = connect LoginView, 'LoginView_default',
(data, actions, liftedData) ->
	login: actions.auth.loginWithFake

module.exports = {LoginView_default}
