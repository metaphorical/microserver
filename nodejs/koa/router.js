const Router = require('koa-router');
const router = new Router();

router.get('/', async (ctx) => {
  ctx.body = {
    status: 'success',
    message: 'hello, world!'
  };
})
router.get('/:id', async (ctx) => {
  ctx.body = {
    id: ctx.params.id
  };
})

module.exports = router;