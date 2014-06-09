@Beacons = new Meteor.Collection 'beacons'

Beacons.allow
  insert: (userId, doc) ->
    !! userId

Beacons.after.insert (userId, doc) ->
  for tag in doc.tags
    Tags.update tag, $addToSet: { beacons: doc._id }