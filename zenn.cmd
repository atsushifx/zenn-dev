@echo off
SET dp0=%~dp0
SET _zenn=%dp0%node_modules\.bin\zenn.cmd
call %_zenn% %*
