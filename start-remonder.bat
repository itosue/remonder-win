@echo off
echo remonderを起動しています…
powershell -NoProfile -ExecutionPolicy Unrestricted .\remonder.ps1
echo 終了しました。何かボタンを押すとウィンドウを閉じます。
pause > nul
exit
