@Images = new FS.Collection 'images',
  stores: [new FS.Store.FileSystem('images', path: "#{Meteor.settings.public.storageDirectory}/images")]
  filter:
    allow:
      contentTypes: ['image/*']
    onInvalid: (message) ->
      if Meteor.isClient
        throwAlert message

Images.allow
  'insert': (userId, doc) ->
    true
  'update': (userId, doc) ->
    true
  'download': (userId, doc) ->
    true