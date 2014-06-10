@Members = new Meteor.Collection 'members'

Members.allow
  insert: (userId, doc) ->
    Mobile.findOne doc.appId

Members.deny
  insert: (userId, doc) ->
    Members.findOne doc.deviceId