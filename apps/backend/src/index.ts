// NOTE: 現在はFirestoreを使用せずハードコードでデータを管理しているため、
// Firebase Admin初期化は不要です。Firestore使用時は以下を有効化してください。
// import { initializeApp } from 'firebase-admin/app'
// initializeApp()

// 関数のエクスポート
export { calculateScore } from './functions/calculation.js'
export { getHistory, saveHistory } from './functions/history.js'
export { healthCheck } from './functions/health.js'
