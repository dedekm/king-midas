Enemy = require '../game_objects/enemy.coffee'

module.exports = (event) ->
  return unless @scene.hero
  return if event.key not in ['w', 's', 'a', 'd']

  newPos = {
    x: @scene.hero.tileX
    y: @scene.hero.tileY
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
  
  unless @scene.getGrid(newPos.x, newPos.y) == 1
    for enemy in @scene.enemies.list
      enemy.move()
    
    canMove = true
    
    if item = @scene.getItemAtXY(newPos.x, newPos.y)
      if item.type && item.type == 'enemy'
        item.defend(@scene.hero.attack)
        
        if item.health <= 0
          item.die()
        else
          item.wasAttacked = true
          @scene.hero.defend(item.attack)
        canMove = false
      else
        if @scene.inventory.addItem(item)
          @scene.setItemAtXY(item.tileX, item.tileY, undefined)
        else
          canMove = false

    if canMove
      @scene.steps++
      @scene.hero.moveTo(newPos.x, newPos.y)
    
    if @scene.input.dropzone
      @scene.inventory.setDropzonePosition()
      
    if @scene.steps % 5 == 0
      pos = {
        x: Math.floor(Math.random() * @scene.mapWidth)
        y: Math.floor(Math.random() * @scene.mapHeight)
      }
      if @scene.getGrid(pos.x, pos.y) == 0
        @scene.add.custom(Enemy, pos.x, pos.y)
    
    @scene.finder.calculate()

    if @scene.hero.willDie
      @scene.hero.die()
      @scene.hero = undefined
    
