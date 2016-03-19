{__, always, apply, contains, equals, findIndex, gt, head, isNil, keys, length, merge, path, replace, set, split, test, type, update} = R = require 'ramda' #auto_require:ramda
{cc, isa, yforEach, ymap, ymapObjIndexed} = require 'ramda-extras'
popsiql = require 'popsiql'
appBase = require './appBase'
yun = require 'yun'

urlParser = (query, urlQuery) ->
	query_ = popsiql.toNestedQuery query
	newQuery = popsiql.toRamda(query_.url)(urlQuery)
	if equals newQuery, urlQuery then return

	yun.url.navigate always(newQuery)

uiParser = (query) ->
	if cc gt(__, 1), length, keys, query
		throw new Error 'uiParser for now only supports one key per query'

	{path, f} = popsiql.toSuperGlue query
	newVal = f R.path(path, appBase.data)
	appBase.set path, newVal, 'ui-parser'

authParser = (query) ->
	if cc gt(__, 1), length, keys, query
		throw new Error 'authParser only supports one key per query'

	{path, f} = popsiql.toSuperGlue query
	newVal = f R.path(path, appBase.data)
	appBase.set path, newVal, 'auth-parser'
	# {$do} = query.auth
	# if isNil $do then throw new Error 'authParser expects a $do operation'

	# {login, logout} = $do
	# if logout
	# 	fbctx.mutationRef.unauth()
	# else if login
	# 	if login == 'facebook'
	# 		facebookCallback = (error, authData) ->
	# 			if error then console.log 'Login Failed!', error
	# 			else console.log 'Authenticated successfully with payload:', authData
	# 		# fbctx.mutationRef.authWithOAuthPopup 'facebook', facebookCallback,
	# 		# 	{scope: 'email'}
	# 		fbctx.mutationRef.authWithOAuthRedirect 'facebook', facebookCallback,
	# 			{scope: 'email'}
	# else
	# 	throw new Error "authParser cannot parse #{JSON.stringify(query)}"

# ta meta i steg 2
local = (query) ->
	{key, operation} = extract query
	switch operation
		when '$set' || '$merge'
			# update _diff
		when '$push'
			# create new with uuid
		when '$do' || '$apply'
			# throw new not supported
		when '$get'
			# todo: think about this later

syncStart = (query) ->
	{key, operation} = extract query
	switch operation
		when '$set' || '$merge' || '$push'
			# create new sync item under correct collection key
			# {key: 1, type: 'set/merge/push', state: 'pending', ts: 123123123}
		when '$do' || '$apply'
			# throw new not supported
		when '$get'
			# todo: think about this later

syncSuccess = (query) ->
	{key, operation} = extract query
	switch operation
		when '$set' || '$merge'
			# update sync item to {status: 'success', code}
			# make what's in _diff permanent
		when '$push'
			# update sync item to {status: 'success', code}
			# update item in data with temp id to permanent id from server
		when '$do' || '$apply'
			# throw new not supported
		when '$get'
			# todo: think about this later

syncError = (query) ->
	{key, operation} = extract query
	switch operation
		when '$set' || '$merge'
			# update sync item to {status: 'error', code}
		when '$push'
			# update sync item to {status: 'error', code}
		when '$do' || '$apply'
			# throw new not supported
		when '$get'
			# todo: think about this later





class SimpleStupidCache
	constructor: (collections, syncParser) ->
		@data = collections
		@syncs = collections
		@meta = collections

	apply: (query, useDiff = false) ->
		query_ = if useDiff then toDiff query else query
		nestedQuery = popsiql.toNestedQuery query_
		newData = popsiql.toRamda(nestedQuery)(@data)
		@data = newData

	sync: (query) ->
		syncItem = buildSyncItem query
		@syncs.push syncItem
		syncParser(query)
			.then(@syncSuccess(syncItem))
			.fail(@syncError(syncItem))

	buildSyncItem: (query) ->
		# TODO
	
	syncSuccess: (syncItem) -> ({code, data}) =>
		idx = findIndex syncItem, @syncs
		newSyncItem = merge {status: 'success', code, data}, @syncs[idx]
		@syncs[idx] = newSyncItem

	syncError: (syncItem) -> ({code, data}) =>
		idx = findIndex syncItem, @syncs
		newSyncItem = merge {status: 'error', code, data}, @syncs[idx]
		@syncs[idx] = newSyncItem


	query: (query) ->
		if cc gt(__, 1), length, keys, query
			throw new Error 'SimpleStupidCache for now only supports one key per query'

		firstKey = cc head, split('__'), head, keys, query

		if test /^_/, firstKey # only run local query
			query_ = toObj replace(/^_/, '', firstKey), query[firstKey]
			@apply query_, isMeta(query_)

		else
			innerQuery = query[firstKey]

			if cc gt(__, 1), length, keys, innerQuery
				throw new Error "SimpleStupidCache only supports one operation per query key,
				your keys: #{keys(innerQuery)}"

			operation = cc head, keys, innerQuery

			switch operation
				when '$set'
					apply query, true
					sync query














dataParser = (query, path) ->
	if cc gt(__, 1), length, keys, query
		throw new Error 'dataParser for now only supports one key per query'

	firstKey = cc head, split('__'), head, keys, query
	console.log 'data query', query

	k = cc head, keys, query
	innerQuery = query[k]
	console.log 'k', k, innerQuery

	if isNil innerQuery.$get
		throw new Error "dataParser only accepts $get operations, your query:
		#{JSON.stringify(query)}"

	switch k
		when 'todos'
			# hardcoded todos
			todos = {
				1: {id: 1, text: 'Buy milk', isCompleted: false},
				2: {id: 2, text: 'Renovate kitchen', isCompleted: false},
				3: {id: 3, text: 'Find better job', isCompleted: false},
				4: {id: 4, text: 'Get in better shape', isCompleted: false},
			}
			appBase.set path, todos
		else
			throw new Error "dataParser cannot handle query with key #{k},
			your query: #{JSON.stringify(query)}"


	# if cc gt(__, 1), length, keys, innerQuery
	# 	throw new Error "dataParser only supports one key per query key,
	# 	your keys: #{keys(innerQuery)}"

	# mutation = cc head, keys, innerQuery
	# path_ = split '__', k
	# v = innerQuery[mutation]
	# f =
	# 	switch mutation
	# 		when '$set'
queryParser = (query, path) ->
	console.log 'QUERY PARSER', query, path

	if isNil query then return

	if !popsiql.isValidQuery query
		throw new Error 'Query parser: the query is not a valid popsiql query'

	if cc gt(__, 1), length, keys, query
		throw new Error "Parser only allows one key, your keys: #{keys(query)}"

	firstKey = cc head, split('__'), head, keys, query
	if contains firstKey, ['todos']
		dataParser query, path
	else
		throw new Error "query parser does not support querying on #{firstKey}"

mutationParser = (query) ->
	console.log 'MUTATION PARSER', query
	if isNil query then return null

	if !popsiql.isValidQuery query
		throw new Error 'Mutation parser: the query is not a valid popsiql query'

	firstKey = cc head, split('__'), head, keys, query
	switch firstKey
		when 'url' then return urlParser query, yun.url.getQuery()
		when 'auth' then return authParser query
		when 'ui' then return uiParser query
		else
			throw new Error "Mutation parser does not support #{firstKey}"

module.exports = {queryParser, mutationParser}
