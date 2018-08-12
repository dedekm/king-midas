Character = require './character.coffee'
Item = require './item.coffee'

class Enemy extends Character
  constructor: (scene, x, y, key, frame) ->
    super scene, x, y, key, frame
    
    @type = 'enemy'
  
  die: ->
    @scene.objects.remove(@)
    
    items = Phaser.Utils.Array.Shuffle ['melon', 'eggplant']
    positions = [
      { x: @tileX + 1, y: @tileY },
      { x: @tileX - 1, y: @tileY },
      { x: @tileX + 1, y: @tileY + 1 },
      { x: @tileX + 1, y: @tileY - 1 },
      { x: @tileX - 1, y: @tileY + 1 },
      { x: @tileX - 1, y: @tileY - 1 },
      { x: @tileX, y: @tileY + 1 },
      { x: @tileX, y: @tileY - 1 }
    ]
    available = []
    
    for pos in Phaser.Utils.Array.Shuffle(positions)
      unless @scene.getTileAtXY(pos.x, pos.y).index == 2
        free = true
        for item, i in @scene.objects.list
          if item.tileX == pos.x && item.tileY == pos.y
            free = false
        available.push pos if free
      
      break if available.length >= items.length - 1
    
    available.unshift({ x: @tileX, y: @tileY })
    
    for pos, i in available
      @scene.add.custom(Item, pos.x, pos.y, items[i])
    @destroy()
      
module.exports = Enemy
