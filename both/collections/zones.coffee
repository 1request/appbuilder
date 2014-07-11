@Zones = new Meteor.Collection 'zones'

Zones.before.insert (userId, doc) ->
  doc.createdAt = Date.now()
  doc.updatedAt = doc.createdAt

Zones.before.update (userId, doc, fieldNames, modifier, options) ->
  modifier.$set = modifier.$set || {}
  modifier.$set.updatedAt = Date.now()

Meteor.methods
  'updateZone': (zoneAttributes) ->
    Zones.update zoneAttributes._id,
      $set:
        area: zoneAttributes.area

