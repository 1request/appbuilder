@Images = new FS.Collection 'images',
  stores: [
    new FS.Store.FileSystem 'images',
      path: "#{Meteor.settings.public.storageDirectory}/images"
    new FS.Store.FileSystem 'thumbs',
      path: "#{Meteor.settings.public.storageDirectory}/thumbs"
      transformWrite: (fileObj, readStream, writeStream) ->
        gm(readStream, fileObj.name()).resize('60').stream().pipe(writeStream)
  ]
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

Images.deny
  'insert': (userId, doc) ->
    doc.owner isnt userId