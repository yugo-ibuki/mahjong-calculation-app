import type { Tile, TileGroup } from './tile.js'

/**
 * 風
 */
export type Wind = 'east' | 'south' | 'west' | 'north'

/**
 * 手牌
 */
export interface Hand {
    /** 手牌 (13枚 or 14枚) */
    tiles: Tile[]
    /** 鳴き */
    melds: TileGroup[]
    /** 和了牌 */
    winningTile: Tile
    /** ツモかどうか */
    isTsumo: boolean
}

/**
 * 場の情報
 */
export interface GameContext {
    /** 場風 */
    roundWind: Wind
    /** 自風 */
    seatWind: Wind
    /** ドラ表示牌 */
    dora: Tile[]
    /** 裏ドラ表示牌 */
    uraDora?: Tile[]
    /** 本場 */
    honba: number
    /** リーチ */
    riichi: boolean
    /** ダブルリーチ */
    doubleRiichi?: boolean
    /** 一発 */
    ippatsu?: boolean
    /** 嶺上開花 */
    rinshan?: boolean
    /** 槍槓 */
    chankan?: boolean
    /** 海底/河底 */
    haitei?: boolean
}
