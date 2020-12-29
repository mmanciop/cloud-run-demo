const fs = require('fs');
const loadtest = require('loadtest');

const express = require('express');
const app = express();
const url = require('url');

const name = process.env.NAME || 'World';

app.get('/', (req, res) => {
    fs.readFile(process.env.ENDPOINT_SERVICE_URL || 'entry_service_url', 'utf8', function (err, data) {
        if (err) {
            res.writeHead(500, {
                'Content-Type': 'text/plain'
            });
            res.write(err);
            res.end();
            next();

            return;
        }

        res.writeHead(200, {
            'Content-Type': 'text/plain',
            'Transfer-Encoding': 'chunked'
        });

        res.write(`Generating load towards: ${data}\n`);

        function statusCallback(error, result, latency) {
            if (latency.totalRequests % 10 == 0) {
                res.write(`Generated ${latency.totalRequests} requests; errors: ${latency.totalErrors / latency.totalRequests}%; latency 95p: ${latency.percentiles["95"]}ms, max: ${latency.maxLatencyMs}ms\n`);
            }
        }

        const options = {
            url: data,
            maxRequests: 1000,
            statusCallback: statusCallback
        };

        operation = loadtest.loadTest(options, function(error, result) {
            if (error) {
                return console.error('Got an error: %s', error);
            }
            console.log(`Demo run successfully: ${JSON.stringify(result,null,'  ')}`);
        });

        req.on("close", function() {
            console.log('Stopping load generation, the client closed the connection');
            operation.stop();
        });
    });
});

const port = process.env.PORT || 8080;
app.listen(port, () => {
    console.log(`Load Generator: listening on port ${port}`);
});
