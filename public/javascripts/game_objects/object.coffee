class Object extends Phaser.GameObjects.Image
  constructor: (scene, x, y, key, frame) ->
    super scene,
          x * scene.tileSize + scene.tileSizeHalf,
          y * scene.tileSize + scene.tileSizeHalf,
          key, frame
    
    @tileX = x
    @tileY = y
    
module.exports = Object
