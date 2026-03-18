const express = require('express');
const app = express();
const PORT = process.env.PORT || 3000;

app.get('/', (req, res) => {
    res.send(`
    <!DOCTYPE html>
    <html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>DevOps Assessment | Secure Deployment</title>
        <script src="https://cdn.tailwindcss.com"></script>
    </head>
    <body class="bg-gray-900 text-white flex items-center justify-center h-screen m-0 font-sans">
        <div class="bg-gray-800 p-8 rounded-xl shadow-2xl border border-gray-700 max-w-md w-full text-center">
            <div class="inline-flex items-center bg-green-900/30 text-green-400 px-4 py-1.5 rounded-full text-sm font-semibold mb-6 border border-green-800/50">
                <span class="w-2 h-2 bg-green-500 rounded-full mr-2 shadow-[0_0_8px_rgba(34,197,94,1)]"></span>
                System Online & Secure
            </div>
            <h1 class="text-2xl font-bold mb-2">DevOps Assessment</h1>
            <p class="text-gray-400 mb-8 text-sm">Successfully deployed via Terraform, Docker, and Jenkins automated CI/CD pipeline.</p>
            
            <div class="grid grid-cols-2 gap-4 text-left">
                <div class="bg-gray-900/50 p-4 rounded-lg border border-gray-700">
                    <div class="text-xs text-gray-500 uppercase tracking-wider mb-1">Infrastructure</div>
                    <div class="font-semibold text-gray-200">AWS EC2</div>
                </div>
                <div class="bg-gray-900/50 p-4 rounded-lg border border-gray-700">
                    <div class="text-xs text-gray-500 uppercase tracking-wider mb-1">Security Scan</div>
                    <div class="font-semibold text-green-400">Passed (Trivy)</div>
                </div>
                <div class="bg-gray-900/50 p-4 rounded-lg border border-gray-700">
                    <div class="text-xs text-gray-500 uppercase tracking-wider mb-1">Container</div>
                    <div class="font-semibold text-gray-200">Docker</div>
                </div>
                <div class="bg-gray-900/50 p-4 rounded-lg border border-gray-700">
                    <div class="text-xs text-gray-500 uppercase tracking-wider mb-1">AI Remediation</div>
                    <div class="font-semibold text-gray-200">Completed</div>
                </div>
            </div>
            
            <div class="mt-8 text-xs text-gray-500 border-t border-gray-700 pt-4">
                Automated Deployment Pipeline
            </div>
        </div>
    </body>
    </html>
    `);
});

app.listen(PORT, '0.0.0.0', () => {
    console.log(`Server is running on port ${PORT}`);
});