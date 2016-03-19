# TODO: create small lib out of helpers
routerHelpers = require './helpers/routerHelpers'

mockData =
	todos:
		1: {id: 1, text: 'Buy milk'}
		2: {id: 2, text: 'Hang mirror on the wall'}
		3: {id: 3, text: 'Fix the broken shoes'}
		4: {id: 4, text: 'Plan for kitchen renovation'}

router = (app) ->
	{routeDefinitions, group, get} = routerHelpers app
	g = group

	routeDefinitions null,
		g 'todo',
			get -> mockData.todos

module.exports = router
