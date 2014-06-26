Template.monthlyLog.created = ->
  loadResources()

Template.monthlyLog.helpers
  mobileApp: ->
    MobileApps.findOne()
  days: ->
    [1..moment().startOf('month').daysInMonth()]
  currentMonth: ->
    moment().format('MMMM')

Template.monthlyLog.rendered = ->
  @countDep = Deps.autorun ->
    Counts.findOne()
    date = moment().date()
    Meteor.call 'dayCount', MobileAppUsers.findOne().deviceId, date, (error, result) ->
      Session.set 'todayCount', result

Template.monthlyLog.destroyed = ->
  removeResources()
  if @countDep
    @countDep.stop()
