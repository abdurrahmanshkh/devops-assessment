const express = require('express');
const app = express();
const PORT = process.env.PORT || 3000;

app.get('/', (req, res) => {
    res.send(`
        <html>
            <head>
                <title>DevOps Assessment</title>
                <style>
                    body { font-family: Arial, sans-serif; text-align: center; margin-top: 50px; background-color: #f4f4f9; }
                    h1 { color: #333; }
                    p { color: #666; font-size: 1.2em; }
                </style>
            </head>
            <body>
                <h1>DevOps Assessment - Web App</h1>
                <p>If you are seeing this, the containerized application is running successfully!</p>
            </body>
        </html>
    `);
});

app.listen(PORT, '0.0.0.0', () => {
    console.log(`Server is running on http://0.0.0.0:${PORT}`);
});