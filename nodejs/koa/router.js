const Router = require('koa-router');
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
  ctx.body = {
    message: "Thanks"
  };
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