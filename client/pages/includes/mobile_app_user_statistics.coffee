renderAnalytic = (type) ->
  deviceId = Session.get 'selectedDeviceId'
  startDate = Session.get 'mobileAppUserStartDate'
  endDate = Session.get 'mobileAppUserEndDate'

  MobileAppUser = MobileAppUsers.findOne(deviceId: deviceId)
  totalDays = moment(endDate).diff(moment(startDate), 'days')

  if totalDays
    Meteor.call 'getMobileAppUserAnalytic', MobileAppUser.deviceId, startDate, endDate, type, (error, result) ->
      renderDailyChart('#mobile-app-user-lines', result, moment(startDate).valueOf(), totalDays)

Template.mobileAppUserStatistics.helpers
  mobileAppUsers: ->
    MobileAppUsers.find(appId: Session.get 'selectedMobileId')
  mobileAppUser: ->
    MobileAppUsers.findOne(deviceId: Session.get('selectedDeviceId'))

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
    deviceId = Session.get 'selectedDeviceId'
    Meteor.subscribe 'counts-by-mobileAppUser', {deviceId: deviceId }
    if Counts.findOne(deviceId)
      renderAnalytic('day')

Template.mobileAppUserStatistics.events
  'change #selected-mobile-app-user': (e, context) ->
    Session.set 'selectedDeviceId', e.target.value

Template.mobileAppUserStatistics.destroyed = ->
  if @mobileAppUserDep
    @mobileAppUserDep.stop()