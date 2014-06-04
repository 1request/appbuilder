@Logs = new Meteor.Collection 'logs'

if Meteor.isServer
  Meteor.startup ->
    logsAPI = new CollectionAPI
    logsAPI.addCollection Logs, 'logs',
      methods: ['POST', 'GET']
    logsAPI.start()

updateResult = (doc) ->
  beacon = Beacons.findOne { uuid: doc.uuid, major: doc.major, minor: doc.minor }
  Beacons.update beacon._id, {$inc: {count: 1}}

Logs.after.insert (userId, doc) ->
  updateResult(doc)