# remonder
auto remote rendering script for blender (only for windows)  

クラウドストレージ（デフォルトはGoogleDrive）経由でリモートにあるWindowsマシンでレンダリングするスクリプトです。  
・出先のノートPCからパワフルなデスクトップマシンなどでレンダリングできる  
・所定のフォルダにコピーをして保存するだけで、別マシンにレンダリングキューを投げられる  
・デスクトップマシンなどの熱や音を気にせず快適な場所で作業できる  

#### 実行について！  
PowerShellを利用しています。  
　実行権限の変更などが良く分からない方は、コマンドラインからremonder.ps1のある場所へ移動し、下記のコマンドを実行して起動してください。  
powershell -NoProfile -ExecutionPolicy Unrestricted .\remonder.ps1  
　当初は起動用バッチファイルを付けていましたが、SmartScreenなどの警告表示が激しいのでやめました。必要に応じてバッチファイル化するなどしてください。

PowerShellの実行権限については下記の記事などを参考にして下さい。  
Powershellを楽に実行してもらうには  http://qiita.com/tomoko523/items/df8e384d32a377381ef9


#### つかいかた！  
　実行するとデフォルトではGoogleDriveのディレクトリ直下にremonderというベースディレクトリを作り、その下に各種作業用ディレクトリを作成します。居ないと思いますが、同名のディレクトリを使ってる方は別のベースディレクトリなどに書き換えて使って下さい。  

que・・・ここに.blendファイルを置くと古いものから順にレンダリングが開始されます  
work・・・レンダリン中のファイルはこちらに移動されます。中断などするとゴミがたまります。特に動作に影響はないと思いますが、気になる方は掃除して下さい。  
output・・・このディレクトリの下にyymmddhhmmss-
プロジェクト名のルールでディレクトリが作成され、その中にPNGの連番ファイルが出力されます。  
done・・・処理が無事に完了したファイルはこちらへ移動されます。

　作業しているBlenderのプロジェクトのアニメーションの範囲を指定し、コピーを保存機能などを使って上記queディレクトリへファイルを置きます。静止画をレンダリングしたい時は開始と終了フレームを同一にしてください。（全てアニメーションとして処理しているので、1フレームのアニメーションを処理させるイメージです。）

#### そのほか！  
・ベースディレクトリはデフォルトでGoogleDriveの標準ディレクトリ直下になっていますが、スクリプト内のディレクトリを変更することで、OneDriveなどでも利用可能です。  
・GoogleDriveのレンダリングを中断した時など、queディレクトリへ再度プロジェクトファイルを戻す時、読み込んでくれなかったりエラーが出たりする場合があります。（GoogleDriveのキャッシュの問題？）暫く待つか、ファイル名を変更すると処理が始まります。同様に、コピーして保存でキューディレクトリに放り込む時もファイル名にテイク数などを付けると認識しやすいです。
