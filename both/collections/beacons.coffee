@Beacons = new Meteor.Collection 'beacons'

Meteor.methods
  'createBeacon': (beaconAttributes) ->
    user = Meteor.user()

    unless user
      throw new Meteor.Error(401, 'You need to login to add new beacons')

    unless beaconAttributes.uuid or beaconAttributes.major or beaconAttributes.minor
      throw new Meteor.Error(422, 'Please fill in uuid, major, minor')

    beaconAttributes.tags = [] unless beaconAttributes.tags

    beacon = _.extend(_.pick(beaconAttributes, 'uuid', 'major', 'minor', 'tags', 'notes'), {
      userId: user._id
      })

    beaconId = Beacons.insert beacon

Beacons.allow
  insert: (userId, doc) ->
    !! userId

Beacons.after.insert (userId, doc) ->
  for tag in doc.tags
    Tags.update tag, $addToSet: { beacons: doc._id }