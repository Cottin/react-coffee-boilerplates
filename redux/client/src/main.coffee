React = require 'react'
ReactDOM = require 'react-dom'
AppView = React.createFactory require('./views/AppView')
Provider = React.createFactory require('react-redux').Provider
{compose, identity} = require 'ramda' #auto_require:ramda

{createStore} = require 'redux'
rootReducer = require './reducers'

devTools = -> 
	if window.devToolsExtension then window.devToolsExtension() else identity
finalCreateStore = compose(devTools())(createStore)

configureStore = (initialState) ->
  store = finalCreateStore rootReducer, initialState

  if module.hot
    # Enable Webpack hot module replacement for reducers
    module.hot.accept './reducers', () ->
      nextReducer = require('./reducers')
      store.replaceReducer nextReducer

  return store


store = configureStore()

ReactDOM.render(Provider({store}, AppView()), document.getElementById('root'))
