express = require 'express'
bodyParser = require 'body-parser'
Table = require('cli-table')
morgan = require('morgan')
{compose, filter, head, keys, map, path} = require 'ramda' # auto_require:ramda
{cc} = require 'ramda-extras'

serverHelpers = require './helpers/serverHelpers'
router = require './router'

# ------------------------------------------------------------------------------------------------------
# MIDDLEWARE
# ------------------------------------------------------------------------------------------------------
app = express()
app.use(morgan('dev'))

app.all '*', (req, res, next) ->
	console.log "\n#{req.method} #{req.path}"
	next()

app.all '*', serverHelpers.cors
app.use bodyParser.json()

app.use serverHelpers.logResponseBody

# ------------------------------------------------------------------------------------------------------
# ROUTES
# ------------------------------------------------------------------------------------------------------
app.get '/', (req, res) -> res.send 'Hello World from api!'

app.get '/routes', (req, res) ->
	table = new Table {head: ['verb', 'path'], colWidths: [10, 70]}
	M = ['route', 'methods']
	P = ['route', 'path']

	extractVerb = compose head, keys, path(M)
	extractPath = path P
	extractVerbAndPath = (x) -> [extractVerb(x), extractPath(x)]
	notUndefined = (x) -> path(P, x) != undefined

	result = cc map(extractVerbAndPath), filter(notUndefined), app._router.stack
	table.push result...
	console.log table.toString()
	res.send 'Check your console for printed routing table'


router(app)


# ------------------------------------------------------------------------------------------------------
# START
# ------------------------------------------------------------------------------------------------------
server = app.listen 3002, ->
	host = server.address().address
	port = server.address().port
	console.log 'Example app listening at http://%s:%s', host, port
	
module.exports = app
