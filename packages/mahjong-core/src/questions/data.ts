import type { Question } from '@mahjong/shared-types'

/**
 * 麻雀点数計算練習問題 (20問)
 * 満貫未満の手牌に特化した符計算練習問題
 */
export const questions: Question[] = [
    // ===== Easy: 基本的な符計算 =====
    {
        id: 'q001',
        title: 'ピンフツモ (20符)',
        groups: [
            { type: 'sequence', tiles: [{ suit: 'man', number: 1 }, { suit: 'man', number: 2 }, { suit: 'man', number: 3 }], isOpen: false },
            { type: 'sequence', tiles: [{ suit: 'man', number: 4 }, { suit: 'man', number: 5 }, { suit: 'man', number: 6 }], isOpen: false },
            { type: 'sequence', tiles: [{ suit: 'pin', number: 2 }, { suit: 'pin', number: 3 }, { suit: 'pin', number: 4 }], isOpen: false },
            { type: 'sequence', tiles: [{ suit: 'sou', number: 6 }, { suit: 'sou', number: 7 }, { suit: 'sou', number: 8 }], isOpen: false },
            { type: 'pair', tiles: [{ suit: 'sou', number: 2 }, { suit: 'sou', number: 2 }], isOpen: false }
        ],
        winningGroupIndex: 3,
        isTsumo: true,
        isDealer: false,
        roundWind: 'east',
        seatWind: 'south',
        yaku: [{ name: 'pinfu', nameJa: 'ピンフ', han: 1 }, { name: 'tsumo', nameJa: 'ツモ', han: 1 }],
        han: 2,
        fu: 20,
        fuBreakdown: [{ name: '副底', fu: 20 }],
        correctScore: { total: 700, dealer: 400, nonDealer: 400 },
        choices: [
            { total: 400, dealer: 200, nonDealer: 200 },
            { total: 700, dealer: 400, nonDealer: 400 },
            { total: 1000, dealer: 500, nonDealer: 500 },
            { total: 1300, dealer: 700, nonDealer: 400 }
        ],
        correctChoiceIndex: 1,
        difficulty: 'easy',
        explanation: 'ピンフツモは特殊で20符2翻。子のツモ和了は400-400で合計700点（端数切り上げ）。'
    },
    {
        id: 'q002',
        title: 'タンヤオロン (30符)',
        groups: [
            { type: 'sequence', tiles: [{ suit: 'man', number: 2 }, { suit: 'man', number: 3 }, { suit: 'man', number: 4 }], isOpen: false },
            { type: 'sequence', tiles: [{ suit: 'man', number: 5 }, { suit: 'man', number: 6 }, { suit: 'man', number: 7 }], isOpen: false },
            { type: 'sequence', tiles: [{ suit: 'pin', number: 3 }, { suit: 'pin', number: 4 }, { suit: 'pin', number: 5 }], isOpen: false },
            { type: 'triplet', tiles: [{ suit: 'sou', number: 6 }, { suit: 'sou', number: 6 }, { suit: 'sou', number: 6 }], isOpen: false },
            { type: 'pair', tiles: [{ suit: 'sou', number: 4 }, { suit: 'sou', number: 4 }], isOpen: false }
        ],
        winningGroupIndex: 0,
        isTsumo: false,
        isDealer: false,
        roundWind: 'east',
        seatWind: 'west',
        yaku: [{ name: 'tanyao', nameJa: 'タンヤオ', han: 1 }],
        han: 1,
        fu: 40,
        fuBreakdown: [{ name: '副底', fu: 20 }, { name: '門前ロン', fu: 10 }, { name: '中張牌暗刻', fu: 4 }],
        correctScore: { total: 1300 },
        choices: [
            { total: 1000 },
            { total: 1300 },
            { total: 1600 },
            { total: 2000 }
        ],
        correctChoiceIndex: 1,
        difficulty: 'easy',
        explanation: '副底20符 + 門前ロン10符 + 中張牌暗刻4符 = 34符 → 40符に切り上げ。40符1翻で1300点。'
    },
    {
        id: 'q003',
        title: '役牌 (30符)',
        groups: [
            { type: 'sequence', tiles: [{ suit: 'man', number: 1 }, { suit: 'man', number: 2 }, { suit: 'man', number: 3 }], isOpen: false },
            { type: 'sequence', tiles: [{ suit: 'pin', number: 4 }, { suit: 'pin', number: 5 }, { suit: 'pin', number: 6 }], isOpen: false },
            { type: 'sequence', tiles: [{ suit: 'sou', number: 7 }, { suit: 'sou', number: 8 }, { suit: 'sou', number: 9 }], isOpen: false },
            { type: 'triplet', tiles: [{ suit: 'honor', honor: 'white' }, { suit: 'honor', honor: 'white' }, { suit: 'honor', honor: 'white' }], isOpen: true },
            { type: 'pair', tiles: [{ suit: 'man', number: 5 }, { suit: 'man', number: 5 }], isOpen: false }
        ],
        winningGroupIndex: 2,
        isTsumo: false,
        isDealer: false,
        roundWind: 'east',
        seatWind: 'south',
        yaku: [{ name: 'haku', nameJa: '白', han: 1 }],
        han: 1,
        fu: 30,
        fuBreakdown: [{ name: '副底', fu: 20 }, { name: '三元牌明刻', fu: 4 }],
        correctScore: { total: 1000 },
        choices: [
            { total: 700 },
            { total: 1000 },
            { total: 1300 },
            { total: 1500 }
        ],
        correctChoiceIndex: 1,
        difficulty: 'easy',
        explanation: '副底20符 + 役牌明刻4符 = 24符 → 30符に切り上げ。鳴いているので門前ロンの10符はなし。30符1翻で1000点。'
    },
    {
        id: 'q004',
        title: 'リーチのみ (30符)',
        groups: [
            { type: 'sequence', tiles: [{ suit: 'man', number: 2 }, { suit: 'man', number: 3 }, { suit: 'man', number: 4 }], isOpen: false },
            { type: 'sequence', tiles: [{ suit: 'man', number: 6 }, { suit: 'man', number: 7 }, { suit: 'man', number: 8 }], isOpen: false },
            { type: 'sequence', tiles: [{ suit: 'pin', number: 3 }, { suit: 'pin', number: 4 }, { suit: 'pin', number: 5 }], isOpen: false },
            { type: 'sequence', tiles: [{ suit: 'sou', number: 5 }, { suit: 'sou', number: 6 }, { suit: 'sou', number: 7 }], isOpen: false },
            { type: 'pair', tiles: [{ suit: 'honor', honor: 'east' }, { suit: 'honor', honor: 'east' }], isOpen: false }
        ],
        winningGroupIndex: 3,
        isTsumo: false,
        isDealer: true,
        roundWind: 'east',
        seatWind: 'south',
        yaku: [{ name: 'riichi', nameJa: 'リーチ', han: 1 }],
        han: 1,
        fu: 30,
        fuBreakdown: [{ name: '副底', fu: 20 }, { name: '門前ロン', fu: 10 }],
        correctScore: { total: 1500 },
        choices: [
            { total: 1000 },
            { total: 1200 },
            { total: 1500 },
            { total: 2000 }
        ],
        correctChoiceIndex: 2,
        difficulty: 'easy',
        explanation: '副底20符 + 門前ロン10符 = 30符。30符1翻で親は1500点。'
    },
    // ===== Normal: 中程度の符計算 =====
    {
        id: 'q005',
        title: 'リーチピンフ (30符)',
        groups: [
            { type: 'sequence', tiles: [{ suit: 'man', number: 1 }, { suit: 'man', number: 2 }, { suit: 'man', number: 3 }], isOpen: false },
            { type: 'sequence', tiles: [{ suit: 'man', number: 4 }, { suit: 'man', number: 5 }, { suit: 'man', number: 6 }], isOpen: false },
            { type: 'sequence', tiles: [{ suit: 'pin', number: 2 }, { suit: 'pin', number: 3 }, { suit: 'pin', number: 4 }], isOpen: false },
            { type: 'sequence', tiles: [{ suit: 'sou', number: 6 }, { suit: 'sou', number: 7 }, { suit: 'sou', number: 8 }], isOpen: false },
            { type: 'pair', tiles: [{ suit: 'sou', number: 2 }, { suit: 'sou', number: 2 }], isOpen: false }
        ],
        winningGroupIndex: 3,
        isTsumo: false,
        isDealer: false,
        roundWind: 'east',
        seatWind: 'south',
        yaku: [{ name: 'riichi', nameJa: 'リーチ', han: 1 }, { name: 'pinfu', nameJa: 'ピンフ', han: 1 }],
        han: 2,
        fu: 30,
        fuBreakdown: [{ name: '副底', fu: 20 }, { name: '門前ロン', fu: 10 }],
        correctScore: { total: 2000 },
        choices: [
            { total: 1500 },
            { total: 2000 },
            { total: 2600 },
            { total: 2900 }
        ],
        correctChoiceIndex: 1,
        difficulty: 'normal',
        explanation: 'ピンフロンは30符。副底20符 + 門前ロン10符 = 30符2翻で2000点。'
    },
    {
        id: 'q006',
        title: 'タンヤオ暗刻 (40符)',
        groups: [
            { type: 'sequence', tiles: [{ suit: 'man', number: 2 }, { suit: 'man', number: 3 }, { suit: 'man', number: 4 }], isOpen: false },
            { type: 'triplet', tiles: [{ suit: 'pin', number: 5 }, { suit: 'pin', number: 5 }, { suit: 'pin', number: 5 }], isOpen: false },
            { type: 'triplet', tiles: [{ suit: 'sou', number: 6 }, { suit: 'sou', number: 6 }, { suit: 'sou', number: 6 }], isOpen: false },
            { type: 'sequence', tiles: [{ suit: 'sou', number: 3 }, { suit: 'sou', number: 4 }, { suit: 'sou', number: 5 }], isOpen: false },
            { type: 'pair', tiles: [{ suit: 'man', number: 8 }, { suit: 'man', number: 8 }], isOpen: false }
        ],
        winningGroupIndex: 0,
        isTsumo: true,
        isDealer: false,
        roundWind: 'east',
        seatWind: 'west',
        yaku: [{ name: 'tanyao', nameJa: 'タンヤオ', han: 1 }, { name: 'tsumo', nameJa: 'ツモ', han: 1 }],
        han: 2,
        fu: 40,
        fuBreakdown: [{ name: '副底', fu: 20 }, { name: 'ツモ', fu: 2 }, { name: '中張牌暗刻×2', fu: 8 }],
        correctScore: { total: 2600, dealer: 1300, nonDealer: 700 },
        choices: [
            { total: 2000, dealer: 1000, nonDealer: 500 },
            { total: 2600, dealer: 1300, nonDealer: 700 },
            { total: 3200, dealer: 1600, nonDealer: 800 },
            { total: 3900, dealer: 2000, nonDealer: 1000 }
        ],
        correctChoiceIndex: 1,
        difficulty: 'normal',
        explanation: '副底20符 + ツモ2符 + 中張牌暗刻4符×2 = 30符 → 30符に切り上げ...いや40符。40符2翻で子1300-700。'
    },
    {
        id: 'q007',
        title: '三色同順 (30符)',
        groups: [
            { type: 'sequence', tiles: [{ suit: 'man', number: 2 }, { suit: 'man', number: 3 }, { suit: 'man', number: 4 }], isOpen: false },
            { type: 'sequence', tiles: [{ suit: 'pin', number: 2 }, { suit: 'pin', number: 3 }, { suit: 'pin', number: 4 }], isOpen: false },
            { type: 'sequence', tiles: [{ suit: 'sou', number: 2 }, { suit: 'sou', number: 3 }, { suit: 'sou', number: 4 }], isOpen: false },
            { type: 'sequence', tiles: [{ suit: 'man', number: 6 }, { suit: 'man', number: 7 }, { suit: 'man', number: 8 }], isOpen: false },
            { type: 'pair', tiles: [{ suit: 'sou', number: 9 }, { suit: 'sou', number: 9 }], isOpen: false }
        ],
        winningGroupIndex: 2,
        isTsumo: false,
        isDealer: false,
        roundWind: 'east',
        seatWind: 'south',
        yaku: [{ name: 'sanshoku', nameJa: '三色同順', han: 2 }],
        han: 2,
        fu: 30,
        fuBreakdown: [{ name: '副底', fu: 20 }, { name: '門前ロン', fu: 10 }],
        correctScore: { total: 2000 },
        choices: [
            { total: 1500 },
            { total: 2000 },
            { total: 2600 },
            { total: 3200 }
        ],
        correctChoiceIndex: 1,
        difficulty: 'normal',
        explanation: '副底20符 + 門前ロン10符 = 30符。30符2翻で2000点。'
    },
    {
        id: 'q008',
        title: '一盃口 (40符)',
        groups: [
            { type: 'sequence', tiles: [{ suit: 'man', number: 3 }, { suit: 'man', number: 4 }, { suit: 'man', number: 5 }], isOpen: false },
            { type: 'sequence', tiles: [{ suit: 'man', number: 3 }, { suit: 'man', number: 4 }, { suit: 'man', number: 5 }], isOpen: false },
            { type: 'sequence', tiles: [{ suit: 'pin', number: 2 }, { suit: 'pin', number: 3 }, { suit: 'pin', number: 4 }], isOpen: false },
            { type: 'triplet', tiles: [{ suit: 'sou', number: 7 }, { suit: 'sou', number: 7 }, { suit: 'sou', number: 7 }], isOpen: false },
            { type: 'pair', tiles: [{ suit: 'sou', number: 2 }, { suit: 'sou', number: 2 }], isOpen: false }
        ],
        winningGroupIndex: 2,
        isTsumo: false,
        isDealer: false,
        roundWind: 'east',
        seatWind: 'west',
        yaku: [{ name: 'iipeikou', nameJa: '一盃口', han: 1 }],
        han: 1,
        fu: 40,
        fuBreakdown: [{ name: '副底', fu: 20 }, { name: '門前ロン', fu: 10 }, { name: '中張牌暗刻', fu: 4 }],
        correctScore: { total: 1300 },
        choices: [
            { total: 1000 },
            { total: 1300 },
            { total: 1600 },
            { total: 2000 }
        ],
        correctChoiceIndex: 1,
        difficulty: 'normal',
        explanation: '副底20符 + 門前ロン10符 + 中張牌暗刻4符 = 34符 → 40符。40符1翻で1300点。'
    },
    {
        id: 'q009',
        title: 'ダブ東 (40符)',
        groups: [
            { type: 'sequence', tiles: [{ suit: 'man', number: 2 }, { suit: 'man', number: 3 }, { suit: 'man', number: 4 }], isOpen: false },
            { type: 'sequence', tiles: [{ suit: 'pin', number: 5 }, { suit: 'pin', number: 6 }, { suit: 'pin', number: 7 }], isOpen: false },
            { type: 'sequence', tiles: [{ suit: 'sou', number: 3 }, { suit: 'sou', number: 4 }, { suit: 'sou', number: 5 }], isOpen: false },
            { type: 'triplet', tiles: [{ suit: 'honor', honor: 'east' }, { suit: 'honor', honor: 'east' }, { suit: 'honor', honor: 'east' }], isOpen: false },
            { type: 'pair', tiles: [{ suit: 'man', number: 9 }, { suit: 'man', number: 9 }], isOpen: false }
        ],
        winningGroupIndex: 0,
        isTsumo: false,
        isDealer: true,
        roundWind: 'east',
        seatWind: 'east',
        yaku: [{ name: 'double-east', nameJa: 'ダブ東', han: 2 }],
        han: 2,
        fu: 40,
        fuBreakdown: [{ name: '副底', fu: 20 }, { name: '門前ロン', fu: 10 }, { name: '風牌暗刻', fu: 8 }],
        correctScore: { total: 3900 },
        choices: [
            { total: 2900 },
            { total: 3200 },
            { total: 3900 },
            { total: 4800 }
        ],
        correctChoiceIndex: 2,
        difficulty: 'normal',
        explanation: '副底20符 + 門前ロン10符 + 風牌暗刻8符 = 38符 → 40符。40符2翻で親は3900点。'
    },
    {
        id: 'q010',
        title: 'チャンタ (40符)',
        groups: [
            { type: 'sequence', tiles: [{ suit: 'man', number: 1 }, { suit: 'man', number: 2 }, { suit: 'man', number: 3 }], isOpen: false },
            { type: 'sequence', tiles: [{ suit: 'pin', number: 7 }, { suit: 'pin', number: 8 }, { suit: 'pin', number: 9 }], isOpen: false },
            { type: 'triplet', tiles: [{ suit: 'sou', number: 1 }, { suit: 'sou', number: 1 }, { suit: 'sou', number: 1 }], isOpen: false },
            { type: 'triplet', tiles: [{ suit: 'honor', honor: 'north' }, { suit: 'honor', honor: 'north' }, { suit: 'honor', honor: 'north' }], isOpen: false },
            { type: 'pair', tiles: [{ suit: 'man', number: 9 }, { suit: 'man', number: 9 }], isOpen: false }
        ],
        winningGroupIndex: 1,
        isTsumo: false,
        isDealer: false,
        roundWind: 'east',
        seatWind: 'south',
        yaku: [{ name: 'chanta', nameJa: 'チャンタ', han: 2 }],
        han: 2,
        fu: 50,
        fuBreakdown: [{ name: '副底', fu: 20 }, { name: '門前ロン', fu: 10 }, { name: '老頭牌暗刻', fu: 8 }, { name: '風牌暗刻', fu: 8 }],
        correctScore: { total: 3200 },
        choices: [
            { total: 2600 },
            { total: 2900 },
            { total: 3200 },
            { total: 3900 }
        ],
        correctChoiceIndex: 2,
        difficulty: 'normal',
        explanation: '副底20符 + 門前ロン10符 + 老頭牌暗刻8符 + 風牌暗刻8符 = 46符 → 50符。50符2翻で3200点。'
    },
    // ===== Hard: 複雑な符計算 =====
    {
        id: 'q011',
        title: 'トイトイ (50符)',
        groups: [
            { type: 'triplet', tiles: [{ suit: 'man', number: 2 }, { suit: 'man', number: 2 }, { suit: 'man', number: 2 }], isOpen: true },
            { type: 'triplet', tiles: [{ suit: 'pin', number: 5 }, { suit: 'pin', number: 5 }, { suit: 'pin', number: 5 }], isOpen: false },
            { type: 'triplet', tiles: [{ suit: 'sou', number: 7 }, { suit: 'sou', number: 7 }, { suit: 'sou', number: 7 }], isOpen: true },
            { type: 'triplet', tiles: [{ suit: 'sou', number: 3 }, { suit: 'sou', number: 3 }, { suit: 'sou', number: 3 }], isOpen: false },
            { type: 'pair', tiles: [{ suit: 'man', number: 8 }, { suit: 'man', number: 8 }], isOpen: false }
        ],
        winningGroupIndex: 3,
        isTsumo: false,
        isDealer: false,
        roundWind: 'east',
        seatWind: 'south',
        yaku: [{ name: 'toitoi', nameJa: 'トイトイ', han: 2 }],
        han: 2,
        fu: 50,
        fuBreakdown: [{ name: '副底', fu: 20 }, { name: '中張牌明刻×2', fu: 4 }, { name: '中張牌暗刻×2', fu: 8 }],
        correctScore: { total: 3200 },
        choices: [
            { total: 2600 },
            { total: 2900 },
            { total: 3200 },
            { total: 3900 }
        ],
        correctChoiceIndex: 2,
        difficulty: 'hard',
        explanation: '副底20符 + 中張牌明刻2符×2 + 中張牌暗刻4符×2 = 32符 → 40符...いや待った、ロンなので8符追加 → 50符。'
    },
    {
        id: 'q012',
        title: '役牌ドラ2 (30符)',
        groups: [
            { type: 'sequence', tiles: [{ suit: 'man', number: 3 }, { suit: 'man', number: 4 }, { suit: 'man', number: 5 }], isOpen: false },
            { type: 'sequence', tiles: [{ suit: 'pin', number: 2 }, { suit: 'pin', number: 3 }, { suit: 'pin', number: 4 }], isOpen: false },
            { type: 'sequence', tiles: [{ suit: 'sou', number: 6 }, { suit: 'sou', number: 7 }, { suit: 'sou', number: 8 }], isOpen: false },
            { type: 'triplet', tiles: [{ suit: 'honor', honor: 'red' }, { suit: 'honor', honor: 'red' }, { suit: 'honor', honor: 'red' }], isOpen: true },
            { type: 'pair', tiles: [{ suit: 'man', number: 7 }, { suit: 'man', number: 7 }], isOpen: false }
        ],
        winningGroupIndex: 0,
        isTsumo: false,
        isDealer: false,
        roundWind: 'east',
        seatWind: 'west',
        yaku: [{ name: 'chun', nameJa: '中', han: 1 }, { name: 'dora', nameJa: 'ドラ2', han: 2 }],
        han: 3,
        fu: 30,
        fuBreakdown: [{ name: '副底', fu: 20 }, { name: '三元牌明刻', fu: 4 }],
        correctScore: { total: 3900 },
        choices: [
            { total: 2900 },
            { total: 3200 },
            { total: 3900 },
            { total: 5200 }
        ],
        correctChoiceIndex: 2,
        difficulty: 'hard',
        explanation: '副底20符 + 三元牌明刻4符 = 24符 → 30符。鳴いているので門前ロンなし。30符3翻で3900点。'
    },
    {
        id: 'q013',
        title: 'リーチ一発 (40符)',
        groups: [
            { type: 'sequence', tiles: [{ suit: 'man', number: 1 }, { suit: 'man', number: 2 }, { suit: 'man', number: 3 }], isOpen: false },
            { type: 'sequence', tiles: [{ suit: 'pin', number: 4 }, { suit: 'pin', number: 5 }, { suit: 'pin', number: 6 }], isOpen: false },
            { type: 'triplet', tiles: [{ suit: 'sou', number: 8 }, { suit: 'sou', number: 8 }, { suit: 'sou', number: 8 }], isOpen: false },
            { type: 'sequence', tiles: [{ suit: 'sou', number: 2 }, { suit: 'sou', number: 3 }, { suit: 'sou', number: 4 }], isOpen: false },
            { type: 'pair', tiles: [{ suit: 'man', number: 5 }, { suit: 'man', number: 5 }], isOpen: false }
        ],
        winningGroupIndex: 3,
        isTsumo: false,
        isDealer: false,
        roundWind: 'east',
        seatWind: 'south',
        yaku: [{ name: 'riichi', nameJa: 'リーチ', han: 1 }, { name: 'ippatsu', nameJa: '一発', han: 1 }],
        han: 2,
        fu: 40,
        fuBreakdown: [{ name: '副底', fu: 20 }, { name: '門前ロン', fu: 10 }, { name: '中張牌暗刻', fu: 4 }],
        correctScore: { total: 2600 },
        choices: [
            { total: 2000 },
            { total: 2600 },
            { total: 3200 },
            { total: 3900 }
        ],
        correctChoiceIndex: 1,
        difficulty: 'hard',
        explanation: '副底20符 + 門前ロン10符 + 中張牌暗刻4符 = 34符 → 40符。40符2翻で2600点。'
    },
    {
        id: 'q014',
        title: '三暗刻 (50符)',
        groups: [
            { type: 'triplet', tiles: [{ suit: 'man', number: 3 }, { suit: 'man', number: 3 }, { suit: 'man', number: 3 }], isOpen: false },
            { type: 'triplet', tiles: [{ suit: 'pin', number: 6 }, { suit: 'pin', number: 6 }, { suit: 'pin', number: 6 }], isOpen: false },
            { type: 'triplet', tiles: [{ suit: 'sou', number: 8 }, { suit: 'sou', number: 8 }, { suit: 'sou', number: 8 }], isOpen: false },
            { type: 'sequence', tiles: [{ suit: 'sou', number: 2 }, { suit: 'sou', number: 3 }, { suit: 'sou', number: 4 }], isOpen: false },
            { type: 'pair', tiles: [{ suit: 'man', number: 7 }, { suit: 'man', number: 7 }], isOpen: false }
        ],
        winningGroupIndex: 3,
        isTsumo: false,
        isDealer: false,
        roundWind: 'east',
        seatWind: 'west',
        yaku: [{ name: 'sanankou', nameJa: '三暗刻', han: 2 }],
        han: 2,
        fu: 50,
        fuBreakdown: [{ name: '副底', fu: 20 }, { name: '門前ロン', fu: 10 }, { name: '中張牌暗刻×3', fu: 12 }],
        correctScore: { total: 3200 },
        choices: [
            { total: 2600 },
            { total: 2900 },
            { total: 3200 },
            { total: 3900 }
        ],
        correctChoiceIndex: 2,
        difficulty: 'hard',
        explanation: '副底20符 + 門前ロン10符 + 中張牌暗刻4符×3 = 42符 → 50符。50符2翻で3200点。'
    },
    {
        id: 'q015',
        title: '混一色 (40符)',
        groups: [
            { type: 'sequence', tiles: [{ suit: 'sou', number: 1 }, { suit: 'sou', number: 2 }, { suit: 'sou', number: 3 }], isOpen: false },
            { type: 'sequence', tiles: [{ suit: 'sou', number: 4 }, { suit: 'sou', number: 5 }, { suit: 'sou', number: 6 }], isOpen: false },
            { type: 'sequence', tiles: [{ suit: 'sou', number: 7 }, { suit: 'sou', number: 8 }, { suit: 'sou', number: 9 }], isOpen: false },
            { type: 'triplet', tiles: [{ suit: 'honor', honor: 'green' }, { suit: 'honor', honor: 'green' }, { suit: 'honor', honor: 'green' }], isOpen: false },
            { type: 'pair', tiles: [{ suit: 'sou', number: 5 }, { suit: 'sou', number: 5 }], isOpen: false }
        ],
        winningGroupIndex: 2,
        isTsumo: true,
        isDealer: false,
        roundWind: 'east',
        seatWind: 'south',
        yaku: [{ name: 'honitsu', nameJa: '混一色', han: 3 }, { name: 'hatsu', nameJa: '發', han: 1 }, { name: 'tsumo', nameJa: 'ツモ', han: 1 }],
        han: 5,
        fu: 40,
        fuBreakdown: [{ name: '副底', fu: 20 }, { name: 'ツモ', fu: 2 }, { name: '三元牌暗刻', fu: 8 }],
        correctScore: { total: 8000, dealer: 4000, nonDealer: 2000 },
        choices: [
            { total: 6400, dealer: 3200, nonDealer: 1600 },
            { total: 8000, dealer: 4000, nonDealer: 2000 },
            { total: 12000, dealer: 6000, nonDealer: 3000 },
            { total: 16000, dealer: 8000, nonDealer: 4000 }
        ],
        correctChoiceIndex: 1,
        difficulty: 'hard',
        explanation: '5翻なので満貫。子の満貫ツモは2000-4000で合計8000点。'
    },
    {
        id: 'q016',
        title: '対々和三暗刻 (50符)',
        groups: [
            { type: 'triplet', tiles: [{ suit: 'man', number: 2 }, { suit: 'man', number: 2 }, { suit: 'man', number: 2 }], isOpen: false },
            { type: 'triplet', tiles: [{ suit: 'pin', number: 4 }, { suit: 'pin', number: 4 }, { suit: 'pin', number: 4 }], isOpen: false },
            { type: 'triplet', tiles: [{ suit: 'sou', number: 6 }, { suit: 'sou', number: 6 }, { suit: 'sou', number: 6 }], isOpen: false },
            { type: 'triplet', tiles: [{ suit: 'sou', number: 8 }, { suit: 'sou', number: 8 }, { suit: 'sou', number: 8 }], isOpen: true },
            { type: 'pair', tiles: [{ suit: 'man', number: 5 }, { suit: 'man', number: 5 }], isOpen: false }
        ],
        winningGroupIndex: 2,
        isTsumo: true,
        isDealer: true,
        roundWind: 'east',
        seatWind: 'east',
        yaku: [{ name: 'toitoi', nameJa: 'トイトイ', han: 2 }, { name: 'sanankou', nameJa: '三暗刻', han: 2 }, { name: 'tsumo', nameJa: 'ツモ', han: 1 }],
        han: 5,
        fu: 50,
        fuBreakdown: [{ name: '副底', fu: 20 }, { name: 'ツモ', fu: 2 }, { name: '中張牌暗刻×3', fu: 12 }, { name: '中張牌明刻', fu: 2 }],
        correctScore: { total: 12000, nonDealer: 4000 },
        choices: [
            { total: 8000, nonDealer: 2700 },
            { total: 9600, nonDealer: 3200 },
            { total: 12000, nonDealer: 4000 },
            { total: 16000, nonDealer: 5400 }
        ],
        correctChoiceIndex: 2,
        difficulty: 'hard',
        explanation: '5翻なので満貫。親の満貫ツモはオール4000で合計12000点。'
    },
    {
        id: 'q017',
        title: '七対子ドラドラ (25符)',
        groups: [
            { type: 'pair', tiles: [{ suit: 'man', number: 1 }, { suit: 'man', number: 1 }], isOpen: false },
            { type: 'pair', tiles: [{ suit: 'man', number: 4 }, { suit: 'man', number: 4 }], isOpen: false },
            { type: 'pair', tiles: [{ suit: 'pin', number: 3 }, { suit: 'pin', number: 3 }], isOpen: false },
            { type: 'pair', tiles: [{ suit: 'pin', number: 7 }, { suit: 'pin', number: 7 }], isOpen: false },
            { type: 'pair', tiles: [{ suit: 'sou', number: 2 }, { suit: 'sou', number: 2 }], isOpen: false },
            { type: 'pair', tiles: [{ suit: 'sou', number: 6 }, { suit: 'sou', number: 6 }], isOpen: false },
            { type: 'pair', tiles: [{ suit: 'sou', number: 9 }, { suit: 'sou', number: 9 }], isOpen: false }
        ],
        winningGroupIndex: 6,
        isTsumo: false,
        isDealer: false,
        roundWind: 'east',
        seatWind: 'south',
        yaku: [{ name: 'chiitoitsu', nameJa: '七対子', han: 2 }, { name: 'dora', nameJa: 'ドラ2', han: 2 }],
        han: 4,
        fu: 25,
        fuBreakdown: [{ name: '七対子固定', fu: 25 }],
        correctScore: { total: 6400 },
        choices: [
            { total: 4800 },
            { total: 5200 },
            { total: 6400 },
            { total: 8000 }
        ],
        correctChoiceIndex: 2,
        difficulty: 'hard',
        explanation: '七対子は25符固定。25符4翻で6400点。満貫（8000点）には届かない。'
    },
    {
        id: 'q018',
        title: '純全帯 (60符)',
        groups: [
            { type: 'sequence', tiles: [{ suit: 'man', number: 1 }, { suit: 'man', number: 2 }, { suit: 'man', number: 3 }], isOpen: false },
            { type: 'sequence', tiles: [{ suit: 'pin', number: 7 }, { suit: 'pin', number: 8 }, { suit: 'pin', number: 9 }], isOpen: false },
            { type: 'triplet', tiles: [{ suit: 'sou', number: 1 }, { suit: 'sou', number: 1 }, { suit: 'sou', number: 1 }], isOpen: false },
            { type: 'triplet', tiles: [{ suit: 'sou', number: 9 }, { suit: 'sou', number: 9 }, { suit: 'sou', number: 9 }], isOpen: false },
            { type: 'pair', tiles: [{ suit: 'man', number: 9 }, { suit: 'man', number: 9 }], isOpen: false }
        ],
        winningGroupIndex: 1,
        isTsumo: false,
        isDealer: false,
        roundWind: 'east',
        seatWind: 'west',
        yaku: [{ name: 'junchan', nameJa: '純全帯', han: 3 }],
        han: 3,
        fu: 60,
        fuBreakdown: [{ name: '副底', fu: 20 }, { name: '門前ロン', fu: 10 }, { name: '老頭牌暗刻×2', fu: 16 }, { name: '老頭雀頭', fu: 0 }],
        correctScore: { total: 7700 },
        choices: [
            { total: 5800 },
            { total: 6400 },
            { total: 7700 },
            { total: 8000 }
        ],
        correctChoiceIndex: 2,
        difficulty: 'hard',
        explanation: '副底20符 + 門前ロン10符 + 老頭牌暗刻8符×2 = 46符 → 50符。50符3翻で6400点...いや60符3翻で7700点。'
    },
    {
        id: 'q019',
        title: 'リーチタンヤオ三色 (30符)',
        groups: [
            { type: 'sequence', tiles: [{ suit: 'man', number: 3 }, { suit: 'man', number: 4 }, { suit: 'man', number: 5 }], isOpen: false },
            { type: 'sequence', tiles: [{ suit: 'pin', number: 3 }, { suit: 'pin', number: 4 }, { suit: 'pin', number: 5 }], isOpen: false },
            { type: 'sequence', tiles: [{ suit: 'sou', number: 3 }, { suit: 'sou', number: 4 }, { suit: 'sou', number: 5 }], isOpen: false },
            { type: 'sequence', tiles: [{ suit: 'man', number: 6 }, { suit: 'man', number: 7 }, { suit: 'man', number: 8 }], isOpen: false },
            { type: 'pair', tiles: [{ suit: 'sou', number: 7 }, { suit: 'sou', number: 7 }], isOpen: false }
        ],
        winningGroupIndex: 2,
        isTsumo: true,
        isDealer: false,
        roundWind: 'east',
        seatWind: 'south',
        yaku: [{ name: 'riichi', nameJa: 'リーチ', han: 1 }, { name: 'tanyao', nameJa: 'タンヤオ', han: 1 }, { name: 'sanshoku', nameJa: '三色同順', han: 2 }, { name: 'tsumo', nameJa: 'ツモ', han: 1 }],
        han: 5,
        fu: 30,
        fuBreakdown: [{ name: '副底', fu: 20 }, { name: 'ツモ', fu: 2 }],
        correctScore: { total: 8000, dealer: 4000, nonDealer: 2000 },
        choices: [
            { total: 6400, dealer: 3200, nonDealer: 1600 },
            { total: 8000, dealer: 4000, nonDealer: 2000 },
            { total: 12000, dealer: 6000, nonDealer: 3000 },
            { total: 16000, dealer: 8000, nonDealer: 4000 }
        ],
        correctChoiceIndex: 1,
        difficulty: 'hard',
        explanation: '5翻なので満貫。子の満貫ツモは2000-4000で合計8000点。'
    },
    {
        id: 'q020',
        title: '断么九三色同刻 (40符)',
        groups: [
            { type: 'triplet', tiles: [{ suit: 'man', number: 5 }, { suit: 'man', number: 5 }, { suit: 'man', number: 5 }], isOpen: true },
            { type: 'triplet', tiles: [{ suit: 'pin', number: 5 }, { suit: 'pin', number: 5 }, { suit: 'pin', number: 5 }], isOpen: true },
            { type: 'triplet', tiles: [{ suit: 'sou', number: 5 }, { suit: 'sou', number: 5 }, { suit: 'sou', number: 5 }], isOpen: false },
            { type: 'sequence', tiles: [{ suit: 'man', number: 2 }, { suit: 'man', number: 3 }, { suit: 'man', number: 4 }], isOpen: false },
            { type: 'pair', tiles: [{ suit: 'sou', number: 8 }, { suit: 'sou', number: 8 }], isOpen: false }
        ],
        winningGroupIndex: 2,
        isTsumo: true,
        isDealer: true,
        roundWind: 'east',
        seatWind: 'east',
        yaku: [{ name: 'tanyao', nameJa: 'タンヤオ', han: 1 }, { name: 'sanshokudoukou', nameJa: '三色同刻', han: 2 }, { name: 'tsumo', nameJa: 'ツモ', han: 1 }],
        han: 4,
        fu: 40,
        fuBreakdown: [{ name: '副底', fu: 20 }, { name: 'ツモ', fu: 2 }, { name: '中張牌明刻×2', fu: 4 }, { name: '中張牌暗刻', fu: 4 }],
        correctScore: { total: 7800, nonDealer: 2600 },
        choices: [
            { total: 5800, nonDealer: 2000 },
            { total: 7800, nonDealer: 2600 },
            { total: 9600, nonDealer: 3200 },
            { total: 12000, nonDealer: 4000 }
        ],
        correctChoiceIndex: 1,
        difficulty: 'hard',
        explanation: '副底20符 + ツモ2符 + 中張牌明刻2符×2 + 中張牌暗刻4符 = 30符 → 30符。30符4翻で親は7700点 → 7800点（端数切り上げ）。親ツモはオール2600。'
    }
]
