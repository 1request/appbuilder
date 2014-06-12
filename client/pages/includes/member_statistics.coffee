renderAnalytic = (type) ->
  member = Members.findOne(deviceId: Session.get('selectedDeviceId'))
  startDate = Session.get('memberStartDate')
  endDate = Session.get('memberEndDate')
  totalDays = moment(endDate).diff(moment(startDate), 'days')
  if totalDays
    Meteor.call 'getMemberAnalytic', member.deviceId, startDate, endDate, type, (error, result) ->
      renderDailyChart('#graph-member-lines', result, moment(startDate).valueOf(), totalDays)

Template.memberStatistics.helpers
  members: ->
    Members.find(appId: Session.get 'selectedMobileId')
  member: ->
    Members.findOne(deviceId: Session.get('selectedDeviceId'))

Template.memberStatistics.rendered = ->
  Session.setDefault('memberStartDate', moment().startOf('day').subtract('days', 6).valueOf())
  Session.setDefault('memberEndDate', moment().startOf('day').valueOf())

  $inputFrom = $('#memberDateFrom').pickadate
    onStart: ->
      @set 'select', Session.get('memberStartDate')
    onSet: (e) ->
      Session.set 'memberStartDate', moment(e.select).startOf('days').valueOf()

  $inputTo = $('#memberDateTo').pickadate
    onStart: ->
      @set 'select', Session.get('memberEndDate')
    onSet: (e) ->
      Session.set 'memberEndDate', moment(e.select).startOf('days').valueOf()
  Deps.autorun ->
    if Session.get 'selectedMobileId'
      Session.setDefault('selectedDeviceId', Members.findOne(appId: Session.get 'selectedMobileId').deviceId)

  Deps.autorun ->
    deviceId = Session.get 'selectedDeviceId'
    if deviceId
      Meteor.subscribe 'counts-by-member', {deviceId: deviceId }

  Deps.autorun ->
    if Counts.findOne(Session.get 'selectedDeviceId')
      renderAnalytic('day')

Template.memberStatistics.events
  'change #selected-member': (e, context) ->
    Session.set 'selectedDeviceId', e.target.value
