renderAnalytic = (type) ->
  member = Members.findOne(Session.get 'selectedMemberId')
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
    Members.findOne(Session.get 'selectedMemberId')

Template.memberStatistics.rendered = ->
  Session.setDefault('memberStartDate', moment().startOf('day').subtract('days', 6).valueOf())
  Session.setDefault('memberEndDate', moment().startOf('day').valueOf())
  Session.setDefault('selectedMemberId', Members.findOne(appId: Session.get 'selectedMobileId')._id)

  renderAnalytic('day')
  $inputFrom = $('#memberDateFrom').pickadate
    onStart: ->
      @set 'select', Session.get('memberStartDate')
    onSet: (e) ->
      Session.set 'memberStartDate', moment(e.select).startOf('days').valueOf()
      renderAnalytic('day')

  $inputTo = $('#memberDateTo').pickadate
    onStart: ->
      @set 'select', Session.get('memberEndDate')
    onSet: (e) ->
      Session.set 'memberEndDate', moment(e.select).startOf('days').valueOf()
      renderAnalytic('day')

  Deps.autorun ->
    if Session.get 'selectedMemberId'
      member = Members.findOne Session.get 'selectedMemberId'
      Meteor.subscribe 'counts-by-member', {deviceId: member.deviceId }

      Counts.findOne(Session.get 'selectedMemberId')
      renderAnalytic('day')

Template.memberStatistics.events
  'change #selected-member': (e, context) ->
    Session.set 'selectedMemberId', e.target.value
    renderAnalytic('day')