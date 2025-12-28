/**
 * 牌の種類 (スート)
 */
export type TileSuit = 'man' | 'pin' | 'sou' | 'honor'

/**
 * 字牌の種類
 */
export type HonorType = 'east' | 'south' | 'west' | 'north' | 'white' | 'green' | 'red'

/**
 * 牌
 */
export interface Tile {
    /** スート */
    suit: TileSuit
    /** 数牌の場合の数字 (1-9) */
    number?: number
    /** 字牌の種類 */
    honor?: HonorType
    /** 赤ドラかどうか */
    isRed?: boolean
}

/**
 * 牌のグループタイプ
 */
export type TileGroupType = 'sequence' | 'triplet' | 'quad' | 'pair'

/**
 * 牌のグループ (面子・雀頭)
 */
export interface TileGroup {
    /** グループタイプ */
    type: TileGroupType
    /** 構成牌 */
    tiles: Tile[]
    /** 鳴きかどうか */
    isOpen: boolean
}
