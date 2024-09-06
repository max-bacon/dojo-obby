@echo off
title Lync Server

cd %~dp0/..
node "%LOCALAPPDATA%\Roblox\Lync\index.js" lync.project.json OFFLINE
pause
