assert = require 'assert'
moment = require 'moment'
{empty, eq, flip, has} = R = require 'ramda' #auto_require:ramda
{cc} = require 'ramda-extras'
{url, auth, ui, ui__newGroup, ui__mondays} = invokers = require './invokers'
{user_} = mock = require '../mock/mock'

eq = flip assert.equal
deepEq = flip assert.deepEqual

describe 'invokers:', ->

	describe 'url', ->
		it 'should set group if user_ exists but group is not set on week', ->
			res = url({}, 'week', {groups:{1:true, 2:true}}, null)
			expected = {url__group: {$set: 1}}
			deepEq expected, res

		it 'page=profile if user_ exists but there are no groups when on week', ->
			res = url({}, 'week', {groups:{}}, null)
			deepEq {url__page: {$set: 'profile'}}, res

		it 'should not set if not on week page', ->
			res = url({}, 'profile', {groups:{1:true, 2:true}}, null)
			eq null, res

		it 'login if no auth', ->
			res = url null, null, null, null
			deepEq {url__page: {$set: 'login'}}, res

		it '/ if auth and page=login', ->
			res = url null, null, 'login', {}
			deepEq {url__page: {$set: 'login'}}, res

		it 'page=week if / and auth not null', ->
			res = url {}, null, null, null
			deepEq {url__page: {$set: 'week'}}, res

	describe 'auth', ->
		it 'if page=logout and auth!=null, do logout', ->
			res = auth {}, 'logout'
			deepEq {auth: {$do: {logout: true}}}, res


	describe 'ui__mondays', ->
		it '3 mondays if mondays is empty', ->
			res = ui__mondays '2015-12-29', [], 'week', {startMonday: '2015-01-01'}
			mondays = ['2015-12-28', '2015-12-21', '2015-12-14']
			deepEq {ui__mondays: {$set: mondays}}, res

		it '3 mondays if firstMonday is not this week', ->
			res = ui__mondays '2015-12-29', ['2015-02-01'], 'week', {startMonday: '2015-01-01'}
			mondays = ['2015-12-28', '2015-12-21', '2015-12-14']
			deepEq mondays, res.ui__mondays.$set

		it 'null for no startMonday', ->
			res = ui__mondays '2015-12-29', [], 'week', {}
			eq null, res

		it 'only first monday if currentDate before startMonday, mondays empty', ->
			res = ui__mondays '2015-12-29', [], 'week', {startMonday: '2016-02-08'}
			mondays = ['2016-02-08']
			deepEq {ui__mondays: {$set: mondays}}, res

		it 'only first monday if currentDate before startMonday, mondays has earlier', ->
			res = ui__mondays '2015-12-29', ['2015-12-07'], 'week', {startMonday: '2016-02-08'}
			mondays = ['2016-02-08']
			deepEq mondays, res.ui__mondays.$set

		it 'only first monday if currentDate before startMonday, mondays only later', ->
			res = ui__mondays '2015-12-29', ['2016-03-07'], 'week', {startMonday: '2016-02-08'}
			mondays = ['2016-02-08']
			eq null, res



	describe 'ui__newGroup', ->
		it 'empty cases', -> eq null, ui__newGroup(null, null)
		it 'not new-group page', -> eq null, ui__newGroup('profile')
		it 'null if no user_', -> eq null, ui__newGroup('profile', '2015-12-29')
		it 'happy case create', ->
			res = ui__newGroup 'new-group', '2015-12-29', {id:1}
			data = {name: '', startMonday: '2016-01-04',
			users: {1: true}}
			deepEq {ui__newGroup: {$set: data}}, res
		it 'happy case edit', ->
			group = {a: 1, b: 2}
			res = ui__newGroup 'edit-group', '2015-12-29', {id:1}, group
			data = {name: '', startMonday: '2016-01-04',
			users: {1: true}}
			deepEq {ui__newGroup: {$set: group}}, res


