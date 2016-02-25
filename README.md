#lay

アプリケーション開発を支援する便利bot　[元ネタ](https://ja.wikipedia.org/wiki/%E8%92%BC%E3%81%8D%E6%B5%81%E6%98%9FSPT%E3%83%AC%E3%82%A4%E3%82%BA%E3%83%8A%E3%83%BC)

主にAndroid開発向け

## 特徴
一旦はAndroid開発を念頭に機能追加していく予定

- Githubを使ったリポジトリ管理
- DeployGateを使ったAPKのアップロード　※**Gradle**を使用します

## コマンド一覧
### Common
|command|description|
|---|---|
|initialize|botの設定を初期化する|
|restart|botを再起動する|
|update|botをアップデートして再起動する|

### config
|command|description|
|---|---|
|config|botの設定を表示する|
|config <:key> <:value>|設定に値をセットする|

### Repository
|command|description|
|---|---|
|repository --help|helpを表示する|
|repository refresh|repositoryを削除して再度cloneしなおす|
|repository remote list|remote先の一覧を表示する|
|repository remote add <:name> <:remotePath>|remote先を登録する|
|repository remote rm <:name>|remote先を削除する|

### DeployGate
Gradle限定

|command|description|
|---|---|
|deployGate --help|helpを表示する|
|deployGate tasks|実行可能なDeployGateタスクを表示する|
|deployGate upload -remote <:remoteName> -banch <:branch> -flavor <:buildFlavor>|DeployGateに指定したBuildFlavorでアップロードする<br/><br/>特に指定がなければremote=**origin**, branch=**configの値 or debug**, flavor=**production**<br/><br/>branchはタグの指定もできる(refs/tags/<:tag>)|

## 設定項目
|key|description|
|---|---|
|repository_remote_path|cloneする対象のリポジトリのリモートパス|
|deploygate_default_flavor|デフォルトで指定するDeployGateのBuildFlavor|
