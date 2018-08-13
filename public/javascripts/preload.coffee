module.exports = ->
  phaserURL = 'http://labs.phaser.io/assets'
  
  @load.image('clown', phaserURL + '/sprites/clown.png')
  @load.image('ball', phaserURL + '/sprites/blue_ball.png')
  @load.image('green_ball', phaserURL + '/sprites/green_ball.png')
  @load.image('coin', phaserURL + '/sprites/yellow_ball.png')
  @load.image('eggplant', phaserURL + '/sprites/eggplant.png')
  @load.image('melon', phaserURL + '/sprites/melon.png')
  @load.image('ufo', phaserURL + '/sprites/ufo.png')
  @load.image('zone', phaserURL + '/sprites/32x32.png')
  @load.image('tiles', '/images/tileset.png')
  @load.tilemapCSV('map', '/tilemaps/grid.csv')
  
  # @load.json('config', 'config.json');
