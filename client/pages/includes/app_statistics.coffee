renderAnalytic = (type) ->
  appId = Session.get 'selectedMobileId'
  startDate = Session.get 'appStartDate'
  endDate = Session.get 'appEndDate'
  app = Mobile.findOne(appId)
  totalDays = moment(endDate).diff(moment(startDate), 'days')
  if totalDays
    Meteor.call 'getAppAnalytic', app._id, startDate, endDate, type, (error, result) ->
      renderDailyChart('#graph-app-lines', result, moment(startDate).valueOf(), totalDays)

Template.appStatistics.helpers
  mobiles: ->
    Mobile.find()
  mobile: ->
    Mobile.findOne(Session.get 'selectedMobileId')

Template.appStatistics.rendered = ->
  @appDep = Deps.autorun ->
    count = Counts.findOne(Session.get('selectedMobileId'))
    if count
      renderAnalytic('day')

  Session.setDefault('appStartDate', moment().startOf('day').subtract('days', 6).valueOf())
  Session.setDefault('appEndDate', moment().startOf('day').valueOf())
  Meteor.subscribe 'counts-by-app', {appId: Session.get 'selectedMobileId'}

  $inputFrom = $('#appDateFrom').pickadate
    onStart: ->
      @set 'select', Session.get('appStartDate')
    onSet: (e) ->
      Session.set 'appStartDate', moment(e.select).startOf('days').valueOf()

  $inputTo = $('#appDateTo').pickadate
    onStart: ->
      @set 'select', Session.get('appEndDate')
    onSet: (e) ->
      Session.set 'appEndDate', moment(e.select).startOf('days').valueOf()

Template.appStatistics.events
  'change #selected-app': (e, context) ->
    Session.set 'selectedMobileId', e.target.value
    deviceId = MobileAppUsers.findOne(appId: Session.get('selectedMobileId')).deviceId
    Session.set 'selectedDeviceId', deviceId
    $('#selected-mobile-app-user').trigger('change')
    Meteor.subscribe 'counts-by-app', {appId: e.target.value}

Template.appStatistics.destroyed = ->
  if @appDep
    @appDep.stop()
