React = require 'react'
{NICE, SUPER_NICE} = require './colors'
{div} = React.DOM
Counter = React.createFactory require('./Counter')

App = React.createClass
  render: ->
    div {},
      Counter {increment: 1, color: NICE}
      Counter {increment: 5, color: SUPER_NICE}

module.exports = App
