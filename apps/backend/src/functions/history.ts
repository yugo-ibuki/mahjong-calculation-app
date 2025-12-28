import { onCall, HttpsError } from 'firebase-functions/v2/https'
import { HistoryService } from '../services/history.service.js'

const historyService = new HistoryService()

export const getHistory = onCall(
    {
        region: 'asia-northeast1',
    },
    async (request) => {
        // 認証チェック
        if (!request.auth) {
            throw new HttpsError('unauthenticated', 'User must be authenticated')
        }

        const userId = request.auth.uid
        const limit = (request.data as { limit?: number })?.limit ?? 20

        const history = await historyService.getByUserId(userId, limit)

        return { history }
    }
)

export const saveHistory = onCall(
    {
        region: 'asia-northeast1',
    },
    async (request) => {
        if (!request.auth) {
            throw new HttpsError('unauthenticated', 'User must be authenticated')
        }

        const userId = request.auth.uid
        const { hand, context, result } = request.data as {
            hand: unknown
            context: unknown
            result: unknown
        }

        const id = await historyService.save(userId, { hand, context, result })

        return { id }
    }
)
