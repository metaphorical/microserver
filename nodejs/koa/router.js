const Router = require('koa-router');
const bgg_handler = require('./lib/bgg_handler.js');

const router = new Router();

router.get('/', async (ctx) => {
  ctx.body = {
    status: 'success',
    message: 'hello, world!'
  };
})
router.get('/healthy', async (ctx) => {
  ctx.set("X-Health", "Awsome");
})
router.get('/bgg/hot', async (ctx) => {
  bgg_handler.getHot(function(response, error) {
    if (error) {
      console.log("Error happened during BGG hot games call:", err);
    } else {
      console.log(response)
      ctx.body = response;
    }
  })
})
router.get('/bgg/item/:id', async (ctx) => {
  ctx.body = {
    message: "AJDII"
  };
})
router.get('/:id', async (ctx) => {
  ctx.body = {
    id: ctx.params.id
  };
})

module.exports = router;