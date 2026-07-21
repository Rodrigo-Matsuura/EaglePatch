EaglePatchAC1 is an ASI plugin that fixes a number of issues in Assassin's Creed: Director's Cut Edition

Plugin version: 1.2

Features:
- Unlocked multisampling on high resolutions
- Added support of all XInput controllers, including PS4/PS5 controllers via standard wrappers/Steam Input (can be disabled in ini)
- Added detection of hotplugged controllers (can be disabled in ini)
- Removed support of DInput controllers (can be disabled in ini)
- Removed telemetry (improved bypass in version 1.2)
- Gamepad and kb/mouse controls work at the same time (read note below)
- Added ini setting for enabling PS3/PS4/PS5-like controls (swapping bumpers and triggers)
- Added ini setting to skip intro videos (without having to rename files)
- Added ini setting to limit CPU cores the game can use (fixes game crashing at startup when using a CPU with a high core count)
- Improved thread-safety in memory patching (prevents random startup crashes)
- Full compatibility and cross-compilation support on Linux / Wine / Steam Deck (Proton)
- [DX10 only] Fixed doubling of resolution modes in settings

Note: switching controls layout in game settings has no effect anymore, if you didn't use KeyboardMouse2 layout for keyboard, you need to change KeyboardLayout setting in EaglePatchAC1.ini

Installation:
1. Download Ultimate ASI Loader: https://github.com/ThirteenAG/Ultimate-ASI-Loader/releases/download/v4.68/Ultimate-ASI-Loader.zip
2. Put dinput8.dll from Ultimate ASI Loader into your Assassin's Creed: Director's Cut Edition directory
3. In your Assassin's Creed: Director's Cut Edition directory create a folder named scripts
4. Put EaglePatchAC1.asi and EaglePatchAC1.ini into a newly created scripts folder
5. Done! You may want to check EaglePatchAC1.ini for any settings you want to enable or disable

Confirmed supported exes:
AssassinsCreed_Dx9.exe (GOG/Steam)
CRC32: E8936C99
MD5: 8E72C3333743780E43BC2C34BBF625F9
SHA-1: A9EA476E70F076709CCA59A802E26EC894432120

AssassinsCreed_Dx10.exe (GOG/Steam)
CRC32: 3AF8F9D0
MD5: CA87753255E2D14B1F18BB737C643792
SHA-1: 601475FD5EFA02BBAE80D1C06DFA25A0A1E7FD2F

This plugin is using a lightweight win32 patcher by withmorten: https://github.com/withmorten/patcher

Project maintainer (Fork):
Github: https://github.com/Rodrigo-Matsuura/
Original author: Sergeanur (https://github.com/Sergeanur)