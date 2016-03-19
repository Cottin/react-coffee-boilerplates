assert = require 'assert'
moment = require 'moment'
util = require 'util'
{add, always, empty, flip, has, isNil, join, last, length, sort} = require 'ramda' #auto_require:ramda
{cc} = require 'ramda-extras'
{page_, topBarData_, dateData_, profile_, groups_} = lifters = require './lifters'
{editGroup_create, editGroup_edit, joinData_} = lifters
{url__query__date, user_, group_, group_users, group_users_, activities, ui, workouts} = mock = require '../mock/mock'
{ui__currentDate, groups} = mock
{sify} = require 'sometools'

eq = flip assert.strictEqual
deepEq = flip assert.deepEqual

moment.locale('sv')

describe 'lifters:', ->
	describe 'user_', ->
		it 'should handle empty cases', ->
			eq true, isNil(lifters.user_(null))
			eq true, isNil(lifters.user_({}))

	describe 'group_users_', ->
		it 'should handle empty cases', ->
			deepEq [], lifters.group_users_(null)
			deepEq [], lifters.group_users_({})

		it 'shoud add ids correctly and sort by date joined group', ->
			data = {1: {created: 12345}, 2: {created: 12344}}
			res = lifters.group_users_(data)
			eq '2', res[0].id
			eq '1', res[1].id

	describe 'weeks_', ->
		it 'should handle loading cases', ->
			eq 'Laddar...', lifters.weeks_(null, group_users, group_users_, activities, ui.mondays, workouts, ui__currentDate)[0].text
			eq 'Laddar...', lifters.weeks_(group_, null, group_users_, activities, ui.mondays, workouts, ui__currentDate)[0].text

		it 'should handle empty cases', ->
			# eq 'Laddar...', lifters.weeks_(group_, group_users, null, activities, ui.mondays, workouts, ui__currentDate)[0].text
			# eq 'Laddar...', lifters.weeks_(group_, group_users, group_users_, null, ui.mondays, workouts, ui__currentDate)[0].text
			# eq 'Laddar...', lifters.weeks_(group_, group_users, group_users_, activities, null, workouts, ui__currentDate)[0].text
			res = lifters.weeks_(group_, group_users, group_users_, activities, ui.mondays, workouts, null)
			eq 'Laddar...', res[0].text

		it 'empty workouts', ->
			res = lifters.weeks_(group_, group_users, group_users_, activities, ui.mondays, null, ui__currentDate)
			eq 5, res[1].days[0].workouts.length # filled with null's
			eq null, res[0].days[2].workouts[1]

		it 'should start on last monday', ->
			res = lifters.weeks_(group_, group_users, group_users_, activities, ui.mondays, workouts, '2016-01-20')
			eq 'Må', res[0].days[6].text

		res = lifters.weeks_(group_, group_users, group_users_, activities, ui.mondays, workouts, ui__currentDate)

		it 'text', -> eq 'Vecka 24', res[0].text
		it 'days always 7', -> eq 7, length(res[1].days)
		it 'Sö, Lö, Fr', -> eq 'Sö', res[1].days[0].text
		it 'dateText', -> eq '21 jun', res[1].days[0].dateText
		it 'day.key = YYYY-MM-DD', -> eq '2015-06-21', res[1].days[0].key
		it 'workouts always same number as users', ->
			eq 5, res[1].days[0].workouts.length
		it 'workouts ordered correctly', ->
			eq 4, res[0].days[6].workouts[3].activity.id
			eq 1, res[0].days[6].workouts[4].activity.id

		it 'dont show weeks earlier than startMonday', ->
			earlyMondays = ['2015-01-05', '2015-01-12', '2015-01-19']
			res = lifters.weeks_(group_, group_users, group_users_, activities, earlyMondays, workouts, ui__currentDate)
			deepEq [], res

	describe 'dateData_', ->
		it 'should handle empty cases', ->
			eq null, dateData_(null, user_, workouts, activities)
			eq null, dateData_(url__query__date, null, workouts, activities)
			eq null, dateData_(url__query__date, user_, null, activities)
			eq null, dateData_(url__query__date, user_, workouts, null)

		res = dateData_(url__query__date, user_, workouts, activities)
		it 'text', -> eq 'Fredag 5 juni', res.text
		it 'activity selected', -> eq 1, res.activities[2].selectedColor
		it 'date', -> eq '2015-06-05', res.date
		it 'userId', -> eq 3, res.userId

	describe 'topBarData_', ->
		currentDate = '2015-06-18'
		it 'should handle empty cases', ->
			eq null, topBarData_(null, workouts, group_, currentDate)
			eq null, topBarData_(group_users_, null, group_, currentDate)
			eq null, topBarData_(group_users_, workouts, null, currentDate)
			eq null, topBarData_(group_users_, workouts, group_, null)

		res = topBarData_(group_users_, workouts, group_, currentDate, user_)
		it 'ordered by join date', -> eq 1, res[4].user.id
		it 'average is correct from start monday', ->
			eq '1.3', res[4].average

		it "average when date before startMonday should behave
		as if date was first sunday of groups first week", ->
			res = topBarData_(group_users_, workouts, group_, '2013-01-01', user_)
			eq '4.0', res[4].average

		it 'average when user with workouts prior to startMonday', ->
			res = topBarData_(group_users_, workouts, group_, '2013-01-01', user_)
			eq '2.0', res[3].average

	describe 'groups_', ->
		it 'should handle empty cases', ->
			eq null, groups_(null)

		res = groups_(groups)
		it 'correct order', -> eq '2', res[0].id

	describe 'profile_', ->
		it 'should handle empty case', ->
			eq null, profile_(groups_, null)

		it 'no groups', ->
			res = profile_(null, user_)
			eq 'Aktiv sedan maj 2015', res.user.activeSince
			eq 0, length(res.groups)

		currentDate = '2015-06-27'
		res = profile_(mock.groups_, mock.user_, currentDate)
		it 'activeSince', ->
			eq 'Aktiv sedan maj 2015', res.user.activeSince

		it 'groups text', ->
			eq '3 medlemmar, startade 1 jun (3 veckor sen)', res.groups[0].text

		it 'groups text not yet started', ->
			res = profile_(mock.groups_, mock.user_, '2015-02-27')
			eq '3 medlemmar, startar om 13 veckor den 1 jun', res.groups[0].text

	describe 'editGroup_create', ->
		it 'empty case', ->
			eq null, editGroup_create(null)

		user = {id: 1}
		it 'happy case', ->
			res = editGroup_create {name: 'abc', startMonday: '2015-12-07'}, user
			eq 'abc', res.group.name
			eq '2015-12-07', res.group.startMonday
			eq true, res.validation.isMonday

		it 'invalid monday', ->
			res = editGroup_create {startMonday: '2015-12-08'}, user
			eq false, res.validation.isMonday

		it 'isValid', ->
			res = editGroup_create {name: '', startMonday: ''}, user
			eq false, res.validation.isValid

		it 'isValid happy', ->
			res = editGroup_create {name: 'abc', startMonday: '2015-12-07'}, user
			eq true, res.validation.isValid

	describe 'editGroup_edit', ->
		it 'has members', ->
			group_ = {name: 'abc', startMonday: '2015-12-07'}
			group_users_ = [{name: 'Elin'}, {name: 'Victor'}]
			res = editGroup_edit group_, group_users_
			deepEq group_users_, res.members

	describe 'joinData_', ->
		it 'empty case', ->
			eq true, isNil(joinData_(null, {}))

		it 'happy case', ->
			res = joinData_ {name: 'a'}, {name: 'Elin'}
			deepEq {name: 'a'}, res.group
			deepEq {name: 'Elin'}, res.user

		it 'no authenticated user', ->
			res = joinData_ {name: 'a'}, null
			deepEq {name: 'a'}, res.group
			deepEq null, res.user


