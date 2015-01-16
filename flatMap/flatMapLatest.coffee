chalk = require 'chalk'
Bacon = require 'baconjs'

sourceLog = console.log.bind console, chalk.green 'source'
emitLog = console.log.bind console, chalk.red 'emit'

ayncServer = (name, cb) ->
    delay = Math.random() * 100 // 1
    sourceLog name, delay

    setTimeout ->
        cb null, name
    , delay

inc = (seed, curr) -> seed + curr
counter = Bacon.interval(30, 1).scan 0, inc

counter.flatMapLatest (c) ->
    Bacon.fromNodeCallback ayncServer.bind null, c
.onValue emitLog