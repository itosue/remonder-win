Param(
    [switch]${s}
    )

# Path to cloud strage directory
$GDDir = "C:\Users\" + ${user} + "\Google Drive"

# base directory
$baseDir = ${GDDir} + "\remonder"

# directory where to put .blned file
$inDir = ${baseDir} + "\01_que"

$workDir = ${baseDir} + "\02_work"

$outDir = ${baseDir} + "\03_output"


# By default, error output is supressed. Change option to Continue if you need debug.
$ErrorActionPreference = "SilentlyContinue"
#$ErrorActionPreference = "Continue"

# default colors for GIF animation.
$defcolornum = 256

# target file size for GIF animation. (default is for twitter)
$fileSizeLimit = 3145728

# other default value
$answer = "y"
$twgif = "y"


# main routine
if(${s}){
	$colornum = ${defcolornum}
	echo ("Silent option is detected. Execute with settings below.")
	echo ("Base cloud storage directory is" + ${GDDir})
	echo ("Create GIF animation too? y/n?=" + ${twgif} + " colors=" + ${colornum})

}else{
	$answer = read-host Base directori is [${baseDir}]. OK?[y/n]

	if(${answer} -match "y|Y"){
		echo (ÅhStart processing in directory" + ${GDDir} )
		$twgif = read-host Create GIF animation too? (need to install ImageMagick)[y/n]

		if(${twgif} -match "y|Y"){
			echo "Create GIF animation."
			$colornum = [int](read-host Enter number of colors. Press enter if you want process with default number $defcolornum)

			if(${colornum} -match "\d."){
				echo ("Create GIF animation with "+${colornum}+" colors")
				${colornum}.GetType().FullName
				$defcolornum = ${colornum}
			}else{
				echo ('Create with (' + ${defcolornum} + ')colors')
							$colornum = ${defcolornum}
			}
		}else{
			echo "Won't create GIF animation."
			$twgif = "n"
		}

	echo ""

	}elseif(${answer} -match "n|N"){
		echo "Please specify your desired cloud storage directory."
		exit
	}else{
		echo "Please enter y/n stop application."
		exit
	}
}

if(Test-Path ${baseDir}){
	echo "Base directory is already existing. Skip creating directory."
}else{
	echo "Create base directory."
	mkdir ${baseDir}
}

if(Test-Path ${inDir}){
	echo "Que directory is already existing. Skipping."
}else{
	echo ""
	echo "Create que directory."
	mkdir ${inDir}
}

if(Test-Path ${workDir}){
	echo "Work directory is already existing. Skipping."
}else{
	echo ""
	echo "Create work directory."
	mkdir ${workDir}
}

if(Test-Path ${outDir}){
	echo "Output directory is already existing. Skipping."
}else{
	echo ""
	echo "Create output directory."
	mkdir ${outDir}
}

echo "Directorys has been created."

echo ""
echo "Waiting for .blend file is placed in que directory..."
echo "Press Ctrl+C to stop waiting."

while(1){

	${renderFile} = Get-ChildItem ${inDir}\*.blend -Name  | Sort-Object LastWriteTime | Select-Object -First 1
	if(Test-Path ${inDir}\*.blend){
		mv ${inDir}\${renderFile} ${workDir}
		if($?){
			$projName = (Get-ChildItem ${workDir}\${renderFile}).BaseName
			$datetime = Get-Date -F "yyMMddHHmmss"
			echo (".blend file is detected. Start rendering. " + ${renderFile})
			& ${blCMD} -b ${workDir}\${renderFile} -o ${outDir}\${projName}-${datetime}\${projName}_ -F PNG -a
			if($?){
				echo ""
				echo "Render finished!"
				mv ${workDir}\${renderFile} ${outDir}\${projName}-${datetime}

				# Creating GIF animation part
				if(${twgif} -match "y|Y"){
					echo ""
					echo "Creating GIF animation..."
					magick -dispose none -delay 2 -loop 0 ${outDir}\${projName}-${datetime}\*.png -alpha Set -depth 8 -layers optimizeplus  -colors ${colornum} ${outDir}\${projName}-${datetime}\${projName}.gif
					if($?){
						$gifSize = $(Get-ChildItem "${outDir}\${projName}-${datetime}\${projName}.gif").Length
						while(${gifSize} -gt ${fileSizeLimit}){
							$colornum = [math]::floor(${colornum} * ${fileSizeLimit} / ${gifSize})
							echo ("File size exceeded.. " + ${gifSize} + "/" + ${fileSizeLimit} + " Try again with " + ${colornum} + " colors.")
							magick -dispose none -delay 2 -loop 0 ${outDir}\${projName}-${datetime}\*.png -alpha Set -depth 8 -layers optimizeplus  -colors ${colornum} ${outDir}\${projName}-${datetime}\${projName}.gif
							$gifSize = $(Get-ChildItem "${outDir}\${projName}-${datetime}\${projName}.gif").Length
						}
						echo ("Creating GIF animation finished! " + ${gifSize} + "/" + ${fileSizeLimit} + " " + ${colornum} + "colors")
					}else{
						echo "Some error has occurred during creating GIF animation. Stop application."
						exit 1
					}
				}

				$colornum = ${defcolornum}
				echo ""
				echo "Waiting for next file..."
				echo "Press Ctrl+C to stop waiting."
			}else{
				echo "Some error has occurred during rendering. Stop application."
				exit 1
			}
		}
	}else{
		sleep 3
	}
}
