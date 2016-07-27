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

# �摜���o�͂����ꏊ
$outDir = ${baseDir} + "\03_output"

# ��Ƃ����������v���W�F�N�g�t�@�C���u����
$doneDir = ${baseDir} + "\04_done"

# �W���ł̓G���[�o�͂�}�����Ă��܂��B�����������������Ƃ��f�o�b�O���鎞�͂��̍��ڂ�"Continue"���A���̃I�v�V�����ɂ��Ă݂Ă��������B
$ErrorActionPreference = "SilentlyContinue"


# �ȉ������{��
$answer = y
$answer = read-host ���݂̍�ƃf�B���N�g����[${baseDir}]�ł��B���̂܂܏������܂����H[y/n] #�������肵�Ď�����y��I�����鎞�́A���̍s����#��t���ăR�����g�A�E�g���ĉ������B
if(${answer} -match "y|Y"){
	echo (${GDDir} + "�ŏ������J�n���܂��B")
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

if(Test-Path ${doneDir}){
	echo "done�f�B���N�g�������ɑ��݂���̂ŁA�쐬���X�L�b�v���܂��B"
}else{
	echo ""
	echo "done�f�B���N�g�����쐬���܂��B"
	mkdir ${doneDir}
}
echo "�f�B���N�g���̍쐬���������܂����B"

echo ""
echo ".blend�t�@�C����que�f�B���N�g���ɒu�����̂�ҋ@���Ă��܂�..."
echo "Ctrl+C�ŃX�g�b�v���܂��B"

while(1){
	
	#Get-ChildItem $inDir | Sort-Object LastWriteTime | Select-Object -First 1
	cd ${inDir}
	${renderFile} = Get-ChildItem ${inDir}\*.blend -Name  | Sort-Object LastWriteTime | Select-Object -First 1
	mv ${renderFile} ${workDir}
	if($?){
		$projName = (Get-ChildItem ${workDir}\${renderFile}).BaseName
		$datetime = Get-Date -F "yyMMddHHmmss"
		mkdir ${outDir}\${datetime}-${projName}
		echo (".blend�t�@�C�������m���܂����B�����_�����O���J�n���܂��B " + ${renderFile})
		& $blCMD -b ${workDir}\${renderFile} -o ${outDir}\${datetime}-${projName}\${projName}_ -F PNG -a
		if($?){
			echo ""
			echo "�����_�����O����"
			echo "���̃t�@�C����ҋ@���Ă��܂�..."
			echo "Ctrl+C�ŃX�g�b�v���܂��B"
			mv ${workDir}\${renderFile} ${doneDir}
		}
	}else{
		sleep 3
	}
}

