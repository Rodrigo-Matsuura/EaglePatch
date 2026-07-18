#include "ini_reader.h"
#include <direct.h>
#include <stdlib.h>

#include <string.h>

#ifndef DLL_NAME
#define DLL_NAME "EaglePatch"
#endif

static char ini_path[MAX_PATH];

UINT get_private_profile_int(LPCTSTR lpKeyName, INT nDefault)
{
	return GetPrivateProfileInt(DLL_NAME, lpKeyName, nDefault, ini_path);
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
	return GetPrivateProfileString(DLL_NAME, lpKeyName, lpDefault, lpReturnedString, nSize, ini_path);
}

FLOAT get_private_profile_float(LPCTSTR lpKeyName, LPCTSTR lpDefault)
{
	CHAR lpReturnedString[MAX_PATH];

	get_private_profile_string(lpKeyName, lpDefault, lpReturnedString, sizeof(lpReturnedString));

	return (FLOAT)atof(lpReturnedString);
}

void init_private_profile(HMODULE hModule)
{
	GetModuleFileName(hModule, ini_path, sizeof(ini_path));
	char* p = strrchr(ini_path, '.');
	if (p)
	{
		strcpy_s(p, sizeof(ini_path) - (p - ini_path), ".ini");
	}
	else
	{
		strncat_s(ini_path, sizeof(ini_path), ".ini", 4);
	}
}