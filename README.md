### AppClips概要
1. ミニアプリ、小さい、本アプリの複数の機能の一つ
2. インストールせずに、使い捨て
3. 位置情報、URLリンク、QRCode、AppClip Codeをトリグルとして


### 用例
1. カフェアプリ：
   本アプリは、注文、特典、お気に入りなど
   ミニアプリは、ただ注文だけ
   カフェ近づいたら、AppClip Cardは表示される

### 利用可能の技術点：


### 注意点
+ 一つ本アプリは、一つAppClipしか作れない
+ 本アプリはAppClipで機能含む
+ 10MB超えない
+ 本アプリの中、使えるフレームワークは、使えるけど、限定あり
+ バックグラウンドアクティビティー禁止
+ 機能簡単にする（複雑な機能は本アプリに移行、アプリ内課金やBluetoothペアリングなど）


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
   ```
   #if APPCLIP
      // Code used in App Clip
   #else
      // Code used in Parent App
   #endif
   ```
