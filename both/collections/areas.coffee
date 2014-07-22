@Areas = new Meteor.Collection 'areas'

Meteor.methods
  'updateArea': (areaAttributes) ->
    unless Meteor.user()
      throw new Meteor.Error(401, 'You need to login to edit area')
    setOpt =
      name: areaAttributes.name
    if !!areaAttributes.imageId
      _.extend(setOpt, {imageId: areaAttributes.imageId})
    Areas.update areaAttributes._id,
      $set: setOpt

Areas.before.insert (userId, doc) ->
  doc.createdAt = Date.now()
  doc.updatedAt = doc.createdAt

Areas.before.update (userId, doc, fieldNames, modifier, options) ->
  modifier.$set.updatedAt = Date.now()