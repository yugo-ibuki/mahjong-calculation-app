import { logger as firebaseLogger } from 'firebase-functions/v2'

/**
 * ロギングユーティリティ
 */
export const logger = {
    info: (message: string, data?: Record<string, unknown>) => {
        firebaseLogger.info(message, data)
    },
    warn: (message: string, data?: Record<string, unknown>) => {
        firebaseLogger.warn(message, data)
    },
    error: (message: string, data?: Record<string, unknown>) => {
        firebaseLogger.error(message, data)
    },
    debug: (message: string, data?: Record<string, unknown>) => {
        firebaseLogger.debug(message, data)
    },
}
