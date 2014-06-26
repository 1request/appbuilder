Template.monthlyLog.created = ->
  loadResources()

Template.monthlyLog.helpers
  mobileApp: ->
    MobileApps.findOne()
  days: ->
    [1..moment().startOf('month').daysInMonth()]
  currentMonth: ->
    moment().format('MMMM')

Template.monthlyLog.destroyed = ->
  removeResources()
  if @countDep
    @countDep.stop()
