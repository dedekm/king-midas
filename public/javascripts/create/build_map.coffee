EasyStar = require 'easystarjs'

module.exports = (scene) ->
  groundTiles = [
    11,14,15,18,19,23,26,27,
    28,29,30,31,39,42,57,58,
    59,64,65,66,67,68,76,77,
    78,80,88,89,90,91,92,101,
    105,107,113,117,120,125,
    129,131,137,139,141,143
  ]
  
  map = scene.make.tilemap { key: 'map', tileWidth: scene.tileSize, tileHeight: scene.tileSize }
  tileset = map.addTilesetImage 'tiles'
  scene.walls = map.createStaticLayer(0, tileset, 0, 0)
  
  scene.finder = new EasyStar.js();
  scene.objects = []
  scene.grid = []
  scene.mapWidth = map.width
  scene.mapHeight = map.height
  
  y = 0
  while y < map.height
    scene.objects.push []
    
    col = []
    x = 0
    while x < map.width
      # In each cell we store the ID of the tile, which corresponds
      # to its index in the tileset of the map ("ID" field in Tiled)
      if map.getTileAt(x, y).index in groundTiles
        value = 0
      else
        value = 1
      col.push value
      x++
    scene.grid.push col
    y++
  
  scene.finder.setGrid scene.grid
  scene.finder.setAcceptableTiles([0]);
