const Koa = require('koa');
const app = new Koa();
const apiRouter = require('./router');

const port = 3000;

app.use(async (ctx, next) => {
    await next();
    const rt = ctx.response.get('X-Response-Time');
    console.log(`${ctx.method} ${ctx.url} - ${rt}`);
});
  
app.use(async (ctx, next) => {
    const start = Date.now();
    await next();
    const ms = Date.now() - start;
    ctx.set('X-Response-Time', `${ms}ms`);
});

app.use(apiRouter.routes());

// "catch all" error handler
app.on('error', err => {
    log.error('server error', err);
});


app.use(async ctx => {
  ctx.body = 'Hello World';
});

app.listen(port, () => console.log(`App started - listening on ${port}`));