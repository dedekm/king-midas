class InventoryItem extends Phaser.GameObjects.Image
  constructor: (inventory, position) ->
    scene = inventory.scene
    x = inventory.baseX + position * scene.tileSize
    y = inventory.baseY
    
    super(scene, x, y, 'zone')
    @scene.children.add(@)
    
    @inventory = inventory
    @position = position
    @images = []
    @list = []
    @text = @inventory.scene.add.text(@x, @y, 0)
    @value = 0
    @amount = 0
  
  add: (item) ->
    if @list.length == 0
      @setInteractive()
      @scene.input.setDraggable(@)
      @category = item.category || item.texture.key
      
    @value += item.value
    
    if @category == 'gold'
      @amount += item.value
      if @list.length == 0
        @list.push item
        @images.push @inventory.scene.add.image(@x, @y, item.texture.key)
    else
      for i in item.list
        @list.push i
        @amount += 1
        @images.push @inventory.scene.add.image(@x, @y - 6 * (@amount - 1), item.texture.key)
      
    @text.setText @amount
  
  drop: (x, y) ->
    item = @list.shift().init()
    item.setPosition(x, y)
    item.tileX = (x - @scene.tileSizeHalf) / @scene.tileSize
    item.tileY = (y - @scene.tileSizeHalf) / @scene.tileSize
    
    @scene.children.add item
    @scene.objects.add item
    for i in @list
      item.addItem(i)
    
    @list.length = 0
    for image in @images
      image.destroy()
    @images.length = 0
    @amount = 0
    @value = 0
    @category = null
    @scene.input.setDraggable(@, false)
    @disableInteractive()
    
    @text.setText @amount
    
    return item
  
  setImagesPosition: (x, y) ->
    for item, i in @images
      item.setPosition(x, y - 6 * i)

module.exports = InventoryItem
