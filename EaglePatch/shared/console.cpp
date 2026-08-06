#include <windows.h>
#include <stdio.h>
#include "console.h"

FILE* conin = NULL;
FILE* conout = NULL;
FILE* conerr = NULL;

void init_console()
{
	AllocConsole();

	freopen_s(&conin, "conin$", "r", stdin);
	freopen_s(&conout, "conout$", "w", stdout);
	freopen_s(&conerr, "conout$", "w", stderr);
}