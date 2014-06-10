@Beacons = new Meteor.Collection 'beacons'

Meteor.methods
  'createBeacon': (beaconAttributes) ->
    user = Meteor.user()

    unless user
      throw new Meteor.Error(401, 'You need to login to add new beacons')

    unless beaconAttributes.uuid or beaconAttributes.major or beaconAttributes.minor
      throw new Meteor.Error(422, 'Please fill in uuid, major, minor')

    tags = if beaconAttributes.tags
      _.flatten [beaconAttributes.tags.split(',')]
    else
      beaconAttributes.tags = []
    beacon = _.extend(_.pick(beaconAttributes, 'uuid', 'major', 'minor', 'notes'), {
      userId: user._id
      tags: tags
      })

    beaconId = Beacons.insert beacon

  'destroyBeacon': (beaconId) ->
    user = Meteor.user()
    unless user
      throw new Meteor.Error(401, 'You need to login to delete existing beacons')

    Beacons.remove beaconId

Beacons.allow
  insert: (userId, doc) ->
    !! userId

Beacons.after.insert (userId, doc) ->
  for tag in doc.tags
    Tags.upsert {name: tag, userId: doc.userId}, $addToSet: { beacons: doc._id }
  tag_ids = _.pluck Tags.find(name: {$in: doc.tags}).fetch(), '_id'
  Beacons.update doc._id, {
    $set: {tags: tag_ids}
  }

Beacons.after.remove (userId, doc) ->
  for tag in Tags.find(beacons: doc._id).fetch()
    Tags.update tag._id, $pull: { beacons: doc._id }
