{curry, head, keys, map, merge, toPairs, values} = require 'ramda' #auto_require:ramda
{cc, ymap} = ramdaExtras = require 'ramda-extras'
moment = require 'moment'
lo = require 'lodash'
{denorm2} = require 'sometools'

# todo: move to utils
toIdObj = curry (kvs) ->
	if firstKey = cc head, keys, kvs
		return merge kvs[firstKey], {id: firstKey}

toIdArray = curry (kvs) ->
	toNewObj = ([id, v]) -> merge v, {id}
	return cc map(toNewObj), toPairs, kvs

##### DOMAIN DATA #############################################################
todos_ = (todos) -> cc values, todos


##### VIEW DATA ###############################################################
TodoView_ = (todos_) ->
	todos: todos_

module.exports = {todos_, TodoView_}
