lineCharts = (graphId, data, tick) ->
  lineChart = $.plotAnimator $(graphId), data,
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

@renderDailyChart = (graphId, data, startDate, days) ->
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
  ticks = [0..days].map (i) ->
    [i, moment(startDate).add('days', i).format('YYYY-MM-DD')]
  lineCharts(graphId, graph_lines, ticks)
  setHover(graphId)

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

setHover = (graphId) ->
  $(graphId).bind "plothover", (event, pos, item) ->
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

@showAction = (action) ->
  switch action
    when 'message'  then 'Message only'
    when 'url'      then 'Open web page'
    when 'image'    then 'Open image'
    when 'video'    then 'Open video'
    when 'floorplan' then 'Open area floorplan'

@showTrigger = (trigger) ->
  switch trigger
    when 'enter' then "enters region"
    when 'immediate' then "is immediate to region"
    when 'near' then "is near to region"
    when 'far' then "is far from region"

@setDropZone = ->
  dropzoneOptions =
    addRemoveLinks: true
    acceptedFiles: 'image/*'
    maxFiles: 1

  dropZone = new Dropzone('#dropzone', dropzoneOptions)

  dropZone.on 'addedfile', (file) ->
    fsFile = new FS.File(file)
    fsFile.owner = Meteor.userId()
    Images.insert fsFile, (error, fileObj) ->
      Session.set('imageId', fileObj._id)

  dropZone.on 'success', (file) ->
    throwAlert 'Image uploaded'
