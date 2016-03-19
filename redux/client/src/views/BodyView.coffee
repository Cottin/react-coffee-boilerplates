{PropTypes: {object, func, shape}} = React = require 'react'
{div, h1} = React.DOM
{bindActionCreators} = require 'redux'
{connect} = require 'react-redux'
# fbjs: follow discussion here: https://github.com/larrymyers/react-mini-router/issues/46
EventListener = require 'fbjs/lib/EventListener'
yun = require 'yun'
{build} = yun.react
{Link} = yun.ThemeMaterialDesign
{MainSection_default} = require './MainSection'
actions = require '../actions'
{always, isNil} = require 'ramda' #auto_require:ramda

BodyView = React.createClass
	displayName: 'BodyView'

	propTypes:
		url: object
		actions: shape
			setQuery: func

	componentWillMount: ->
		query = yun.url.getQuery()
		@props.actions.setQuery query

		EventListener.listen window, 'popstate', =>
			query = yun.url.getQuery()
			@props.actions.setQuery query
			return true

	componentWillReceiveProps: (nextProps) ->
		if isNil nextProps.url.query.page
			yun.url.navigate {page: 'todo'}

	render: ->
		{page} = @props.url.query
		div {},
			switch page
				when 'todo'
					build MainSection_default
				when null || undefined then @renderLoading()
				else @renderNotFound()

	renderLoading: ->
		div {},
			h1 {}, 'Laddar...'

	renderNotFound: ->
		div {},
			h1 {}, '404 - Sidan finns inte'
			build Link, {to: always({})}, 'Gå till startsidan'


stateToProps = (state) -> {url: state.url}
dispatchToProps = (dispatch) ->
	{actions: bindActionCreators(actions, dispatch)}

BodyView_default = connect(stateToProps, dispatchToProps)(BodyView)

module.exports = {BodyView, BodyView_default}
