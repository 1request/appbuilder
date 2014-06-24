Template.mobileApp.created = ->
  loadResources()

Template.mobileApp.helpers
  mobileApp: ->
    MobileApps.findOne()
  notificationPath: ->
    Router.routes['notification'].path({ appKey: Session.get('mobileAppKey') })
  count: ->
    Session.get 'monthCount'
  path: ->
    if MobileAppUsers.findOne() and MobileApps.findOne()
      Router.routes['monthlyLog'].path({deviceId: MobileAppUsers.findOne().deviceId, appKey: Session.get('mobileAppKey') })

Template.mobileApp.rendered = ->
  $('nav#menu').mmenu
    searchfield : true
    slidingSubmenus: true

  @countDep = Deps.autorun ->
    Counts.findOne()
    Meteor.call 'monthlyCount', MobileAppUsers.findOne().deviceId, (error, result) ->
      Session.set 'monthCount', result

Template.mobileApp.destroyed = ->
  removeResources()
  location.reload()
  if @countDep
    @countDep.stop()
