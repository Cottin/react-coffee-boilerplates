{combineReducers} = require 'redux'
todos = require './todos'
url = require './url'

rootReducer = combineReducers {todos, url}

module.exports = rootReducer
