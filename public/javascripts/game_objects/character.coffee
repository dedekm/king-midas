Object = require './object.coffee'

class Character extends Object
  constructor: (scene, x, y, key, frame) ->
    super scene, x, y, key, frame
    
    @health = 100
    @attack = 0
    @defense = 0
  
  moveTo: (x, y) ->
    @tileX = x
    @tileY = y
    @x = x * @scene.tileSize + @scene.tileSizeHalf
    @y = y * @scene.tileSize + @scene.tileSizeHalf

module.exports = Character
