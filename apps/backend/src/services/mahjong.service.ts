import type { Hand, GameContext, ScoreResult } from '@mahjong/shared-types'

/**
 * 麻雀点数計算サービス
 * 
 * NOTE: 現在はスタブ実装。将来的に @mahjong/mahjong-core パッケージを使用する予定。
 */
export class MahjongService {
    async calculate(hand: Hand, context: GameContext): Promise<ScoreResult> {
        // TODO: mahjong-core パッケージ実装後に置き換え
        // return calculateScoreCore(hand, context)

        // スタブ実装: 簡易的な結果を返す
        return {
            yaku: [
                {
                    name: 'riichi',
                    nameJa: 'リーチ',
                    han: 1,
                },
            ],
            han: 1,
            fu: 30,
            score: {
                total: 1000,
                dealer: undefined,
                nonDealer: undefined,
            },
            isYakuman: false,
        }
    }
}
