# 🛠️ Kanban App Setup Guide

このガイドでは、README.mdに記載されている機能を完全に動作させるための設定手順を説明します。

## 📋 必要な設定

### 1. App Group の設定

ウィジェットとアプリ間でデータを共有するために、App Groupを設定する必要があります。

**Xcodeでの設定手順：**

1. プロジェクトファイルを選択
2. メインターゲット（Kanban）を選択
3. "Signing & Capabilities" タブを開く
4. "+ Capability" ボタンをクリック
5. "App Groups" を追加
6. App Group ID を追加: `group.com.kanban.app`

### 2. ウィジェットターゲットの追加

**手順：**

1. Xcodeで "File" → "New" → "Target"
2. "Widget Extension" を選択
3. プロダクト名: "KanbanWidget"
4. "Include Configuration Intent" のチェックを外す
5. 作成されたウィジェットターゲットにも同じApp Groupを設定

### 3. Info.plist の設定

メインアプリのInfo.plistに以下の設定を追加：

```xml
<key>NSRemindersUsageDescription</key>
<string>This app needs access to Reminders to sync your Kanban tasks with Apple Reminders.</string>
```

### 4. 権限の要求

アプリ初回起動時にRemindersへのアクセス許可を求められます。ユーザーが許可する必要があります。

## 🚀 動作確認

### 基本機能
- ✅ ドラッグ&ドロップでタスクを移動
- ✅ タスクの追加・編集・削除
- ✅ 優先度レベルの設定
- ✅ データの永続化

### ウィジェット機能（iPadOS 17+）
- ✅ ホーム画面でタスク一覧を表示
- ✅ タスク数の表示
- ✅ インタラクティブボタン（ステータス変更）

### Reminders連携
- ✅ タスク作成時にRemindersにも同期
- ✅ タスク更新時にRemindersも更新
- ✅ タスク削除時にRemindersも削除

## 🔧 トラブルシューティング

### ウィジェットが表示されない場合
1. App Groupの設定を確認
2. 実機でテスト（シミュレーターではウィジェットが動作しません）
3. ホーム画面でウィジェットを長押しして追加

### Reminders連携が動作しない場合
1. 設定アプリでRemindersへのアクセス許可を確認
2. Info.plistの設定を確認
3. アプリを再起動

### ドラッグ&ドロップが動作しない場合
1. iPadOS 17+でテスト
2. タスクカードを長押ししてからドラッグ

## 📱 対応デバイス

- **iOS 17.0+** (基本機能)
- **iPadOS 17.0+** (ウィジェット機能)

## 🎯 次のステップ

機能が正常に動作することを確認したら、以下の拡張を検討できます：

1. **チーム機能**: 複数ユーザーでのタスク共有
2. **期限管理**: タスクの締切日設定
3. **通知機能**: 期限前のリマインダー
4. **データエクスポート**: CSV/PDF出力
5. **テーマカスタマイズ**: ダークモード対応

---

**注意**: ウィジェット機能は実機でのテストが必要です。シミュレーターでは動作しません。 