Meteor.publish 'mobile', ->
  Mobile.find()

Meteor.publish 'beacons', ->
  Beacons.find()

Meteor.publish 'tags', ->
  Tags.find()