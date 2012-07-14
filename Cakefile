fs = require('fs')
{print} = require('util')
{spawn} = require('child_process')

build = (callback) ->
  coffee = spawn('coffee', ['-c', '-o', './js', './js'])
  jade = spawn('jade', ['-P', '-O', './', './'])
  stylus = spawn('stylus', ['./css'])

  coffee.stderr.on 'data', (data) ->
    process.stderr.write(data.toString())

  coffee.stdout.on 'data', (data) ->
    print(data.toString)

  coffee.on 'exit', (code) ->
    callback?() if code is 0

  jade.stderr.on 'data', (data) ->
    process.stderr.write(data.toString())

  jade.stdout.on 'data', (data) ->
    #print(data.toString)

  jade.on 'exit', (code) ->
    callback?() if code is 0

  stylus.stderr.on 'data', (data) ->
    process.stderr.write(data.toString())

  stylus.stdout.on 'data', (data) ->
    #print(data.toString)

  stylus.on 'exit', (code) ->
    callback?() if code is 0

task 'build', 'Build CoffeeScript, Jade, & Stylus', ->
  build()

task 'watch', 'Watch CoffeeScript & Stylus', ->
  # FIXME: These processes will be conflicted
  coffee = spawn('coffee', ['-w', '-c', '-o', './js', './js'])
  stylus = spawn('stylus', ['-w', './css'])

  coffee.stderr.on 'data', (data) ->
    process.stderr.write(data.toString())

  coffee.stdout.on 'data', (data) ->
    print(data.toString())

  stylus.stderr.on 'data', (data) ->
    process.stderr.write(data.toString())

  stylus.stdout.on 'data', (data) ->
    #print(data.toString())

task 'open', 'Open index.html', ->
  spawn('open', 'index.html')
  invoke('watch')

