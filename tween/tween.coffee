Bacon = require 'baconjs'

raf = Bacon.fromBinder (sink) ->
    window = window ? global

    request =
        window.requestAnimationFrame        ?
        window.webkitRequestAnimationFrame  ?
        window.mozRequestAnimationFrame     ?
        window.oRequestAnimationFrame       ?
        window.msRequestAnimationFrame      ?
        (f) -> window.setTimeout f, 1e3 / 60

    subscribed = true
    prevTs = +new Date

    handler = ->
        if subscribed
            currTs = +new Date
            sink currTs - prevTs
            prevTs = currTs
            request handler

    request handler

    ->
        subscribed = false

tween = (opt) ->
    from = opt?.from ? 0
    to = opt?.to ? 1
    duration = opt?.duration ? 1000

    [from, to] = [to, from] if from > to

    step = (to - from) / duration
    curr = from

    Bacon.constant(step).sampledBy raf, (_, ms) ->
        curr = curr + step * ms
        if step > 0
            if curr > to
                step = -step
                curr = to

        else if curr < from
            step = -step
            curr = from
        curr
    .toProperty from

tween(from: 100, to: -100, duration: 1000).log 'tween 1'
# tween(from: -1, to: 1, duration: 1000).log 'tween 2'