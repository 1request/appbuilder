Router.configure
  layoutTemplate: 'layout'
  loadingTemplate: 'loading'

Router.map ->
  @route 'main', { path: '/' }
  @route 'edit',
    path: 'edit'
    waitOn: ->
      Meteor.subscribe 'mobile', {}
      Meteor.subscribe 'members', {}
  @route 'ibeacon', { path: 'config-ibeacon' }
  @route 'mobile',
    path: 'mobile/:_id'
    waitOn: ->
      [
        Meteor.subscribe 'tags', { appId: @params._id }
        Meteor.subscribe 'mobile', { appId: @params._id }
        Meteor.subscribe 'members', { memberId: @params.memberId }
        Meteor.subscribe 'logs', { memberId: @params.memberId }
        Meteor.subscribe 'beacons', { appId: @params._id }
      ]
  @route 'dashboard',
    path: 'dashboard'
    waitOn: ->
      [
        Meteor.subscribe 'logs', {}
        Meteor.subscribe 'mobile', {}
        Meteor.subscribe 'members', {}
      ]

requireLogin = (pause) ->
  unless Meteor.user()
    if Meteor.loggingIn()
      @render @loadingTemplate
    else
      Router.go 'main'
    pause()

afterLogin = (pause) ->
  if Meteor.user()
    Router.go 'edit'
    pause()

Router.onBeforeAction 'loading'
Router.onBeforeAction -> clearAlerts()
Router.onBeforeAction requireLogin, { except: ['main', 'mobile'] }
Router.onBeforeAction afterLogin, { only: 'main' }