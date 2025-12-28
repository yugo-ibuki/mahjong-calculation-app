import { onCall, HttpsError } from 'firebase-functions/v2/https'
import { logger } from 'firebase-functions/v2'
import type { CalculateScoreRequest, CalculateScoreResponse } from '@mahjong/shared-types'
import { MahjongService } from '../services/mahjong.service.js'
import { calculateScoreSchema } from '../schemas/calculation.schema.js'
import { handleError } from '../middleware/error-handler.js'

const mahjongService = new MahjongService()

export const calculateScore = onCall<CalculateScoreRequest, Promise<CalculateScoreResponse>>(
    {
        region: 'asia-northeast1',
        memory: '256MiB',
        timeoutSeconds: 30,
    },
    async (request) => {
        try {
            // バリデーション
            const validatedData = calculateScoreSchema.parse(request.data)

            // 計算実行
            const result = await mahjongService.calculate(
                validatedData.hand,
                validatedData.context
            )

            logger.info('Score calculated', {
                han: result.han,
                fu: result.fu,
                score: result.score.total,
            })

            return {
                success: true,
                result,
            }
        } catch (error) {
            logger.error('Calculation error', { error })

            if (error instanceof HttpsError) {
                throw error
            }

            handleError(error)
        }
    }
)
