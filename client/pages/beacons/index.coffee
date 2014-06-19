Template.beacons.helpers
  beacons: ->
    beacons = Beacons.find({}, {sort: {createdAt: 1}}).fetch()
    index = 1
    beacons.map (o, i) ->
      beacons[i].index = index++
    beacons

Template.beacons.events
Template.beacons.rendered = ->