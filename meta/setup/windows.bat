@echo off
color 0a
cd ..
@echo on
echo Installing dependencies...
echo This might take a few moments depending on your internet speed.
haxelib install lime 8.1.2
haxelib install openfl 9.4.0
haxelib install flixel 5.8.0
haxelib install flixel-addons 3.2.3
haxelib install flixel-tools 1.5.1
haxelib install compiletime 2.8.0
haxelib git flxanimate https://github.com/FunkinCrew/flxanimate 17e0d59fdbc2b6283a5c0e4df41f1c7f27b71c49
haxelib git funkin.vis https://github.com/FunkinCrew/funkVis d5361037efa3a02c4ab20b5bd14ca11e7d00f519
haxelib git grig.audio https://gitlab.com/haxe-grig/grig.audio.git 57f5d47f2533fd0c3dcd025a86cb86c0dfa0b6d2
echo Finished!
pause