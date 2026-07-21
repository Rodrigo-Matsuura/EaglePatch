EaglePatch+AC2 is an ASI plugin that fixes a number of issues in Assassin's Creed II

Plugin version: 1.2

Features:
- Improved shadow map size from 1024 to 4096 (only when shadow quality is maxed out in game's settings; can be disabled in ini)
- Draw distance maxed out for buildings, peds and flags (can be disabled in ini)
- Enables UPlay bonuses - Auditore Crypt, Altair robes, extra knifes, bonus dye (can be disabled in ini)
- Added support of all XInput controllers, including PS4/PS5 controllers via standard wrappers/Steam Input (can be disabled in ini)
- Added detection of hotplugged controllers (can be disabled in ini)
- Removed support of DInput controllers (can be disabled in ini)
- Gamepad and kb/mouse controls work at the same time (read note below)
- Added ini setting for enabling PS3/PS4/PS5-like controls (swapping bumpers and triggers)
- Added ini setting to skip intro videos (without having to rename files)
- Improved thread-safety in memory patching (prevents random startup crashes)
- Full compatibility and cross-compilation support on Linux / Wine / Steam Deck (Proton)
- Added robustness for gamepad hotplugging (prevents null dereferences on disconnect)

Note: switching controls layout in game settings has no effect anymore, if you didn't use KeyboardMouse2 layout for keyboard, you need to change KeyboardLayout setting in EaglePatch+AC2.ini

Installation:
1. Download Ultimate ASI Loader: https://github.com/ThirteenAG/Ultimate-ASI-Loader/releases/download/v4.68/Ultimate-ASI-Loader.zip
2. Put dinput8.dll from Ultimate ASI Loader into your Assassin's Creed II directory
3. In your Assassin's Creed II directory create a folder named scripts
4. Put EaglePatch+AC2.asi and EaglePatch+AC2.ini into a newly created scripts folder
5. Done! You may want to check EaglePatch+AC2.ini for any settings you want to enable or disable

Supported game versions:
- Digital UPlay
- Retail Akella v1.01

This plugin is using a lightweight win32 patcher by withmorten: https://github.com/withmorten/patcher

Project maintainer (Fork):
Github: https://github.com/Rodrigo-Matsuura/
Original author: Sergeanur (https://github.com/Sergeanur)