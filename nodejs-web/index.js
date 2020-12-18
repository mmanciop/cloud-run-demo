const express = require('express');
const requestLib = require('request');
const app = express();

const messages = require('./helloworld_pb');
const services = require('./helloworld_grpc_pb');

const grpc = require('grpc');

app.get('/', (req, res) => {
    const name = process.env.NAME || 'World';

    let client = new services.GreeterClient(process.env.GRPC_TARGET, grpc.credentials.createSsl());
    let request = new messages.HelloRequest();
    request.setName(name);

    requestLib(process.env.DOTNET_TARGET, { json: true }, (err, res, body) => {
        if (err) { return console.log(err); }
        console.log(body.url);
        console.log(body.explanation);
    });

    requestLib(process.env.DOTNET_TARGET + "/pubsub", { json: true }, (err, res, body) => {
        if (err) { return console.log(err); }
        console.log(body.url);
        console.log(body.explanation);
    });

    client.sayHello(request, function(err, response) {
        if (err) {
            console.log(err)

            return res.send(err.message)
        }

        res.send(`Hello ${name}!`);

        console.log('Greeting:', response.getMessage());
    });
});

const port = process.env.PORT || 8080;
app.listen(port, () => {
    console.log(`helloworld: listening on port ${port}`);
});
