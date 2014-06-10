@Members = new Meteor.Collection 'members'

Members.allow
  insert: (userId, doc) ->
    Mobile.findOne doc.appId