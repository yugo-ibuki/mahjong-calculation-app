import { beforeAll, afterAll, vi } from 'vitest'

// Firebase Admin のモック
vi.mock('firebase-admin/app', () => ({
    initializeApp: vi.fn(),
    getApp: vi.fn(),
}))

vi.mock('firebase-admin/firestore', () => ({
    getFirestore: vi.fn(() => ({
        collection: vi.fn(() => ({
            where: vi.fn().mockReturnThis(),
            orderBy: vi.fn().mockReturnThis(),
            limit: vi.fn().mockReturnThis(),
            get: vi.fn().mockResolvedValue({ docs: [] }),
            add: vi.fn().mockResolvedValue({ id: 'test-id' }),
        })),
    })),
    Timestamp: {
        now: vi.fn(() => ({ toDate: () => new Date() })),
    },
}))

beforeAll(() => {
    // テスト前のセットアップ
    console.log('Test setup initialized')
})

afterAll(() => {
    // テスト後のクリーンアップ
    vi.clearAllMocks()
})
