class Pos
    constructor: (@x, @y) ->
    equals: (p) ->
        (@x is p.x) and (@y is p.y)

    add: (p) ->
        new Pos(
            (@x + p.x + size.x) % size.x,
            (@y + p.y + size.y) % size.y
        )

Vector2 = Pos

size = new Pos 20, 20

randomPos = ->
    new Pos(
        Math.floor(Math.random() * size.x),
        Math.floor(Math.random() * size.y)
    )

rotateRight = (vec) ->
    new Vector2 -vec.y, vec.x

rotateLeft = (vec) ->
    new Vector2 vec.y, -vec.x

window.Pos          = Pos
window.Vector2      = Vector2
window.size         = size
window.randomPos    = randomPos
window.rotateRight  = rotateRight
window.rotateLeft   = rotateLeft