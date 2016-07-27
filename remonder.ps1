# Blenderがインストールされている場所
$blCMD = "C:\Program Files\Blender Foundation\Blender\blender.exe"

# ログインしているユーザー名
$user = Get-Content env:username

# GoogleDriveに使われているディレクトリ（OneDrive等、サービスに応じて変えて下さい
$GDDir = "C:\Users\" + ${user} + "\Google ドライブ"

# ベースとなる場所
$baseDir = ${GDDir} + "\remonder"

# Blendファイルを置く場所
$inDir = ${baseDir} + "\01_que"

# 作業中のプロジェクトファイルを置く場所
$workDir = ${baseDir} + "\02_work"

# 画像が出力される場所
$outDir = ${baseDir} + "\03_output"

# 作業が完了したプロジェクトファイル置き場
$doneDir = ${baseDir} + "\04_done"

# 標準ではエラー出力を抑制しています。挙動がおかしい時とかデバッグする時はこの項目を"Continue"等、他のオプションにしてみてください。
$ErrorActionPreference = "SilentlyContinue"


# 以下処理本体
$answer = y
$answer = read-host 現在の作業ディレクトリは[${baseDir}]です。そのまま処理しますか？[y/n] #環境が安定して自動でyを選択する時は、この行頭に#を付けてコメントアウトして下さい。
if(${answer} -match "y|Y"){
	echo (${GDDir} + "で処理を開始します。")
}elseif(${answer} -match "n|N"){
	echo "ディレクトリ設定を書き換えてください。プログラムを終了します"
	exit
}else{
	echo "天邪鬼さんは知りません。"
	echo "プログラムを終了します。"
	exit
}

if(Test-Path ${baseDir}){
	echo "baseディレクトリがすでに存在するので、作成をスキップします。"
}else{
	echo "baseディレクトリを作成します。"
	mkdir ${baseDir}
}

if(Test-Path ${inDir}){
	echo "queディレクトリが既に存在するので、作成をスキップします。"
}else{
	echo ""
	echo "queディレクトリを作成します。"
	mkdir ${inDir}
}

if(Test-Path ${workDir}){
	echo "workディレクトリが既に存在するので、作成をスキップします。"
}else{
	echo ""
	echo "workディレクトリを作成します。"
	mkdir ${workDir}
}

if(Test-Path ${outDir}){
	echo "outputディレクトリが既に存在するので、作成をスキップします。"
}else{
	echo ""
	echo "outputディレクトリを作成します。"
	mkdir ${outDir}
}

if(Test-Path ${doneDir}){
	echo "doneディレクトリが既に存在するので、作成をスキップします。"
}else{
	echo ""
	echo "doneディレクトリを作成します。"
	mkdir ${doneDir}
}
echo "ディレクトリの作成が完了しました。"

echo ""
echo ".blendファイルがqueディレクトリに置かれるのを待機しています..."
echo "Ctrl+Cでストップします。"

while(1){
	
	#Get-ChildItem $inDir | Sort-Object LastWriteTime | Select-Object -First 1
	cd ${inDir}
	${renderFile} = Get-ChildItem ${inDir}\*.blend -Name  | Sort-Object LastWriteTime | Select-Object -First 1
	mv ${renderFile} ${workDir}
	if($?){
		$projName = (Get-ChildItem ${workDir}\${renderFile}).BaseName
		$datetime = Get-Date -F "yyMMddHHmmss"
		mkdir ${outDir}\${datetime}-${projName}
		echo (".blendファイルを検知しました。レンダリングを開始します。 " + ${renderFile})
		& $blCMD -b ${workDir}\${renderFile} -o ${outDir}\${datetime}-${projName}\${projName}_ -F PNG -a
		if($?){
			echo ""
			echo "レンダリング完了"
			echo "次のファイルを待機しています..."
			echo "Ctrl+Cでストップします。"
			mv ${workDir}\${renderFile} ${doneDir}
		}
	}else{
		sleep 3
	}
}

