Router.configure
  layoutTemplate: 'layout'
  waitOn: ->
    Meteor.subscribe 'mobile'

Router.map ->
  @route 'edit', { path: '/' }
  @route 'ibeacon', { path: 'config-ibeacon' }
  @route 'mobile', { path: 'mobile' }