Template.editMobileApp.helpers
  mobileApps: ->
    MobileApps.find()
  mobileApp: ->
    MobileApps.findOne(Session.get 'mobileAppId')
  mobileAppId: ->
    Session.get 'mobileAppId'
  deviceId: ->
    Session.get 'deviceId'
  path: ->
    Router.routes['mobileApp'].path({deviceId: Session.get 'deviceId'})
  selectedTags: ->
    if Session.get 'selectedTags'
      _.pluck(Tags.find(text: {$in: Session.get 'selectedTags'}).fetch(), 'text').join(',')

Template.editMobileApp.rendered = ->

  @editMobileAppDep = Deps.autorun ->
    if MobileApps.findOne()
      Session.set('mobileAppId', MobileApps.findOne()._id)
      Session.set('selectedTags', setSelectedTags(MobileApps.findOne().tags))
      Session.set('deviceId', MobileAppUsers.findOne(appId: Session.get 'mobileAppId').deviceId)
      runSelect2()

Template.editMobileApp.events
  'keyup input[name=title]': (e, context) ->
    MobileApps.update e.target.dataset.id, $set: {title: e.target.value}

  'keyup input[name=imageUrl]': (e, context) ->
    if /\.(jpg|gif|png)$/.test e.target.value
      MobileApps.update e.target.dataset.id, $addToSet: {imageUrls: e.target.value}
      e.target.value = ''
      throwAlert 'image added successfully'
      Meteor.setTimeout ->
        clearAlerts()
      , 1500
      document.getElementById('iphone').contentWindow.location.reload(true)

  'submit form': (e) ->
    e.preventDefault()

  'change #selected-app': (e, context) ->
    Session.set 'mobileAppId', e.target.value
    Session.set 'deviceId', MobileAppUsers.findOne(appId: e.target.value).deviceId
    mobileApp = MobileApps.findOne(Session.get('mobileAppId'))
    Session.set 'selectedTags', setSelectedTags(mobileApp.tags)
    runSelect2()

  'change #tags': (e) ->
    mobileApp = MobileApps.findOne Session.get('mobileAppId')
    if e.added
      MobileApps.update mobileApp._id, $addToSet: {tags: Tags.findOne(text: e.added.text)._id}
    else
      MobileApps.update mobileApp._id, $pull: {tags: Tags.findOne(text: e.removed.text)._id}

Template.editMobileApp.destroyed = ->
  if @editMobileAppDep
    @editMobileAppDep.stop()
