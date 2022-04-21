@echo off
SET dp0=%~dp0
SET _cmd=%dp0%node_modules\.bin\zenn
call %_cmd% %*
