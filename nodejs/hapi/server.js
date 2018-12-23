'use strict';

const Hapi = require('hapi');

const server = Hapi.server({
    port: 3000,
    host: 'localhost'
});

const init = async () => {
    await server.start();
    console.log(`Server running at: ${server.info.uri}`);
};


server.route({
    method: 'GET',
    path: '/',
    handler: (request, h) => {

        return 'Hello, world!';
    }
});

server.route({
    method: 'GET',
    path: '/{id}',
    handler: (request, h) => {
        return {"id": encodeURIComponent(request.params.id)};
    }
});


process.on('unhandledRejection', (err) => {

    console.log(err);
    process.exit(1);
});

init();