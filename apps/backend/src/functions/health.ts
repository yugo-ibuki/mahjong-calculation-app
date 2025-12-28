import { onRequest } from 'firebase-functions/v2/https'

export const healthCheck = onRequest(
    {
        region: 'asia-northeast1',
    },
    (_req, res) => {
        res.json({
            status: 'healthy',
            timestamp: new Date().toISOString(),
            version: process.env['npm_package_version'] ?? '0.0.1',
        })
    }
)
