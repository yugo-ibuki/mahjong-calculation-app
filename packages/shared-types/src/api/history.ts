import type { Hand, GameContext } from '../domain/hand.js'
import type { ScoreResult } from '../domain/score.js'

/**
 * 履歴エントリ
 */
export interface HistoryEntry {
    /** ID */
    id: string
    /** ユーザーID */
    userId: string
    /** 手牌 */
    hand: Hand
    /** 場の情報 */
    context: GameContext
    /** 計算結果 */
    result: ScoreResult
    /** 作成日時 */
    createdAt: string
}

/**
 * 履歴取得リクエスト
 */
export interface GetHistoryRequest {
    /** 取得件数 */
    limit?: number
}

/**
 * 履歴取得レスポンス
 */
export interface GetHistoryResponse {
    /** 履歴一覧 */
    history: HistoryEntry[]
}

/**
 * 履歴保存リクエスト
 */
export interface SaveHistoryRequest {
    /** 手牌 */
    hand: Hand
    /** 場の情報 */
    context: GameContext
    /** 計算結果 */
    result: ScoreResult
}

/**
 * 履歴保存レスポンス
 */
export interface SaveHistoryResponse {
    /** 保存されたID */
    id: string
}
