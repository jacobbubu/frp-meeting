Bacon.Observable.prototype.slidingWindowBy = (lengthObs) ->
    self = @
    new Bacon.EventStream (sink) ->
        buf = []
        length = 0

        lengthObs.onValue (n) ->
            length = n

        self.onValue (x) ->
            buf.unshift x
            buf = buf[0...length]
            sink new Bacon.Next buf

        ->

Bacon.separateBy = (sep, obs) ->
    return obs().changes().concat sep.take(1).flatMap ->
        Bacon.separateBy sep, obs

contains = (arr, x) ->
    for a in arr
        return true if a.equals x
    false

window.contains = contains