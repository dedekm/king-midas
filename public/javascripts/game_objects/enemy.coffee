Character = require './character.coffee'

class Enemy extends Character
  constructor: (scene, x, y, key, frame) ->
    super scene, x, y, key, frame
    
    @type = 'enemy'
  
  die: (i)->
    @scene.items.splice(i, 1)
    
    items = ['melon', 'eggplant']
    positions = [
      { x: @x, y: @y },
      { x: @x + 32, y: @y },
      { x: @x - 32, y: @y },
      { x: @x + 32, y: @y + 32 },
      { x: @x + 32, y: @y - 32 },
      { x: @x - 32, y: @y + 32 },
      { x: @x - 32, y: @y - 32 },
      { x: @x, y: @y + 32 },
      { x: @x, y: @y - 32 }
    ]
    available = []

    for pos in positions
      unless @scene.walls.getTileAtWorldXY(pos.x, pos.y, true).index == 2
        free = true
        for item, i in @scene.items
          if item.x == pos.x && item.y == pos.y
            free = false
        available.push pos if free
      
      break if available.length >= items.length
    
    # TODO: make it more random
    for pos, i in available
      @scene.items.push @scene.add.sprite(pos.x, pos.y, items[i])
    @destroy()
      
module.exports = Enemy
