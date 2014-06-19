renderAnalytic = (type) ->
  appId = Session.get 'mobileAppId'
  startDate = Session.get 'appStartDate'
  endDate = Session.get 'appEndDate'
  app = MobileApps.findOne(appId)
  totalDays = moment(endDate).diff(moment(startDate), 'days')
  if totalDays
    Meteor.call 'getAppAnalytic', app._id, startDate, endDate, type, (error, result) ->
      renderDailyChart('#graph-app-lines', result, moment(startDate).valueOf(), totalDays)

Template.appStatistics.helpers
  mobileApps: ->
    MobileApps.find()
  mobileApp: ->
    MobileApps.findOne(Session.get 'mobileAppId')

Template.appStatistics.rendered = ->
  @appDep = Deps.autorun ->
    count = Counts.findOne(Session.get('mobileAppId'))
    if count
      renderAnalytic('day')

  Session.setDefault('appStartDate', moment().startOf('day').subtract('days', 6).valueOf())
  Session.setDefault('appEndDate', moment().startOf('day').valueOf())
  Meteor.subscribe 'counts-by-app', {appId: Session.get 'mobileAppId'}

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
    Session.set 'mobileAppId', e.target.value
    deviceId = MobileAppUsers.findOne(appId: Session.get('mobileAppId')).deviceId
    Session.set 'deviceId', deviceId
    Meteor.subscribe 'counts-by-app', {appId: e.target.value}

Template.appStatistics.destroyed = ->
  if @appDep
    @appDep.stop()
