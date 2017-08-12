# remonder
auto remote rendering script for blender (only for windows)  

You can render scene through cloud storage(it uses GoogleDrive by default) with remote windows PC. GIF animation creation option is also available.  
・You can render with your powerful desktop PC from mobile PC even at outside, cafe or couch etc...  
・You don't need server. It just use client PC you usually use.  
・Easy to use. Just save copy to the que folder. (Setup is little tricky)  
・You never bother with heat and noise from desktop PC. Work anywhere you want with power of your big PC.  
・This PowerShell script runs on most of windows PC without installing other software.  

#### Before you start...  
This is most tough part. To run PowerShell script which downloaded from internet, you need some trick to execute.  
Execute script written in below to make script executable.  
powershell -NoProfile -ExecutionPolicy Unrestricted .\remonder.ps1  
Make batch file to start script if you want.(You need to handle SmartScreen in some environment.)

It's depentds on your environment to run script so please google for more information.  
This info might help... https://blogs.msdn.microsoft.com/powershell/2007/05/05/running-scripts-downloaded-from-the-internet/


#### How to use  
　Once you run this script, it automatically creates Directory called "remonder" and other work folders. Please change base directory name if you need.  

01_que : Put .blend file here. Automatically start rendering from oldest file. Don't forget pack the textures and images.(Checking [File]->[External Data]->[Automatically Pack Into .blend] make it easy.) This script run on only windows but you can put .blend file from any other platforms(Mac,Linux,FreeBSD and so on).  
02_work : Once file is detected in que directory, .blend file is moved to this directory. Some garbage are left when you interrupt script. Please clean up manually when you want.  
03_output : The directory named with "projectname-yymmddhhmmss" will be created and PNG image sequence are saved here. Project file and GIF file are also moved here.  

By setting silent option "-s", this script runs with default values written in script file.  
ex)  
D:\\>powershell ".\remonder.ps1 -s"  
Add shortcut to start up might be convenient. The shortcut is like below.  
C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe -ExecutionPolicy RemoteSigned -File "D:\path\to\file\remonder.ps1" -s

Set start frame and end frame and save copy to que directory.　Set same frame number if you want render single frame.

#### other tips  
- By default, base directory is for GoogleDrive. You can change the directory by changing directory in the script file.  
- You can't stop script with Ctrl+C after rendering is started. Please close the window that script is runnning to kill.   
- Change file name(add sequencial number is fine) every time you save to que directory. It take long time to detect changes. (Caused by GoogleDrive??)
