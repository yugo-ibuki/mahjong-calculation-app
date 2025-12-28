import { HttpsError } from 'firebase-functions/v2/https'
import { ZodError } from 'zod'
import { logger } from 'firebase-functions/v2'

/**
 * エラーハンドリング共通処理
 */
export function handleError(error: unknown): never {
    logger.error('Error occurred', { error })

    if (error instanceof ZodError) {
        throw new HttpsError('invalid-argument', 'Validation failed', {
            errors: error.errors,
        })
    }

    if (error instanceof HttpsError) {
        throw error
    }

    throw new HttpsError('internal', 'An unexpected error occurred')
}
