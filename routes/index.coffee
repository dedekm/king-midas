express = require('express')
router = express.Router()

router.get '/', (req, res, next) ->
  res.render 'index', title: 'King Midas [LD42]'
  
module.exports = router
