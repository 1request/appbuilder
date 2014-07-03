@Beacons = new Meteor.Collection 'beacons'

processBeaconData = (beaconAttributes) ->
  user = Meteor.user()

  unless user
    throw new Meteor.Error(401, 'You need to login to add new beacons')

  unless beaconAttributes.uuid or beaconAttributes.major or beaconAttributes.minor
    throw new Meteor.Error(422, 'Please fill in uuid, major, minor')

  zones = if beaconAttributes.zones
    _.flatten [beaconAttributes.zones.split(',')]
  else
    beaconAttributes.zones = []
  beacon = _.extend(_.pick(beaconAttributes, '_id', 'uuid', 'notes'), {
    userId: user._id
    zones: zones
    major: parseInt(beaconAttributes.major)
    minor: parseInt(beaconAttributes.minor)
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
      zones: beacon.zones,
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
  for zone in doc.zones
    Zones.upsert {text: zone, userId: doc.userId}, $addToSet: { beacons: doc._id }
  doc.zones = _.pluck Zones.find(text: {$in: doc.zones}).fetch(), '_id'
  doc.createdAt = Date.now()
  doc.updatedAt = doc.createdAt

Beacons.before.update (userId, doc, fieldNames, modifier, options) ->
  for zone in doc.zones
    Zones.update zone._id, $pull: { beacons: doc._id }
  for zone in modifier.$set.zones
    Zones.upsert {text: zone, userId: doc.userId}, $addToSet: { beacons: doc._id }
  zone_ids = _.pluck Zones.find(text: {$in: modifier.$set.zones}).fetch(), '_id'
  modifier.$set.zones = zone_ids
  modifier.$set.updatedAt = Date.now()

Beacons.after.remove (userId, doc) ->
  for zone in Zones.find(beacons: doc._id).fetch()
    Zones.update zone._id, $pull: { beacons: doc._id }
