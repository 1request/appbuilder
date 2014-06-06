
filterLogs = (appId) ->
  membersDevices = _.pluck Members.find(appId: appId).fetch(), 'deviceId'
  Logs.find(deviceId: {$in: membersDevices}).fetch()

lineCharts = (data, tick) ->
  lineChart = $.plotAnimator $('#graph-member-lines'), data,
    xaxis:
      tickLength: 0
      tickDecimals: 0
      min: 0
      ticks: tick
      font:
        lineHeight: 12
        weight: "bold"
        family: "Open sans"
        color: "#8D8D8D"
    yaxis:
      ticks: 5
      tickDecimals: 0
      tickColor: "#f3f3f3"
      font:
        lineHeight: 13
        weight: "bold"
        family: "Open sans"
        color: "#8D8D8D"
    grid:
      backgroundColor:
        colors: ["#fff", "#fff"]
      borderColor: "transparent"
      margin: 0
      minBorderMargin: 0
      labelMargin: 15
      hoverable: true
      clickable: true
      mouseActiveRadius: 4
    legend:
      show: false

renderDailyChart = (data, startDate, days) ->
  graph_lines = [{
    label: "Line 1"
    data: data
    lines:
      lineWidth: 2
    shadowSize: 0
    color: '#3598DB'
  }, {
    label: "Line 1"
    data: data
    points:
      show: true
      fill: true
      radius: 6
      fillColor: "#3598DB"
      lineWidth: 3
    color: '#fff'
  }]
  console.log 'ticks', ticks = [0..days].map (i) ->
    [i, moment(startDate).add('days', i).format('YYYY-MM-DD')]
  lineCharts(graph_lines, ticks)

showTooltip = (x, y, contents) ->
  $('<div id="flot-tooltip">' + contents + '</div>').css(
    position: 'absolute'
    display: 'none'
    top: y + 5
    left: x + 5
    color: '#fff'
    padding: '2px 5px'
    'background-color': '#717171'
    opacity: 0.80
  ).appendTo("body").fadeIn(200)

renderAnalytic = (type) ->
  member = Members.findOne(Session.get 'selectedMemberId')
  startDate = Session.get('startDate')
  endDate = Session.get('endDate')
  totalDays = moment(endDate).diff(moment(startDate), 'days')
  if totalDays
    Meteor.call 'getMemberAnalytic', member.deviceId, startDate, endDate, type, (error, result) ->
      console.log 'result', result
      renderDailyChart result, moment(startDate).valueOf(), totalDays

      $("#graph-member-lines").bind "plothover", (event, pos, item) ->
        $("#x").text pos.x.toFixed(0)
        $("#y").text pos.y.toFixed(0)
        if item
          if previousPoint != item.dataIndex
            previousPoint = item.dataIndex
            $("#flot-tooltip").remove()
            x = item.datapoint[0].toFixed(0)
            y = item.datapoint[1].toFixed(0)
            showTooltip(item.pageX, item.pageY, y + " times")
        else
          $("#flot-tooltip").remove()
          previousPoint = null

Template.dashboard.helpers
  mobiles: ->
    Mobile.find()
  mobile: ->
    Mobile.findOne(Session.get 'selectedMobileId')
  members: ->
    Members.find(appId: Session.get 'selectedMobileId')
  memberDailyData: ->
    Session.get('memberDailyData')
  member: ->
    Members.findOne(Session.get 'selectedMemberId')

Template.dashboard.rendered = ->
  Session.setDefault('selectedMobileId', Mobile.findOne()._id)
  Session.setDefault('startDate', moment().startOf('day').subtract('days', 6).valueOf())
  Session.setDefault('endDate', moment().startOf('day').valueOf())
  Session.setDefault('selectedMemberId', Members.findOne(appId: Session.get 'selectedMobileId')._id)
  renderAnalytic('day')

  $inputFrom = $('#dateFrom').pickadate
    onStart: ->
      @set 'select', Session.get('startDate')
    onSet: (e) ->
      console.log 'e', e
      Session.set 'startDate', moment(e.select).startOf('days').valueOf()
      renderAnalytic('day')

  $inputTo = $('#dateTo').pickadate
    onStart: ->
      @set 'select', Session.get('endDate')
    onSet: (e) ->
      console.log 'e', e
      Session.set 'endDate', moment(e.select).startOf('days').valueOf()
      renderAnalytic('day')

Template.dashboard.events
  'change #selected-app': (e, context) ->
    Session.set 'selectedMobileId', e.target.value
