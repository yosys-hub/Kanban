# ✅ Kanban App セットアップ完了チェックリスト

## 🎯 完了した設定

### 1. App Group の設定 ✅
- [x] メインアプリのentitlementsファイルにApp Group設定済み
- [x] ウィジェット拡張のentitlementsファイルにApp Group設定済み
- [x] App Group ID: `group.com.kanban.app`

### 2. Info.plist の設定 ✅
- [x] メインアプリのInfo.plist設定完了（GENERATE_INFOPLIST_FILE使用）
- [x] Reminders権限の説明文追加済み（INFOPLIST_KEY_NSRemindersUsageDescription）
- [x] プロジェクトファイルの設定競合を解決済み

### 3. ウィジェット拡張 ✅
- [x] KanbanWidgetターゲット存在確認
- [x] ウィジェットのInfo.plist設定済み
- [x] ウィジェットのentitlements設定済み

## 🚀 次のステップ

### Xcodeでの確認事項
1. **プロジェクトを開く**: `Kanban.xcodeproj`をXcodeで開く
2. **ターゲット設定確認**: 
   - メインターゲット（Kanban）の"Signing & Capabilities"でApp Groupsが表示されていることを確認
   - ウィジェットターゲット（KanbanWidgetExtension）の"Signing & Capabilities"でApp Groupsが表示されていることを確認
3. **Info.plist確認**: メインターゲットの"Info"タブでReminders権限の説明が表示されていることを確認

### 実機テスト
1. **デバイスにインストール**: 実機にアプリをインストール
2. **権限許可**: 初回起動時にRemindersへのアクセス許可を求めるダイアログが表示されることを確認
3. **ウィジェット追加**: ホーム画面でウィジェットを長押しして追加
4. **機能テスト**: 
   - タスクの追加・編集・削除
   - ドラッグ&ドロップでのタスク移動
   - ウィジェットでのタスク表示
   - Remindersとの同期

## 🔧 トラブルシューティング

### よくある問題と解決方法

#### ウィジェットが表示されない
- **原因**: App Group設定が不完全
- **解決**: Xcodeで両方のターゲットのApp Groups設定を確認

#### Reminders権限が要求されない
- **原因**: Info.plistの設定が反映されていない
- **解決**: プロジェクトをクリーンビルド（Product → Clean Build Folder）

#### ビルドエラーが発生
- **原因**: プロジェクトファイルの設定ミス
- **解決**: Xcodeでプロジェクト設定を確認し、必要に応じて手動で修正

#### "Multiple commands produce Info.plist" エラー
- **原因**: 複数の場所でInfo.plistファイルが生成されている
- **解決**: GENERATE_INFOPLIST_FILE = YESに統一し、手動のInfo.plistファイルを削除

## 📱 対応デバイス要件

- **iOS 17.0+**: 基本機能
- **iPadOS 17.0+**: ウィジェット機能（ドラッグ&ドロップ含む）

## 🎉 セットアップ完了

すべての設定が完了しました！Xcodeでプロジェクトを開いて、実機でテストしてください。

**注意**: ウィジェット機能は実機でのテストが必要です。シミュレーターでは動作しません。 