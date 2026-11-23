# AmidaKuji-iOS 🎯

SwiftUIで開発した、シンプルなiPhone向けあみだくじアプリです。

人数と結果を設定して、手軽にあみだくじを楽しめます。

## 📱 主な機能

- **人数設定**：2〜30人まで対応
- **メンバー表示**：絵文字アイコンで参加者を表示
- **結果の編集**：あみだくじの結果を自由に設定
- **シャッフル**：横線をランダムに再生成
- **経路アニメーション**：選択したメンバーの経路をオレンジ色で表示
- **結果表示**：抽選結果をポップアップで表示

## 🛠 使用技術

- Swift
- SwiftUI
- Xcode
- iOS

## 🚀 実行方法

1. リポジトリをクローンします。
2. `AmidaKuji.xcodeproj` をXcodeで開きます。
3. Signing & Capabilitiesで自分の開発チームを設定します。
4. iPhoneを実行先に選択してビルド・実行します。

※ 無料のApple Accountで実機にインストールした場合、通常7日間の署名制限があります。

## 📂 プロジェクト構成

| ファイル | 役割 |
|---|---|
| `ContentView.swift` | 人数入力画面 |
| `MemberListView.swift` | メンバー一覧画面 |
| `ResultSettingsView.swift` | 結果設定画面 |
| `AmidaGameView.swift` | あみだくじの抽選処理 |
| `AmidaBoard.swift` | あみだくじの描画・アニメーション |
| `AmidaModels.swift` | データモデル |
| `AmidaStyle.swift` | 共通デザイン |
