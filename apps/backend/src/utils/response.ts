import type { ApiError } from '@mahjong/shared-types'

/**
 * 成功レスポンスを生成
 */
export function createSuccessResponse<T>(data: T) {
    return {
        success: true as const,
        ...data,
    }
}

/**
 * エラーレスポンスを生成
 */
export function createErrorResponse(error: ApiError) {
    return {
        success: false as const,
        error,
    }
}
