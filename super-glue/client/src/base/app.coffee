appBase = require './appBase'

devDataApi = "http://localhost:3009/dev/data/"
initialData = require './initialData'
lifters = require './lifters'
invokers = require './invokers'
queriers = require './queriers'
actions = require './actions'
parser = require './parser'

console.log 'lifters....', lifters

appBase.initialize {
	DEV_MODE: DEV,
	devDataApi
	initialData
	lifters
	invokers
	queriers
	actions
	parser
}

module.exports = appBase


