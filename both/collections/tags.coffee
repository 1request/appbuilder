@Tags = new Meteor.Collection 'tags'

Tags.before.insert (userId, doc) ->
  doc.createdAt = Date.now()
  doc.updatedAt = doc.createdAt

Tags.before.update (userId, doc, fieldNames, modifier, options) ->
  modifier.$set = modifier.$set || {}
  modifier.$set.updatedAt = Date.now()