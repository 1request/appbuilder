renderAnalytic = (type) ->
  appKey = Session.get 'mobileAppKey'
  startDate = Session.get 'appStartDate'
  endDate = Session.get 'appEndDate'
  app = MobileApps.findOne(appKey: appKey)
  totalDays = moment(endDate).diff(moment(startDate), 'days')
  if totalDays
    Meteor.call 'getAppAnalytic', app.appKey, startDate, endDate, type, (error, result) ->
      renderDailyChart('#graph-app-lines', result, moment(startDate).valueOf(), totalDays)

Template.appStatistics.helpers
  mobileApps: ->
    MobileApps.find()
  mobileApp: ->
    MobileApps.findOne(Session.get 'mobileAppKey')

Template.appStatistics.rendered = ->
  @appDep = Deps.autorun ->
    count = Counts.findOne(Session.get('mobileAppKey'))
    if count
      renderAnalytic('day')
  $('#selected-app').val("#{Session.get 'mobileAppKey'}")
  Session.setDefault('appStartDate', moment().startOf('day').subtract('days', 6).valueOf())
  Session.setDefault('appEndDate', moment().startOf('day').valueOf())
  Meteor.subscribe 'counts-by-app', {appKey: Session.get 'mobileAppKey'}

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
    Session.set 'mobileAppKey', e.target.value
    deviceId = MobileAppUsers.findOne(appKey: Session.get('mobileAppKey')).deviceId
    Session.set 'deviceId', deviceId
    Meteor.subscribe 'counts-by-app', {appKey: e.target.value}

Template.appStatistics.destroyed = ->
  if @appDep
    @appDep.stop()
