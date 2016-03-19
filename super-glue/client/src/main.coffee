React = require 'react'
ReactDOM = require 'react-dom'
AppView = React.createFactory require('./views/AppView')
app = require './base/app'
initialData = require './base/initialData'

{forEach, keys} = R = require 'ramda'

install = (o, target) ->
	addKey = (k) -> target[k] = o[k]
	forEach addKey, keys o

{sify} = require 'sometools'
install {sify}, window

ramdaExtras = require 'ramda-extras'
install {ramdaExtras}, window
install ramdaExtras, window

moment = require 'moment'
install {moment}, window

moment.locale 'sv'

# popsiql = require 'popsiql'
# install {popsiql}, window

install {app}, window
install {app}, document

ReactDOM.render AppView(), document.getElementById('root')
