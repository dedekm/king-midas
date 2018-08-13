Character = require './character.coffee'
Item = require './item.coffee'

class Enemy extends Character
  constructor: (scene, x, y) ->
    key = Phaser.Utils.Array.Shuffle(['demon', 'dragon', 'scorpio', 'skeleton', 'troll'])[0]
    super scene, x, y, key
    
    @type = 'enemy'
    @wasAttacked = false
    @scene.enemies.add @
    @scene.setGrid(@tileX, @tileY, 3)
  
  move: ->
    @wasAttacked = false
    
    self = @
    @pathId = @scene.finder.findPath @tileX,
                           @tileY,
                           @scene.hero.tileX,
                           @scene.hero.tileY,
                           (path)->
                             self.moveByPath(path)
  
  moveByPath: (path) ->
    return unless path
    
    if path[1].x == @scene.hero.tileX && path[1].y == @scene.hero.tileY
      @attackHero() unless @wasAttacked
    else if @scene.getGrid(path[1].x, path[1].y) == 0
      @scene.setGrid(@tileX, @tileY, 0)
      @moveTo(path[1].x, path[1].y)
      @scene.setGrid(@tileX, @tileY, 3)
  
  attackHero: ->
    @scene.hero.defend(@attack)
  
  die: ->
    @scene.setItemAtXY(@tileX, @tileY, undefined)
    @scene.enemies.remove(@)
    @scene.finder.cancelPath(@pathId);

    # TODO: random number of items
    items = [Item.THING_KEYS[Math.round(Math.random() * Item.THING_KEYS.length)]]
    items.push Item.THING_KEYS[Math.round(Math.random() * Item.THING_KEYS.length)]

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
      unless @scene.getGrid(pos.x, pos.y) == 1
        free = true
        if @scene.getItemAtXY(pos.x, pos.y)
          free = false
        available.push pos if free
      
      break if available.length >= items.length - 1
    
    available.unshift({ x: @tileX, y: @tileY })
    
    for pos, i in available
      @scene.add.item(pos.x, pos.y, items[i])
    @destroy()
      
module.exports = Enemy
