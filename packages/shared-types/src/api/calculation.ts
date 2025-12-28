import type { Hand, GameContext } from '../domain/hand.js'
import type { ScoreResult } from '../domain/score.js'

/**
 * 点数計算リクエスト
 */
export interface CalculateScoreRequest {
    /** 手牌 */
    hand: Hand
    /** 場の情報 */
    context: GameContext
}

/**
 * API エラー
 */
export interface ApiError {
    /** エラーコード */
    code: string
    /** エラーメッセージ */
    message: string
}

/**
 * 点数計算レスポンス
 */
export interface CalculateScoreResponse {
    /** 成功したかどうか */
    success: boolean
    /** 計算結果 (成功時) */
    result?: ScoreResult
    /** エラー (失敗時) */
    error?: ApiError
}
