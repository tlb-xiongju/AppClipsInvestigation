# App Clips検討会
App Clips、WWDC2020、SDK iOS14+、Xcode12+

## はじめり

### 概要
本アプリの機能と重ねるミニアプリです、本アプリインストールされてなくても、ミニアプリで本アプリの複数の機能の中の一つが使えます。
> 例え：  
  カフェアプリ、本アプリはコーヒーを注文、ベネフィット受け取り、お気に入りリストなど、App Clips（ミニアプリ）はただ注文できます、それ以外の機能はありません。

### 使用例
![](https://docs-assets.developer.apple.com/published/48ca06e0dc/original-1592505224.png)

条件達成 → AppClipsCard立ち上げ → AppClips起動 → 注文

> 注：  
  本アプリインストールされている場合、AppClips起動せず、代わりに本アプリ起動されます。  
  つまり、条件達成 → AppClipsCard立ち上げ → 本アプリ起動 → 注文

### 関連概念
+ Invocation：AppClips起動するに必要な条件、QRCode、Webリンク、メッセージの中のURL、NFC、位置情報、Map
+ AppClipsCard：システムはこのCardを立ち上げる、ユーザーは「Open」ボタンをタップでAppClips開く

### その他
+ AppClipsはホーム画面で表示されない
+ 一定期間使わないなら、AppClipsはシステムに削除される

## AppClipsつくる前

### フレームワーク
主に`SwiftUI`と`UIKit`、基本的に本アプリ使えるフレームワークはAppClipsも使えます。しかし、下記のフレームワークはある機能提供しないように制限されてます：`Assets Library`、`Background Tasks`、`CallKit`、`CareKit`、`CloudKit`、`Contacts`、`Contacts UI`、`Core Motion`、`EventKit`、`EventKit UI`、`File Provider`、`File Provider UI`、`HealthKit`、`HomeKit`、`Media Player`、`Messages`、`Message UI`、`PhotoKit`、`ResearchKit`、`SensorKit`と`Speech`。

> 例：  
  `HealthKit`の`isHeadthDataAvailable()`はAppClipsの中でいつもfalse返してる

### 始まる前

AppClipsは快速起動、ユーザー情報保護などには下記の制限があります：
+ AppClipsのサイズは10MB超えない
+ `SKAdNetwork`使えない
+ App TrackingTransparencyでユーザーを追跡できない
+ デバイスの`name`と`identifierForVendor`は空文字返す
+ 連続位置情報取得できない
+ 本アプリ以外のアプリとデータ共有できない
+ システムアプリのデータアクセスできない
  - Apple MusicとMediaにアクセスできない
  - カレンダー、連絡先、ファイル、健康、メッセージ、リマインダーとアルバムにアクセスできない
  - モーションとフィットネスのデータにアクセスできない
+ バックグラウンドアクティビティできない
  - バックグラウンドURLSessionできない
  - AppClip使わない時、Bluetoothアクセスできない

AppClips効率高めのため、下記の機能は本アプリに移行：
+ 複雑なネットワーク機能
+ App拡張機能
+ カスタマイズ設定、
+ データhandoff
+ アプリ内購入
+ 複数のシーン(iPad)
+ 他のアプリ推薦
+ URL scheme登録
+ Bluetoothスキャン
