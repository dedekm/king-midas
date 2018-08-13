EasyStar = require 'easystarjs'

module.exports = (scene) ->
  map = scene.make.tilemap key: 'map',
                           tileWidth: scene.tileSize,
                           tileHeight: scene.tileSize
  tileset = map.addTilesetImage 'tiles', null,
                                scene.tileSize, scene.tileSize,
                                1, 2
  scene.walls = map.createStaticLayer(0, tileset, 0, 0)
  
  scene.finder = new EasyStar.js();
  scene.objects = []
  scene.grid = []
  y = 0
  while y < map.height
    scene.objects.push []
    
    col = []
    x = 0
    while x < map.width
      # In each cell we store the ID of the tile, which corresponds
      # to its index in the tileset of the map ("ID" field in Tiled)
      col.push map.getTileAt(x, y).index
      x++
    scene.grid.push col
    y++
  
  scene.finder.setGrid scene.grid
  scene.finder.setAcceptableTiles([0]);
