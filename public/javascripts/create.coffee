Hero = require './game_objects/hero.coffee'
Enemy = require './game_objects/enemy.coffee'
Item = require './game_objects/item.coffee'
Gold = require './game_objects/gold.coffee'
Inventory = require './inventory/inventory.coffee'

buildMap = (scene) ->
  map = scene.make.tilemap(key: 'map', tileWidth: 32, tileHeight: 32)
  tileset = map.addTilesetImage('tiles', null, 32, 32, 1, 2)
  scene.walls = map.createStaticLayer(0, tileset, 0, 0)

module.exports = ->
  @totalValueDirty = true
  @totalValue = 0
  @getTotalValue = ->
    if @totalValueDirty
      @totalValue = 0
      for object in @objects
        @totalValue += object.value if object.type == 'item'
      for object in @inventory.list
        @totalValue += object.value
      @totalValueDirty = false
    return @totalValue
  
  @getTileAtXY = (x, y) ->
    @walls.getTileAtWorldXY(x * @tileSize, y * @tileSize, true)
  
  buildMap(@)
  
  @tileSize = 32
  @tileSizeHalf = @tileSize / 2
  @steps = 0
  @objects = []
  @inventory = new Inventory(@)
  
  hero = @add.custom(Hero, 1, 1, 'clown')
  hero.attack = 50
  hero.defense = 10
  
  enemy = @add.custom(Enemy, 3, 3, 'ufo')
  enemy.attack = 15
  enemy.defense = 5
  
  @add.custom(Item, 5, 1, 'ball')
  @add.custom(Item, 5, 3, 'ball')
  @add.custom(Item, 5, 8, 'eggplant')
  @add.custom(Item, 7, 3, 'eggplant')
  @add.custom(Item, 8, 3, 'melon')
  @add.custom(Gold, 2, 4, 20)
  @add.custom(Gold, 3, 4, 30)
  @add.custom(Gold, 4, 4, 20)
  
  @input.keyboard.on 'keydown', (event) ->
    newPos = {
      x: hero.tileX
      y: hero.tileY
    }

    switch event.key
      when 'w'
        newPos.y -= 1
      when 's'
        newPos.y += 1
      when 'a'
        newPos.x -= 1
      when 'd'
        newPos.x += 1
      else
        return
    
    unless @scene.getTileAtXY(newPos.x, newPos.y, true).index == 2
      canMove = true

      for item, i in @scene.objects
        if item.tileX == newPos.x && item.tileY == newPos.y
          if item.type && item.type == 'enemy'
            item.health -= hero.attack - item.defense
            if item.health <= 0
              item.die(i)
            else
              hero.health -= item.attack - hero.defense
              console.log hero.health
            canMove = false
            break
          
          @scene.objects.splice(i, 1)
          @scene.inventory.add(item)
          break

      if canMove
        @scene.steps++
        hero.moveTo(newPos.x, newPos.y)
