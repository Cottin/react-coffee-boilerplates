React = require 'react'
# fbjs: follow discussion here: https://github.com/larrymyers/react-mini-router/issues/46
EventListener = require 'fbjs/lib/EventListener'
Radium = require 'radium'
app = require '../base/app'
{build} = app.uiHelpers
{div} = React.DOM
{equals, path} = require 'ramda' #auto_require:ramda
yun = require 'yun'

StyleRoot = React.createFactory Radium.StyleRoot
Style = React.createFactory Radium.Style
s = require './style/AppView.style'
{BodyView_default} = require './BodyView'

# TODO: move to yun?
LocalStorage =
	setObject: (k, v) -> localStorage?.setItem k, JSON.stringify(v)
	getObject: (k) ->
		value = localStorage?.getItem k
		value && JSON.parse value
	removeObject: (k) -> localStorage?.removeItem k
	clear: -> localStorage?.clear()

AppView = React.createClass
	displayName: 'AppView'

	componentWillMount: ->
		@setState {data: {url: {query: {}}}}
		app.set 'url', {query: yun.url.getQuery()}

		authFromLocalStorage = LocalStorage.getObject 'auth'
		if authFromLocalStorage
			app.set 'auth', authFromLocalStorage

		app.renderHook = (data) =>
			@setState {data: data}

		app.setHook = (path, value, fullData) ->
			if path == '' || path == null
				app.set 'url', {query: yun.url.getQuery()}
			else if equals path, ['auth']
				LocalStorage.setObject 'auth', value

		EventListener.listen window, 'popstate', ->
			url = {query: yun.url.getQuery()}
			app.set('url', url)
			return true

	render: ->
		StyleRoot {},
			build BodyView_default

module.exports = AppView
