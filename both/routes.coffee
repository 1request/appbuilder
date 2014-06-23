Router.configure
  layoutTemplate: 'layout'
  loadingTemplate: 'loading'

Router.map ->
  @route 'main', { path: '/' }

  @route 'mobileApp',
    path: 'app/:appKey/:deviceId'
    waitOn: ->
      createAppUser(@params)
      Meteor.subscribe 'mobileTags', { deviceId: @params.deviceId }
      Meteor.subscribe 'mobileApps', { deviceId: @params.deviceId }
      Meteor.subscribe 'mobileAppUsers', { deviceId: @params.deviceId }
      Meteor.subscribe 'counts-by-mobileAppUser', { deviceId: @params.deviceId }

  @route 'dashboard',
    path: 'dashboard'
    waitOn: ->
      Meteor.subscribe 'mobileApps', {}
      Meteor.subscribe 'mobileAppUsers', {}

  @route 'beacons',    { path: '/beacons',          controller: Beacons.index }
  @route 'newBeacon',  { path: '/beacons/new',      controller: Beacons.new }
  @route 'showBeacon', { path: '/beacons/:id',      controller: Beacons.show }
  @route 'editBeacon', { path: '/beacons/edit/:id', controller: Beacons.edit }

  @route 'mobileApps',    { path: '/apps',          controller: MobileApps.index }
  @route 'newMobileApp',  { path: '/apps/new',      controller: MobileApps.new }
  @route 'editMobileApp', { path: '/apps/edit',     controller: MobileApps.edit }

  @route 'newNotification',  { path: '/notifications/new',      controller: Notifications.new }

requireLogin = (pause) ->
  unless Meteor.user()
    if Meteor.loggingIn()
      @render @loadingTemplate
    else
      Router.go 'main'
    pause()

afterLogin = (pause) ->
  if Meteor.user()
    Router.go 'editMobileApp'
    pause()

createAppUser = (params) ->
  Meteor.call 'createMobileAppUser', params.appKey, params.deviceId

Router.onBeforeAction 'loading'
Router.onBeforeAction -> clearAlerts()
Router.onBeforeAction requireLogin, { except: ['main', 'mobileApp'] }
Router.onBeforeAction afterLogin, { only: 'main' }