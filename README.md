### Demo効果
![Demo](demo.gif)

### AppClips概要
1. ミニアプリ、小さい、本アプリの複数の機能の一つ
2. インストールせずに、使い捨て
3. Siriの位置提案、Websiteバナー、QRCode、NFC、リンク、AppClip Codeをトリグルとして

### 用例
1. カフェアプリ：
   本アプリは、注文、特典、お気に入りなど
   ミニアプリは、ただ注文だけ
   カフェ近づいたら、AppClip Cardは表示される

### 注意点
+ 一つ本アプリは、一つAppClipしか作れない
+ 本アプリはAppClipで機能含む
+ 10MB超えない
+ 本アプリの中、使えるフレームワークは、使えるけど、限定あり
+ バックグラウンドアクティビティー禁止
+ 機能簡単にする（複雑な機能は本アプリに移行、アプリ内課金やBluetoothペアリングなど）
+ AppClipは一定時間経ったらシステムに削除
+ 本アプリインストールの場合、AppClip表示しない

### 開発流れ
1. 本アプリのプロジェクトに、AppClip target追加する
   - AppClip target
   - com.apple.developer.on-demand-install-capable entitlement（AppClip targetだけ)
   - BundleIDは本アプリのBundleID.xxxになってる
   - debug用_XCAppClipURLという環境変数
2. 本アプリからコードなどを共有
   - 本アプリは新しい場合、まずAppClipの機能決める
   - 既存のプロジェクトにAppClip追加する場合、コードをリファクタリングしてからAppClipに共有
   - assetsなど共有
3. 共有コードの中、本アプリ用コードとAppClip用コード分ける
   ```swift
   #if APPCLIP
      // Code used in App Clip
   #else
      // Code used in Parent App
   #endif
   ```
4. Associate-Domains-Entitlementを本アプリとAppClipに追加
5. Associate Domains URLの処理
6. ...

### 技術ポイント：
- 本アプリで使えるフレームワークは、AppClipも使える（制限あり）
- 本アプリとAppClipコード共有のため、Active Compilation Conditionsでコード分ける
- トリグルのURLでAppClipかアプリ起動するため、Associate Domainsオンにするのが必要だ
- Siri提案として表示されるため、AppClipの配置認証が必要
  ```
  {
    "appclips": {
        "apps": ["ABCED12345.com.example.MyApp.Clip"]
    }
    ...
  }
  ```
- AppStoreConnectでAppClip Card配置。開発段階はiPhoneのDeveloperの中で配置できる
- Invocationsで起動、NSUserActivity通じて情報とる
- App Groupsで本アプリとAppClipの間データ共有、UserDefault（AppClipでkeychainに保存したデータは本アプリでアクセスできない）
- SKOverlay使ってAppClipの中で本アプリ推薦
- Notification可能
- Test、AppClipの機能は本アプリ含まれてるので、主にAppClipの起動をテストする：
  1. Xcodeの環境変数_XCAppClipURL
  2. LocalExperience配置し、QRコードやNFCをスキャン
  3. [TestFlight](https://help.apple.com/app-store-connect/#/devbc57e2ec6)
- 配布：AppStoreへアップロードの際、本アプリとAppClipは一緒。EnterpriseアカはAppClip配布できない
