moment = require 'moment'

data =
	url:
		query:
			page: null

	# AUTH
	auth: null

	# UI
	ui:
		favorites: []

	status:
		todos: []

	# DATA
	todos:
		1: {id: 1, text: 'Buy milk'}
		2: {id: 2, text: 'Hang mirror on the wall'}
		3: {id: 3, text: 'Fix the broken shoes'}
		4: {id: 4, text: 'Plan for kitchen renovation'}

module.exports = data
