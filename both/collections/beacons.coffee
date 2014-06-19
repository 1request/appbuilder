@Beacons = new Meteor.Collection 'beacons'

processBeaconData = (beaconAttributes) ->
  user = Meteor.user()

  unless user
    throw new Meteor.Error(401, 'You need to login to add new beacons')

  unless beaconAttributes.uuid or beaconAttributes.major or beaconAttributes.minor
    throw new Meteor.Error(422, 'Please fill in uuid, major, minor')

  tags = if beaconAttributes.tags
    _.flatten [beaconAttributes.tags.split(',')]
  else
    beaconAttributes.tags = []
  beacon = _.extend(_.pick(beaconAttributes, '_id', 'uuid', 'major', 'minor', 'notes'), {
    userId: user._id
    tags: tags
    })

Meteor.methods
  'createBeacon': (beaconAttributes) ->
    beacon = processBeaconData(beaconAttributes)
    beaconId = Beacons.insert beacon

  'updateBeacon': (beaconAttributes) ->
    beacon = processBeaconData(beaconAttributes)
    Beacons.update beacon._id, $set: {
      uuid: beacon.uuid,
      major: beacon.major,
      minor: beacon.minor,
      notes: beacon.notes,
      tags: beacon.tags,
      userId: beacon.userId
    }

  'destroyBeacon': (beaconId) ->
    user = Meteor.user()
    unless user
      throw new Meteor.Error(401, 'You need to login to delete existing beacons')

    Beacons.remove beaconId

Beacons.allow
  insert: (userId, doc) ->
    !! userId

Beacons.before.insert (userId, doc) ->
  for tag in doc.tags
    Tags.upsert {text: tag, userId: doc.userId}, $addToSet: { beacons: doc._id }
  doc.tags = _.pluck Tags.find(text: {$in: doc.tags}).fetch(), '_id'
  doc.createdAt = Date.now()
  doc.updatedAt = doc.createdAt

Beacons.before.update (userId, doc, fieldNames, modifier, options) ->
  for tag in doc.tags
    Tags.update tag._id, $pull: { beacons: doc._id }
  for tag in modifier.$set.tags
    Tags.upsert {text: tag, userId: doc.userId}, $addToSet: { beacons: doc._id }
  tag_ids = _.pluck Tags.find(text: {$in: modifier.$set.tags}).fetch(), '_id'
  modifier.$set.tags = tag_ids
  modifier.$set.updatedAt = Date.now()

Beacons.after.remove (userId, doc) ->
  for tag in Tags.find(beacons: doc._id).fetch()
    Tags.update tag._id, $pull: { beacons: doc._id }
