Template.mobileApp.created = ->
  loadResources()

Template.mobileApp.helpers
  mobileApp: ->
    MobileApps.findOne(appKey: Session.get('mobileAppKey'))
  notificationPath: ->
    Router.routes['notification'].path({ appKey: Session.get('mobileAppKey') })
  count: ->
    Session.get 'monthCount'
  path: ->
    if MobileAppUsers.findOne(Session.get('deviceId')) and MobileApps.findOne(appKey: Session.get('mobileAppKey'))
      Router.routes['monthlyLog'].path({deviceId: Session.get('deviceId'), appKey: Session.get('mobileAppKey') })

Template.mobileApp.rendered = ->
  $('nav#menu').mmenu
    searchfield : true
    slidingSubmenus: true

  @countDep = Deps.autorun ->
    Counts.findOne()
    Meteor.call 'monthlyCount', Session.get('deviceId'), Session.get('mobileAppKey'), (error, result) ->
      Session.set 'monthCount', result

Template.mobileApp.destroyed = ->
  removeResources()
  location.reload()
  if @countDep
    @countDep.stop()
