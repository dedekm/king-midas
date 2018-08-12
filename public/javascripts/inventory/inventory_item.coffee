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
  
  init: (item) ->
    @setInteractive()
    @list.push item
    @scene.input.setDraggable(@)
    
    @category = item.category || item.texture.key
    @value = item.value
    
    if @category == 'gold'
      @amount = item.value
    else
      @amount = 1
    
    @images.push @inventory.scene.add.image(@x, @y, item.texture.key)
    @text.setText @amount
    
  add: (item) ->
    @list.push item
    @value += item.value
    
    if @category == 'gold'
      @amount += item.value
    else
      @amount++
      @images.push @inventory.scene.add.image(@x, @y - 6 * (@amount - 1), item.texture.key)
      
    @text.setText @amount
  
  drop: (x, y) ->
    # TODO: drop group
    item = @list[0]
    item.setPosition(x, y)
    item.tileX = (x - @scene.tileSizeHalf) / @scene.tileSize
    item.tileY = (y - @scene.tileSizeHalf) / @scene.tileSize
    
    @scene.children.add item
    @scene.objects.add item
    @list.length = 0
    for image in @images
      image.destroy()
    @images.length = 0
    @amount = 0
    @value = 0
    @category = null
    @disableInteractive()
    
    @text.setText @amount
    
    return item
  
  setImagesPosition: (x, y) ->
    for item, i in @images
      item.setPosition(x, y - 6 * i)

module.exports = InventoryItem
