drawGame = (size) ->
    game = $ '#game'
    for i in [0...size.x]
        row = $('<div class="row" />')
        for j in [0...size.y]
            row.append '<span class="cell" />'
        game.append row

fillCells = (klass) ->
    game = $ '#game'
    (ps) ->
        game.find('.cell').removeClass klass
        for p in ps
            game.find '.row:eq(' + p.y + ')'
                .find '.cell:eq(' + p.x + ')'
                .addClass klass

drawApple = fillCells 'apple'
drawSnake = fillCells 'snake'

logRestart = ->
    $('#log').html "Press 'r' to restart"

logClear = ->
    $('#log').html 'Press left/right to steer.'

$score = $('#score')
setScore = (score) ->
    $score.html score

window.drawGame     = drawGame
window.drawApple    = drawApple
window.drawSnake    = drawSnake
window.logRestart   = logRestart
window.logClear     = logClear
window.setScore     = setScore