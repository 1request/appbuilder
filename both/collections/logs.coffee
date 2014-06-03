@Logs = new Meteor.Collection 'logs'

updateResult = (doc) ->
  beacon = Beacons.findOne { uuid: doc.uuid, major: doc.major, minor: doc.minor }
  Beacons.update beacon._id, {$inc: {count: 1}}

Logs.after.insert (userId, doc) ->
  updateResult(doc)