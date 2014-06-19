Template.editMobileApp.helpers
  mobileApps: ->
    MobileApps.find()
  mobileApp: ->
    MobileApps.findOne(appKey: Session.get 'mobileAppKey')
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
      Session.setDefault('mobileAppKey', MobileApps.findOne().appKey)
      app = MobileApps.findOne(appKey: Session.get 'mobileAppKey')
      Session.set('selectedTags', setSelectedTags(app.tags))
      Session.set('deviceId', MobileAppUsers.findOne(appKey: Session.get 'mobileAppKey').deviceId)
      $('#selected-app').val("#{Session.get 'mobileAppKey'}")
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
    Session.set 'mobileAppKey', e.target.value
    Session.set 'deviceId', MobileAppUsers.findOne(appKey: e.target.value).deviceId
    mobileApp = MobileApps.findOne(appKey: e.target.value)
    Session.set 'selectedTags', setSelectedTags(mobileApp.tags)
    runSelect2()

  'change #tags': (e) ->
    mobileApp = MobileApps.findOne(appKey: Session.get('mobileAppKey'))
    if e.added
      MobileApps.update mobileApp._id, $addToSet: {tags: Tags.findOne(text: e.added.text)._id}
    else
      MobileApps.update mobileApp._id, $pull: {tags: Tags.findOne(text: e.removed.text)._id}

Template.editMobileApp.destroyed = ->
  if @editMobileAppDep
    @editMobileAppDep.stop()
