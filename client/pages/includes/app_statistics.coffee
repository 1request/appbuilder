renderAnalytic = (type) ->
  app = Mobile.findOne(Session.get 'selectedMobileId')
  startDate = Session.get('appStartDate')
  endDate = Session.get('appEndDate')
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
  Session.setDefault('appStartDate', moment().startOf('day').subtract('days', 6).valueOf())
  Session.setDefault('appEndDate', moment().startOf('day').valueOf())
  Session.setDefault('selectedMobileId', Mobile.findOne(userId: Meteor.userId())._id)


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

  Deps.autorun ->
    Session.get 'selectedMemberId'
    $('#selected-member').trigger('change')

  Deps.autorun ->
    if Session.get 'selectedMobileId'
      Meteor.subscribe 'counts-by-app', {appId: Session.get 'selectedMobileId'}

  Deps.autorun ->
    if Counts.findOne(Session.get('selectedMobileId'))
      renderAnalytic('day')

Template.appStatistics.events
  'change #selected-app': (e, context) ->
    Session.set 'selectedMobileId', e.target.value
    memberId = Members.findOne(appId: Session.get('selectedMobileId'))
    Session.set 'selectedMemberId', memberId


