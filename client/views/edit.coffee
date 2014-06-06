Template.edit.helpers
  mobiles: ->
    Mobile.find()
  mobile: ->
    Mobile.findOne(Session.get 'selectedMobileId')
  selectedMobileId: ->
    Session.get 'selectedMobileId'
  selectedDeviceId: ->
    Session.get 'selectedDeviceId'


Template.edit.rendered = ->
  Session.setDefault('selectedMobileId', Mobile.findOne()._id)
  Session.setDefault('selectedDeviceId', Members.findOne(appId: Session.get 'selectedMobileId').deviceId)

Template.edit.events
  'keyup input[name=title]': (e, context) ->
    Mobile.update e.target.dataset.id, $set: {title: e.target.value}

  'keyup input[name=imageUrl]': (e, context) ->
    if /\.(jpg|gif|png)$/.test e.target.value
      Mobile.update e.target.dataset.id, $addToSet: {imageUrls: e.target.value}
      e.target.value = ''
      throwAlert 'image added successfully'
      Meteor.setTimeout ->
        clearAlerts()
      , 1500
      document.getElementById('iphone').contentWindow.location.reload(true)

  'submit form': (e) ->
    e.preventDefault()

  'change #selected-app': (e, context) ->
    Session.set 'selectedMobileId', e.target.value