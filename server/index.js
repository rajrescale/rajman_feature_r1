const functions = require('firebase-functions');
const app = require('./index_https'); // Adjust the path as necessary

exports.dalvi_api = functions.https.onRequest(app);