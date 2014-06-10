if Meteor.isServer
  Meteor.startup ->
    collectionAPI = new CollectionAPI
    collectionAPI.addCollection Logs, 'logs',
      methods: ['POST', 'GET']
    collectionAPI.addCollection Members, 'members',
      methods: ['POST', 'GET']
      before:
        POST: (doc) ->
          !Members.findOne deviceId: doc.deviceId
    collectionAPI.start()
