Template.beacons.helpers
  beacons: ->
    beacons = Beacons.find().fetch()
    index = 1
    beacons.map (o, i) ->
      beacons[i].index = index++
    beacons

Template.beacons.events
Template.beacons.rendered = ->