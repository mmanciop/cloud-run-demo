const fs = require('fs');
const loadtest = require('loadtest');

const url = require('url');

const target_url = process.env.ENDPOINT_SERVICE_URL

console.log(`Generating load towards: ${target_url}\n`);

function statusCallback(error, result, latency) {
    if (latency.totalRequests % 10 == 0) {
        process.stdout.clearLine();
        process.stdout.cursorTo(0);
        process.stdout.write(`Generated ${latency.totalRequests} requests; errors: ${latency.totalErrors / latency.totalRequests}%; latency 95p: ${latency.percentiles["95"]}ms, max: ${latency.maxLatencyMs}ms`);
    }
}

const options = {
    url: target_url,
    maxRequests: 1000,
    statusCallback: statusCallback
};

operation = loadtest.loadTest(options, function(error, result) {
    if (error) {
        return console.error('Got an error: %s', error);
    }
    console.log(`Demo run successfully: ${JSON.stringify(result,null,'  ')}`);
});
