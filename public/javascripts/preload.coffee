module.exports = ->
  phaserURL = 'http://labs.phaser.io/assets'
  
  @load.image('ufo', phaserURL + '/sprites/ufo.png')
  @load.image('zone', phaserURL + '/sprites/32x32.png')
  @load.spritesheet('things', '/images/things.png', { frameWidth: 29, frameHeight: 29 });
  
  for character in ['demon', 'dragon', 'knight', 'scorpio', 'skeleton', 'troll']
    @load.spritesheet(character, "/images/#{character}.png", { frameWidth: 29, frameHeight: 36 });
    
  @load.image('tiles', '/images/tileset.png')
  @load.tilemapCSV('map', '/tilemaps/grid.csv')
  
  # @load.json('config', 'config.json');
