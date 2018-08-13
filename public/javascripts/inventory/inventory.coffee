InventorySlot = require './inventory_slot.coffee'

class Inventory extends Phaser.Structs.List
  constructor: (scene)->
    super()
    @scene = scene
    @baseY = 15 * @scene.tileSize + @scene.tileSizeHalf
    @baseX = 34 * @scene.tileSize + @scene.tileSizeHalf
    
    self = @
    @scene.input.on 'drag', (pointer, inventorySlot, dragX, dragY) ->
      @dropzone ||= @scene.add.image(@scene.hero.x, @scene.hero.y, 'zone')
      @dropzone.category = inventorySlot.category
      self.setDropzonePosition()
      @inventorySlot = inventorySlot
      @inventorySlot.setImagePosition(dragX, dragY)
    
    @scene.input.on 'drop', (pointer, inventorySlot, target) ->
      if @dropzone.available
        @inventorySlot.drop(@dropzone.x, @dropzone.y)
      else
        @inventorySlot.return()
      @dropzone.destroy()
      @inventorySlot = null
      @dropzone = null
      
    @scene.input.on 'pointerup', (pointer) ->
      if @dropzone
        @inventorySlot.return()
        @dropzone.destroy()
        @inventorySlot = null
        @dropzone = null
    w = 1160 - @scene.tileSize * 9
    h = 580
    @scene.add.zone(w / 2, h / 2, w, h).setDropZone()
    
    for name in [1..4]
      @add(new InventorySlot(@, @length))
  
  addItem: (item) ->
    for inventorySlot in @list
      maxAmount = if item.category == 'gold' then 99 else 3
      
      if inventorySlot.amount < maxAmount &&
        (!inventorySlot.category || item.category == inventorySlot.category)
          if item.category == 'gold'
            # FIXME
            if inventorySlot.amount + item.value > maxAmount
              # pick just part of items
              part = item.pickUpItems(maxAmount - inventorySlot.amount)
              inventorySlot.add(part)
            else
              # pick all items
              inventorySlot.add(item)
              canAdd = true
              break
          else
            if inventorySlot.amount + item.list.length > maxAmount
              # pick just part of items
              part = item.pickUpItems(maxAmount - inventorySlot.amount)
              inventorySlot.add(part)
            else
              # pick all items
              inventorySlot.add(item)
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
      pos.y = 1
    else if -45 <= angle < 45
      pos.x = -1
    else if 45 <= angle < 135
      pos.y = -1
    else if 135 <= angle || angle < -135
      pos.x = 1
    
    target = {
      x: @scene.hero.tileX + pos.x,
      y: @scene.hero.tileY + pos.y
    }
    
    tile = @scene.getGrid(target.x,target.y)
    if tile == 0 || tile != 1 &&
      @scene.getItemAtXY(target.x,target.y).category == @scene.input.dropzone.category
        @scene.input.dropzone.available = true
        @scene.input.dropzone.setTint(0x00ff00)
    else
      @scene.input.dropzone.available = false
      @scene.input.dropzone.setTint(0xff0000)
      
    @scene.input.dropzone.setPosition target.x * @scene.tileSize + @scene.tileSizeHalf,
                                      target.y * @scene.tileSize + @scene.tileSizeHalf
    
module.exports = Inventory
