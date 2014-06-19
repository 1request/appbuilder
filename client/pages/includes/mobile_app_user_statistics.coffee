renderAnalytic = (type) ->
  deviceId = Session.get 'deviceId'
  startDate = Session.get 'mobileAppUserStartDate'
  endDate = Session.get 'mobileAppUserEndDate'

  MobileAppUser = MobileAppUsers.findOne(deviceId: deviceId)
  totalDays = moment(endDate).diff(moment(startDate), 'days')

  if totalDays
    Meteor.call 'getMobileAppUserAnalytic', MobileAppUser.deviceId, startDate, endDate, type, (error, result) ->
      renderDailyChart('#mobile-app-user-lines', result, moment(startDate).valueOf(), totalDays)

Template.mobileAppUserStatistics.helpers
  mobileAppUsers: ->
    MobileAppUsers.find(appKey: Session.get 'mobileAppKey')
  mobileAppUser: ->
    MobileAppUsers.findOne(deviceId: Session.get('deviceId'))

Template.mobileAppUserStatistics.rendered = ->

  Session.setDefault('mobileAppUserStartDate', moment().startOf('day').subtract('days', 6).valueOf())
  Session.setDefault('mobileAppUserEndDate', moment().startOf('day').valueOf())

  $inputFrom = $('#mobileAppUserDateFrom').pickadate
    onStart: ->
      @set 'select', Session.get('mobileAppUserStartDate')
    onSet: (e) ->
      Session.set 'mobileAppUserStartDate', moment(e.select).startOf('days').valueOf()

  $inputTo = $('#mobileAppUserDateTo').pickadate
    onStart: ->
      @set 'select', Session.get('mobileAppUserEndDate')
    onSet: (e) ->
      Session.set 'mobileAppUserEndDate', moment(e.select).startOf('days').valueOf()

  @mobileAppUserDep = Deps.autorun ->
    deviceId = Session.get 'deviceId'
    Meteor.subscribe 'counts-by-mobileAppUser', { deviceId: deviceId }
    if Counts.findOne(deviceId)
      renderAnalytic('day')

Template.mobileAppUserStatistics.events
  'change #selected-mobile-app-user': (e, context) ->
    Session.set 'deviceId', e.target.value

Template.mobileAppUserStatistics.destroyed = ->
  if @mobileAppUserDep
    @mobileAppUserDep.stop()