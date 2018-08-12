InventoryItem = require './inventory_item.coffee'

class Inventory extends Phaser.Structs.List
  constructor: (scene)->
    super()
    @scene = scene
    @baseY = 480 - @scene.tileSizeHalf
    @baseX = @scene.tileSize + @scene.tileSizeHalf
    
    self = @
    @scene.input.on 'drag', (pointer, inventoryItem, dragX, dragY) ->
      @dropzone ||= @scene.add.image(@scene.hero.x, @scene.hero.y, 'zone')
      
      self.setDropzonePosition()
      inventoryItem.setImagesPosition(dragX, dragY)
    
    @scene.input.on 'drop', (pointer, inventoryItem, target) ->
      available = true
      if available
        inventoryItem.drop(@dropzone.x, @dropzone.y)
      @dropzone.destroy()
      @dropzone = null
    
    zone = @scene.add.zone(320, 240, 640, 480).setDropZone()
    graphics = @scene.add.graphics();
    graphics.lineStyle(2, 0xffff00);
    graphics.strokeRect(zone.x + zone.input.hitArea.x, zone.y + zone.input.hitArea.y, zone.input.hitArea.width, zone.input.hitArea.height);
    
    for name in [1..4]
      @add(new InventoryItem(@, @length))
  
  addItem: (item) ->
    for inventoryItem, j in @list
      if !inventoryItem.category || item.category == inventoryItem.category
        inventoryItem.add(item)
        canAdd = true
        break
    
    if canAdd
      item.pickUp()
      true
    else
      false
  
  setDropzonePosition: () ->
    x = @scene.input.x
    y = @scene.input.y
    angle = Phaser.Math.Angle.Between(x, y, @scene.hero.x, @scene.hero.y) * Phaser.Math.RAD_TO_DEG
    pos = { x: 0, y: 0 }
    
    if -135 <= angle < -45
      pos.y = @scene.tileSize
    else if -45 <= angle < 45
      pos.x = @scene.tileSize * -1
    else if 45 <= angle < 135
      pos.y = @scene.tileSize * -1
    else if 135 <= angle || angle < -135
      pos.x = @scene.tileSize
      
    @scene.input.dropzone.setPosition(@scene.hero.x + pos.x, @scene.hero.y + pos.y)
    
module.exports = Inventory
