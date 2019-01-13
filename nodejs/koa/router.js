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
  let result = {};
  try {
    result = await bgg_handler.getHot();
    ctx.body = result.data;
  } catch(err){
    result = err
    ctx.body = {
      "ERROR": err
    };
  }

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