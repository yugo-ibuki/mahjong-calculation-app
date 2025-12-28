export interface HistoryEntry {
    id: string
    odId: string
    hand: unknown
    context: unknown
    result: unknown
    createdAt: Date
}

// ハードコードされた履歴データ（モック）
const mockHistory: HistoryEntry[] = [
    {
        id: '1',
        odId: 'dummy-user',
        hand: {},
        context: {},
        result: {
            yaku: [{ name: 'riichi', nameJa: 'リーチ', han: 1 }],
            han: 1,
            fu: 30,
            score: { total: 1000 },
        },
        createdAt: new Date('2024-12-28T10:00:00'),
    },
]

// インメモリで履歴を管理
const inMemoryHistory: HistoryEntry[] = [...mockHistory]

/**
 * 履歴管理サービス（ハードコード版）
 *
 * NOTE: Firestoreを使わずインメモリでデータを管理するモック実装。
 * 将来的にFirestoreに置き換え可能。
 */
export class HistoryService {
    async getByUserId(userId: string, limit: number): Promise<HistoryEntry[]> {
        return inMemoryHistory
            .filter((entry) => entry.odId === userId)
            .sort((a, b) => b.createdAt.getTime() - a.createdAt.getTime())
            .slice(0, limit)
    }

    async save(
        userId: string,
        data: { hand: unknown; context: unknown; result: unknown }
    ): Promise<string> {
        const id = `${Date.now()}`
        const newEntry: HistoryEntry = {
            id,
            odId: userId,
            ...data,
            createdAt: new Date(),
        }
        inMemoryHistory.push(newEntry)
        return id
    }
}
