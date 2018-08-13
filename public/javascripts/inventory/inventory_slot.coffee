class InventorySlot extends Phaser.GameObjects.Zone
  constructor: (inventory, position) ->
    scene = inventory.scene
    x = inventory.baseX + position * scene.tileSize
    y = inventory.baseY
    
    super(scene, x, y, scene.tileSize, scene.tileSize)
    
    @inventory = inventory
    @position = position
    @list = []
    @text = @inventory.scene.add.text @x - @scene.tileSizeHalf / 2,
                                      @y + @scene.tileSize, 0
    @value = 0
    @amount = 0
  
  add: (item) ->
    if Array.isArray(item)
      list = item
      item = list[0]
    else
      list = item.list
      
    if @list.length == 0
      @setInteractive()
      @scene.input.setDraggable(@)
      @category = item.category || item.texture.key
      
    @value += item.value
    
    if @category == 'gold'
      @amount += item.value
      if @list.length == 0
        @list.push item
        @image = @inventory.scene.add.image(@x, @y, 'things', item.frame.name)
      @list[0].value = @amount
    else
      if @list.length == 0
        @image = @inventory.scene.add.image(@x, @y, 'things', item.frame.name)
      
      for i in list
        @list.push i
        @amount += 1
      
    @text.setText @amount
  
  return: () ->
    @setImagePosition @x, @y
    
  drop: (x, y) ->
    pos = @scene.getTileXY(x, y)
    
    if item = @scene.getItemAtXY(pos.x,pos.y)
      item.addItem @list.shift()
    else
      item = @list.shift()
      item.tileX = pos.x
      item.tileY = pos.y
      item.init().setPosition(x, y)
      @scene.children.add item
      @scene.setItemAtXY(item.tileX, item.tileY, item)
      
    for i in @list
      item.addItem i
    
    @list.length = 0
    @image.destroy()
    @amount = 0
    @value = 0
    @category = null
    @scene.input.setDraggable(@, false)
    @disableInteractive()
    
    @text.setText @amount
    
    return item
  
  setImagePosition: (x, y) ->
    @image.setPosition(x, y)

module.exports = InventorySlot
