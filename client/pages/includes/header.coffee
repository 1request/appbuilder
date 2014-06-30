Template.appSelect.helpers
  hasMobileApp: ->
    MobileApps.findOne()
  mobileApps: ->
    MobileApps.find()
  mobileApp: ->
    mobileApp = MobileApps.findOne(appKey: Session.get 'mobileAppKey')
  mobileAppName: ->
    mobileApp = MobileApps.findOne(appKey: Session.get 'mobileAppKey')
    if mobileApp
      mobileApp.name + '<br/>' + 'App Key: ' + mobileApp.appKey
    else
      'Please select an App'
  mobileAppKey: ->
    mobileApp = MobileApps.findOne(appKey: Session.get 'mobileAppKey')
    if mobileApp
      'App Key: ' + mobileApp.appKey


Template.appSelect.events
  'click li': (e) ->
    if @appKey
      Session.set('mobileAppKey', @appKey)
      mobileApp = MobileApps.findOne(appKey: @appKey)
      Session.set 'selectedTags', setSelectedTags(mobileApp.tags)
      runSelect2()

Template.appSelect.rendered = ->
  @mobileAppDep = Deps.autorun ->
    if MobileApps.findOne()
      Session.setDefault('mobileAppKey', MobileApps.findOne().appKey)
      app = MobileApps.findOne(appKey: Session.get 'mobileAppKey')
      Session.set('selectedTags', setSelectedTags(app.tags))
      runSelect2()

Template.appSelect.destroyed = ->
  if @mobileAppDep
    @mobileAppDep.stop()