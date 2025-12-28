/**
 * 役
 */
export interface Yaku {
    /** 役名 (英語) */
    name: string
    /** 役名 (日本語) */
    nameJa: string
    /** 翻数 */
    han: number
    /** 役満かどうか */
    isYakuman?: boolean
}

/**
 * 点数の支払い情報
 */
export interface ScorePayment {
    /** 合計点 */
    total: number
    /** 親の支払い (ツモ時) */
    dealer?: number
    /** 子の支払い (ツモ時) */
    nonDealer?: number
}

/**
 * 計算結果
 */
export interface ScoreResult {
    /** 成立した役の一覧 */
    yaku: Yaku[]
    /** 合計翻数 */
    han: number
    /** 符 */
    fu: number
    /** 点数 */
    score: ScorePayment
    /** 役満かどうか */
    isYakuman: boolean
}
