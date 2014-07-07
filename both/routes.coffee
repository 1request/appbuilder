Router.configure
  layoutTemplate: 'layout'
  loadingTemplate: 'loading'

Router.map ->
  @route 'main', { path: '/' }

  @route 'notification',
    path: '/app/:appKey/notification'
    waitOn: ->
      Meteor.subscribe 'notifications', { appKey: @params.appKey, type: 'instant' }

  @route 'mobileApp',
    path: 'app/:appKey/:deviceId'
    onBeforeAction: ->
      if @params.deviceId is 'notification'
        Router.go 'notification'
    onAfterAction: ->
      Session.set('mobileAppKey', @params.appKey)
      Session.set('deviceId', @params.deviceId)
    waitOn: ->
      createAppUser(@params)
      Meteor.subscribe 'mobileApps', { appKey: @params.appKey }
      Meteor.subscribe 'mobileAppUsers', { appKey: @params.appKey, deviceId: @params.deviceId }
      Meteor.subscribe 'counts-by-mobileAppUser', { appKey: @params.appKey, deviceId: @params.deviceId }

  @route 'monthlyLog',
    path: 'app/:appKey/:deviceId/monthly-log'
    onAfterAction: ->
      Session.set('mobileAppKey', @params.appKey)
      Session.set('deviceId', @params.deviceId)
    waitOn: ->
      Meteor.subscribe 'mobileAppUsers', { appKey: @params.appKey, deviceId: @params.deviceId }
      Meteor.subscribe 'counts-by-mobileAppUser', { appKey: @params.appKey, deviceId: @params.deviceId }

  @route 'dashboard',
    path: 'dashboard'
    waitOn: ->
      Meteor.subscribe 'mobileAppUsers', {}

  @route 'beacons',    { path: '/beacons',          controller: Beacons.index }
  @route 'newBeacon',  { path: '/beacons/new',      controller: Beacons.new }
  @route 'showBeacon', { path: '/beacons/:id',      controller: Beacons.show }
  @route 'editBeacon', { path: '/beacons/edit/:id', controller: Beacons.edit }

  @route 'mobileApps',    { path: '/apps',          controller: MobileApps.index }
  @route 'newMobileApp',  { path: '/apps/new',      controller: MobileApps.new }
  @route 'editMobileApp', { path: '/apps/edit',     controller: MobileApps.edit }

  @route 'instantNotifications', { path: '/apps/instantNotifications', controller: Notifications.instantNotifications }
  @route 'lbNotifications', { path: '/apps/lbNotifications', controller: Notifications.lbNotifications }
  @route 'newLbNotifications', { path: '/apps/lbNotifications/new/:zone', controller: Notifications.editLbNotifications }
  @route 'editLbNotifications', { path: '/apps/lbNotifications/edit/:zone/:id', controller: Notifications.editLbNotifications }
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
Router.onBeforeAction requireLogin, { except: ['main', 'mobileApp', 'notification', 'monthlyLog'] }
Router.onBeforeAction afterLogin, { only: 'main' }
Router.waitOn ->
  Meteor.subscribe 'mobileApps', {}
