import type { TileGroup } from './tile.js'
import type { Wind } from './hand.js'
import type { Yaku, ScorePayment } from './score.js'

/**
 * 符の内訳
 */
export interface FuBreakdown {
    /** 項目名 */
    name: string
    /** 符 */
    fu: number
}

/**
 * 問題の難易度
 */
export type QuestionDifficulty = 'easy' | 'normal' | 'hard'

/**
 * 点数計算問題
 */
export interface Question {
    /** 問題ID */
    id: string
    /** 問題タイトル */
    title: string
    /** 面子構成 (4面子1雀頭) */
    groups: TileGroup[]
    /** 和了牌のグループ内インデックス */
    winningGroupIndex: number
    /** ツモかどうか */
    isTsumo: boolean
    /** 親かどうか */
    isDealer: boolean
    /** 場風 */
    roundWind: Wind
    /** 自風 */
    seatWind: Wind
    /** 成立役 */
    yaku: Yaku[]
    /** 翻数 */
    han: number
    /** 符 */
    fu: number
    /** 符の内訳 */
    fuBreakdown: FuBreakdown[]
    /** 正解の点数 */
    correctScore: ScorePayment
    /** 選択肢 */
    choices: ScorePayment[]
    /** 正解の選択肢インデックス */
    correctChoiceIndex: number
    /** 難易度 */
    difficulty: QuestionDifficulty
    /** 解説 */
    explanation: string
}
