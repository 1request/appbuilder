@Notifications = new Meteor.Collection 'notifications'

Meteor.methods
  'createNotification': (attributes) ->
    user = Meteor.user()

    unless user
      throw new Meteor.Error(401, 'You need to login before sending notification')

    unless !!attributes.appKey
      throw new Meteor.Error(422, 'Please select an app')

    unless !!attributes.message
      throw new Meteor.Error(422, 'Please fill in message')

    notification = 
      appKey    : attributes.appKey
      message   : attributes.message
      url       : attributes.url
      createdAt : Date.now()
    Notifications.insert notification