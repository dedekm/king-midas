module.exports = ->
  phaserURL = 'http://labs.phaser.io/assets'
  
  @load.image('clown', phaserURL + '/sprites/clown.png')
  @load.image('ball', phaserURL + '/sprites/blue_ball.png')
  @load.image('coin', phaserURL + '/sprites/yellow_ball.png')
  @load.image('eggplant', phaserURL + '/sprites/eggplant.png')
  @load.image('melon', phaserURL + '/sprites/melon.png')
  @load.image('ufo', phaserURL + '/sprites/ufo.png')
  @load.image('tiles', phaserURL + '/tilemaps/tiles/drawtiles-spaced.png')
  @load.tilemapCSV('map', '/tilemaps/grid.csv')
  
  # @load.json('config', 'config.json');
