# Blender���C���X�g�[������Ă���ꏊ
$blCMD = "C:\Program Files\Blender Foundation\Blender\blender.exe"

# ���O�C�����Ă��郆�[�U�[��
$user = Get-Content env:username

# GoogleDrive�Ɏg���Ă���f�B���N�g���iOneDrive���A�T�[�r�X�ɉ����ĕς��ĉ�����
$GDDir = "C:\Users\" + ${user} + "\Google �h���C�u"

# �x�[�X�ƂȂ�ꏊ
$baseDir = ${GDDir} + "\remonder"

# Blend�t�@�C����u���ꏊ
$inDir = ${baseDir} + "\01_que"

# ��ƒ��̃v���W�F�N�g�t�@�C����u���ꏊ
$workDir = ${baseDir} + "\02_work"

# �e��t�@�C�����o�͂����ꏊ
$outDir = ${baseDir} + "\03_output"


# �W���ł̓G���[�o�͂�}�����Ă��܂��B�����������������Ƃ��f�o�b�O���鎞�͂��̍��ڂ�"Continue"���A���̃I�v�V�����ɂ��Ă݂Ă��������B
$ErrorActionPreference = "SilentlyContinue"
#$ErrorActionPreference = "Continue"

# GIF�A�j���[�V����������ۂ̃f�t�H���g�̐F��
$defcolornum = 256

# GIF�A�j���[�V�������������F����ۂ̖ڕW�t�@�C���T�C�Y
$fileSizeLimit = 3145728
#$fileSizeLimit = 3145

# ���̑������l
$answer = "y"
$twgif = "y"

# �ȉ������{��
$answer = read-host ���݂̍�ƃf�B���N�g����[${baseDir}]�ł��B���̂܂܏������܂����H[y/n] #�������肵�Ď�����y��I�����鎞�́A���̍s����#��t���ăR�����g�A�E�g���ĉ������B
if(${answer} -match "y|Y"){
	echo (${GDDir} + "�ŏ������J�n���܂��B")
	$twgif = read-host Twitter�ɓ��e����p��GIF�A�j��ǉ��ō��܂����H���ʓrImageMagick�̃C���X�g�[�����K�v�ł�[y/n] #�������肵�Ď�����y��I�����鎞�́A���̍s����#��t���ăR�����g�A�E�g���ĉ������B
	if(${twgif} -match "y|Y"){
		echo "Twitter�pGIF�A�j�t�@�C�����쐬���܂��B"

		$colornum = [int](read-host �F���𐮐��Ŏw�肵�Ă��������B���f�t�H���g�̐F���ŏ������鎞�͂��̂܂�Enter)
		if(${colornum} -match "\d."){
			echo ("�F��"+${colornum}+"�ŏ������܂��B")
			${colornum}.GetType().FullName
			$defcolornum = ${colornum}
		}else{
			echo ('�f�t�H���g�̐F���i' + ${defcolornum} + '�j�ŏ������܂��B')
						$colornum = ${defcolornum}
		}
	}else{
		echo "Twitter�pGIF�A�j�t�@�C���͍쐬���܂���B"
		$twgif = "n"
	}

echo ""

}elseif(${answer} -match "n|N"){
	echo "�f�B���N�g���ݒ�����������Ă��������B�v���O�������I�����܂�"
	exit
}else{
	echo "�V�׋S����͒m��܂���B"
	echo "�v���O�������I�����܂��B"
	exit
}

if(Test-Path ${baseDir}){
	echo "base�f�B���N�g�������łɑ��݂���̂ŁA�쐬���X�L�b�v���܂��B"
}else{
	echo "base�f�B���N�g�����쐬���܂��B"
	mkdir ${baseDir}
}

if(Test-Path ${inDir}){
	echo "que�f�B���N�g�������ɑ��݂���̂ŁA�쐬���X�L�b�v���܂��B"
}else{
	echo ""
	echo "que�f�B���N�g�����쐬���܂��B"
	mkdir ${inDir}
}

if(Test-Path ${workDir}){
	echo "work�f�B���N�g�������ɑ��݂���̂ŁA�쐬���X�L�b�v���܂��B"
}else{
	echo ""
	echo "work�f�B���N�g�����쐬���܂��B"
	mkdir ${workDir}
}

if(Test-Path ${outDir}){
	echo "output�f�B���N�g�������ɑ��݂���̂ŁA�쐬���X�L�b�v���܂��B"
}else{
	echo ""
	echo "output�f�B���N�g�����쐬���܂��B"
	mkdir ${outDir}
}

echo "�f�B���N�g���̍쐬���������܂����B"

echo ""
echo ".blend�t�@�C����que�f�B���N�g���ɒu�����̂�ҋ@���Ă��܂�..."
echo "Ctrl+C�ŃX�g�b�v���܂��B"

while(1){

	${renderFile} = Get-ChildItem ${inDir}\*.blend -Name  | Sort-Object LastWriteTime | Select-Object -First 1
	if(Test-Path ${inDir}\*.blend){
		mv ${inDir}\${renderFile} ${workDir}
		if($?){
			$projName = (Get-ChildItem ${workDir}\${renderFile}).BaseName
			$datetime = Get-Date -F "yyMMddHHmmss"
			echo (".blend�t�@�C�������m���܂����B�����_�����O���J�n���܂��B " + ${renderFile})
			& ${blCMD} -b ${workDir}\${renderFile} -o ${outDir}\${projName}-${datetime}\${projName}_ -F PNG -a
			if($?){
				echo ""
				echo "�����_�����O����"
				mv ${workDir}\${renderFile} ${outDir}\${projName}-${datetime}

				# �A�j���[�V����GIF�̍쐬
				if(${twgif} -match "y|Y"){
					echo ""
					echo "GIF�A�j�t�@�C���쐬�J�n"
					magick -dispose none -delay 2 -loop 0 ${outDir}\${projName}-${datetime}\*.png -alpha Set -depth 8 -layers optimizeplus  -colors ${colornum} ${outDir}\${projName}-${datetime}\${projName}.gif
					if($?){
						$gifSize = $(Get-ChildItem "${outDir}\${projName}-${datetime}\${projName}.gif").Length
						while(${gifSize} -gt ${fileSizeLimit}){
							$colornum = [math]::floor(${colornum} * ${fileSizeLimit} / ${gifSize})
							echo ("�t�@�C���T�C�Y�I�[�o�[ " + ${gifSize} + "/" + ${fileSizeLimit} + " " + ${colornum} + "�F�Ɍ��F���܂��B")
							magick -dispose none -delay 2 -loop 0 ${outDir}\${projName}-${datetime}\*.png -alpha Set -depth 8 -layers optimizeplus  -colors ${colornum} ${outDir}\${projName}-${datetime}\${projName}.gif
							$gifSize = $(Get-ChildItem "${outDir}\${projName}-${datetime}\${projName}.gif").Length
						}
						echo ("GIF�A�j�t�@�C���쐬���� " + ${gifSize} + "/" + ${fileSizeLimit} + " " + ${colornum} + "�F")
					}else{
						echo "GIF�A�j�t�@�C���쐬���ɃG���[���������܂����B�����𒆒f���܂��B"
						exit 1
					}
				}

				$colornum = ${defcolornum}
				echo ""
				echo "���̃t�@�C����ҋ@���Ă��܂�..."
				echo "Ctrl+C�ŃX�g�b�v���܂��B"
			}else{
				echo "�����_�����O�R�}���h�ŃG���[���������܂����B�����𒆒f���܂��B"
				exit 1
			}
		}
	}else{
		sleep 3
	}
}
