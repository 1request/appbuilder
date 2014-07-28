exec = Npm.require('child_process').exec

Meteor.methods
  'testCORS': (url) ->
    exec = Npm.require('child_process').exec
    Future = Npm.require 'fibers/future'

    fut = new Future()
    if !!url
      exec "curl --head --location #{url}", (error, stdout, stderr) ->
        console.log stdout
        if /((X-Frame-Options: SAMEORIGIN)|('X-Frame-Options: deny'))/i.test(stdout)
          fut.return('/cors')
        else
          fut.return(url)
    else
      fut.return('/cors')

    fut.wait()