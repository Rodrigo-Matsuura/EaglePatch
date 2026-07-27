#include "ini_reader.h"
#include <direct.h>
#include <stdlib.h>

#include <string.h>

#ifndef DLL_NAME
#define DLL_NAME "EaglePatch+"
#endif

static wchar_t ini_path[MAX_PATH];

static const wchar_t* AnsiToWideHelper(const char* ansi, wchar_t* wideBuffer, size_t wideSize)
{
	if (!ansi) return nullptr;
	MultiByteToWideChar(CP_ACP, 0, ansi, -1, wideBuffer, wideSize);
	return wideBuffer;
}

static void WideToAnsi(const wchar_t* wide, char* ansi, size_t ansiSize)
{
	if (!wide || !ansi || ansiSize == 0) return;
	WideCharToMultiByte(CP_ACP, 0, wide, -1, ansi, ansiSize, NULL, NULL);
}

UINT get_private_profile_int(LPCTSTR lpKeyName, INT nDefault)
{
	wchar_t wKeyName[128];
	wchar_t wSection[128];
	const wchar_t* pwKeyName = AnsiToWideHelper(lpKeyName, wKeyName, 128);
	const wchar_t* pwSection = AnsiToWideHelper(DLL_NAME, wSection, 128);
	return GetPrivateProfileIntW(pwSection, pwKeyName, nDefault, ini_path);
}

UINT get_private_profile_bool(LPCTSTR lpKeyName, INT nDefault)
{
	char value[16];
	get_private_profile_string(lpKeyName, nDefault ? "1" : "0", value, sizeof(value));
	if (_stricmp(value, "true") == 0 || _stricmp(value, "yes") == 0 || _stricmp(value, "on") == 0 || strcmp(value, "1") == 0)
	{
		return TRUE;
	}
	if (_stricmp(value, "false") == 0 || _stricmp(value, "no") == 0 || _stricmp(value, "off") == 0 || strcmp(value, "0") == 0)
	{
		return FALSE;
	}
	return nDefault;
}

DWORD get_private_profile_string(LPCTSTR lpKeyName, LPCTSTR lpDefault, LPTSTR lpReturnedString, DWORD nSize)
{
	if (!lpReturnedString || nSize == 0) return 0;

	wchar_t wKeyName[128];
	wchar_t wSection[128];
	wchar_t wDefault[128];

	const wchar_t* pwKeyName = AnsiToWideHelper(lpKeyName, wKeyName, 128);
	const wchar_t* pwSection = AnsiToWideHelper(DLL_NAME, wSection, 128);
	const wchar_t* pwDefault = AnsiToWideHelper(lpDefault, wDefault, 128);

	wchar_t wStackBuffer[512];
	wchar_t* wReturnedString = wStackBuffer;
	if (nSize > 512)
	{
		wReturnedString = (wchar_t*)malloc(nSize * sizeof(wchar_t));
		if (!wReturnedString) return 0;
	}

	DWORD result = GetPrivateProfileStringW(pwSection, pwKeyName, pwDefault, wReturnedString, nSize, ini_path);
	WideToAnsi(wReturnedString, lpReturnedString, nSize);

	if (wReturnedString != wStackBuffer)
	{
		free(wReturnedString);
	}
	return result;
}

FLOAT get_private_profile_float(LPCTSTR lpKeyName, LPCTSTR lpDefault)
{
	CHAR lpReturnedString[MAX_PATH];

	get_private_profile_string(lpKeyName, lpDefault, lpReturnedString, sizeof(lpReturnedString));

	return (FLOAT)atof(lpReturnedString);
}

void init_private_profile(HMODULE hModule)
{
	GetModuleFileNameW(hModule, ini_path, sizeof(ini_path) / sizeof(wchar_t));
	wchar_t* p = wcsrchr(ini_path, L'.');
	if (p)
	{
		wcscpy_s(p, (sizeof(ini_path) / sizeof(wchar_t)) - (p - ini_path), L".ini");
	}
	else
	{
		wcsncat_s(ini_path, sizeof(ini_path) / sizeof(wchar_t), L".ini", 4);
	}
}