runSelect2 = ->
  $('#tags').select2
    tags: _.pluck Tags.find().fetch(), 'text'
  $('#tags').select2('val', Session.get('selectedTags'))

setSelectedTags = (tags) ->
  _.pluck(Tags.find(_id: {$in: tags}).fetch(), 'text')

Template.edit.helpers
  mobiles: ->
    Mobile.find()
  mobile: ->
    Mobile.findOne(Session.get 'selectedMobileId')
  selectedMobileId: ->
    Session.get 'selectedMobileId'
  selectedDeviceId: ->
    Session.get 'selectedDeviceId'
  path: ->
    Router.routes['mobile'].path({deviceId: Session.get 'selectedDeviceId'})
  selectedTags: ->
    if Session.get 'selectedTags'
      _.pluck(Tags.find(text: {$in: Session.get 'selectedTags'}).fetch(), 'text').join(',')

Template.edit.rendered = ->
  Session.setDefault('selectedMobileId', Mobile.findOne()._id)
  Session.setDefault('selectedTags', setSelectedTags(Mobile.findOne().tags))
  Session.setDefault('selectedDeviceId', Members.findOne(appId: Session.get 'selectedMobileId').deviceId)
  runSelect2()

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
    Session.set 'selectedDeviceId', Members.findOne(appId: e.target.value).deviceId
    mobile = Mobile.findOne(Session.get('selectedMobileId'))
    Session.set 'selectedTags', setSelectedTags(mobile.tags)
    runSelect2()

  'change #tags': (e) ->
    mobile = Mobile.findOne Session.get('selectedMobileId')
    if e.added
      Mobile.update mobile._id, $addToSet: {tags: Tags.findOne(text: e.added.text)._id}
    else
      Mobile.update mobile._id, $pull: {tags: Tags.findOne(text: e.removed.text)._id}




