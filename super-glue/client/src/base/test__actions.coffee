assert = require 'assert'
{add, apply, eq, flip} = require 'ramda' #auto_require:ramda
{cc} = require 'ramda-extras'
{ui} = invokers = require './actions'
# {user_} = mock = require '../mock/mock'

eq = flip assert.equal
deepEq = flip assert.deepEqual

describe 'actions:', ->
	describe 'ui', ->
		describe 'mondays', ->
			describe 'add', ->
				it 'simple case', ->
					expected = ['2015-12-28', '2015-12-21', '2015-12-14', '2015-12-07']
					res = ui.mondays.add()
					res_ = res.ui__mondays.$apply ['2015-12-28']
					deepEq expected, res_

