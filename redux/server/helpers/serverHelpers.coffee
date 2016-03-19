{} = require 'ramda' # auto_require:ramda

# ------------------------------------------------------------------------------------------------------
# GENERAL
# ------------------------------------------------------------------------------------------------------
cors = (req, res, next) ->
		res.set 'Access-Control-Allow-Origin', req.headers.origin
		res.set 'Access-Control-Allow-Headers', 'Content-Type, Authorization, X-Requested-With, Content-Length, Accept, Origin'
		res.set 'Access-Control-Allow-Methods', 'GET, POST, OPTIONS, PUT, PATCH, DELETE'
		res.set 'Access-Control-Allow-Credentials', 'true'
		res.set 'Access-Control-Max-Age', 5184000
		next()


# ------------------------------------------------------------------------------------------------------
# DEV
# ------------------------------------------------------------------------------------------------------
logResponseBody = (req, res, next) ->
	oldWrite = res.write
	oldEnd = res.end
	chunks = []

	res.write = (chunk) ->
		chunks.push chunk
		oldWrite.apply res, arguments
		return

	res.end = (chunk) ->
		if chunk
			chunks.push chunk
		body = Buffer.concat(chunks).toString('utf8')
		console.log "RESPONSE BODY: ", body
		oldEnd.apply res, arguments
		return

	next()
	return

module.exports = {cors, logResponseBody}
