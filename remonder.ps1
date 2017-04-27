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

# 各種ファイルが出力される場所
$outDir = ${baseDir} + "\03_output"


# 標準ではエラー出力を抑制しています。挙動がおかしい時とかデバッグする時はこの項目を"Continue"等、他のオプションにしてみてください。
$ErrorActionPreference = "SilentlyContinue"
#$ErrorActionPreference = "Continue"

# GIFアニメーション化する際のデフォルトの色数
$defcolornum = 256

# GIFアニメーションを自動減色する際の目標ファイルサイズ
$fileSizeLimit = 3145728
#$fileSizeLimit = 3145

# その他初期値
$answer = "y"
$twgif = "y"

Param(
    [string]${silent}  # サイレント処理　y/n
    )

# 以下処理本体
if(${silent} -match "y|Y"){
	$colornum = ${defcolornum}
	echo (サイレントオプションが指定されました。全てデフォルトの値で処理します。)
	echo (${GDDir} + "で処理を開始します。")
	echo ("Twitter用GIFアニファイル出力 y/n?=" + ${twgif} + " 色数=" + ${colornum})

}else
	$answer = read-host 現在の作業ディレクトリは[${baseDir}]です。そのまま処理しますか？[y/n] #環境が安定して自動でyを選択する時は、この行頭に#を付けてコメントアウトして下さい。

	if(${answer} -match "y|Y"){
		echo (${GDDir} + "で処理を開始します。")
		$twgif = read-host Twitterに投稿する用のGIFアニを追加で作りますか？※別途ImageMagickのインストールが必要です[y/n] #環境が安定して自動でyを選択する時は、この行頭に#を付けてコメントアウトして下さい。

		if(${twgif} -match "y|Y"){
			echo "Twitter用GIFアニファイルを作成します。"
			$colornum = [int](read-host 色数を整数で指定してください。※デフォルトの色数で処理する時はそのままEnter)

			if(${colornum} -match "\d."){
				echo ("色数"+${colornum}+"で処理します。")
				${colornum}.GetType().FullName
				$defcolornum = ${colornum}
			}else{
				echo ('デフォルトの色数（' + ${defcolornum} + '）で処理します。')
							$colornum = ${defcolornum}
			}
		}else{
			echo "Twitter用GIFアニファイルは作成しません。"
			$twgif = "n"
		}

	echo ""

	}elseif(${answer} -match "n|N"){
		echo "ディレクトリ設定を書き換えてください。プログラムを終了します"
		exit
	}else{
		echo "天邪鬼さんは知りません。"
		echo "プログラムを終了します。"
		exit
	}
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

echo "ディレクトリの作成が完了しました。"

echo ""
echo ".blendファイルがqueディレクトリに置かれるのを待機しています..."
echo "Ctrl+Cでストップします。"

while(1){

	${renderFile} = Get-ChildItem ${inDir}\*.blend -Name  | Sort-Object LastWriteTime | Select-Object -First 1
	if(Test-Path ${inDir}\*.blend){
		mv ${inDir}\${renderFile} ${workDir}
		if($?){
			$projName = (Get-ChildItem ${workDir}\${renderFile}).BaseName
			$datetime = Get-Date -F "yyMMddHHmmss"
			echo (".blendファイルを検知しました。レンダリングを開始します。 " + ${renderFile})
			& ${blCMD} -b ${workDir}\${renderFile} -o ${outDir}\${projName}-${datetime}\${projName}_ -F PNG -a
			if($?){
				echo ""
				echo "レンダリング完了"
				mv ${workDir}\${renderFile} ${outDir}\${projName}-${datetime}

				# アニメーションGIFの作成
				if(${twgif} -match "y|Y"){
					echo ""
					echo "GIFアニファイル作成開始"
					magick -dispose none -delay 2 -loop 0 ${outDir}\${projName}-${datetime}\*.png -alpha Set -depth 8 -layers optimizeplus  -colors ${colornum} ${outDir}\${projName}-${datetime}\${projName}.gif
					if($?){
						$gifSize = $(Get-ChildItem "${outDir}\${projName}-${datetime}\${projName}.gif").Length
						while(${gifSize} -gt ${fileSizeLimit}){
							$colornum = [math]::floor(${colornum} * ${fileSizeLimit} / ${gifSize})
							echo ("ファイルサイズオーバー " + ${gifSize} + "/" + ${fileSizeLimit} + " " + ${colornum} + "色に減色します。")
							magick -dispose none -delay 2 -loop 0 ${outDir}\${projName}-${datetime}\*.png -alpha Set -depth 8 -layers optimizeplus  -colors ${colornum} ${outDir}\${projName}-${datetime}\${projName}.gif
							$gifSize = $(Get-ChildItem "${outDir}\${projName}-${datetime}\${projName}.gif").Length
						}
						echo ("GIFアニファイル作成完了 " + ${gifSize} + "/" + ${fileSizeLimit} + " " + ${colornum} + "色")
					}else{
						echo "GIFアニファイル作成中にエラーが発生しました。処理を中断します。"
						exit 1
					}
				}

				$colornum = ${defcolornum}
				echo ""
				echo "次のファイルを待機しています..."
				echo "Ctrl+Cでストップします。"
			}else{
				echo "レンダリングコマンドでエラーが発生しました。処理を中断します。"
				exit 1
			}
		}
	}else{
		sleep 3
	}
}
