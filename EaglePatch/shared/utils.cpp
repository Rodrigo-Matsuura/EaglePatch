#include "utils.h"
#include <xinput.h>

void InitPrecisionTimer()
{
	static bool initialized = false;
	if (!initialized)
	{
		initialized = true;
		HMODULE hWinmm = LoadLibraryA("winmm.dll");
		if (hWinmm)
		{
			typedef UINT(WINAPI * pfnTimeBeginPeriod)(UINT uPeriod);
			auto pTimeBeginPeriod = (pfnTimeBeginPeriod)GetProcAddress(hWinmm, "timeBeginPeriod");
			if (pTimeBeginPeriod)
			{
				pTimeBeginPeriod(1);
			}
		}
	}
}

void LimitFramerate(int targetFps)
{
	if (targetFps <= 0)
		return;

	InitPrecisionTimer();

	static LARGE_INTEGER frequency = {};
	static LARGE_INTEGER lastTime = {};

	if (frequency.QuadPart == 0)
	{
		QueryPerformanceFrequency(&frequency);
		QueryPerformanceCounter(&lastTime);
		return;
	}

	double targetFrameTime = 1.0 / (double)targetFps;
	LARGE_INTEGER currentTime;
	QueryPerformanceCounter(&currentTime);

	double elapsedTime = (double)(currentTime.QuadPart - lastTime.QuadPart) / (double)frequency.QuadPart;

	while (elapsedTime < targetFrameTime)
	{
		double remaining = targetFrameTime - elapsedTime;
		if (remaining > 0.003)
		{
			Sleep(1);
		}
		else
		{
			YieldProcessor();
		}
		QueryPerformanceCounter(&currentTime);
		elapsedTime = (double)(currentTime.QuadPart - lastTime.QuadPart) / (double)frequency.QuadPart;
	}

	lastTime = currentTime;
}

void ApplyCpuCoreLimit()
{
	DWORD_PTR processAffinityMask, systemAffinityMask;
	if (GetProcessAffinityMask(GetCurrentProcess(), &processAffinityMask, &systemAffinityMask))
	{
		// Limit to the first 4 active cores available in the system affinity mask
		DWORD_PTR newMask = 0;
		size_t coresSelected = 0;
		for (size_t i = 0; i < sizeof(DWORD_PTR) * 8 && coresSelected < 4; i++)
		{
			if (systemAffinityMask & ((DWORD_PTR)1 << i))
			{
				newMask |= ((DWORD_PTR)1 << i);
				coresSelected++;
			}
		}
		if (newMask != 0)
		{
			SetProcessAffinityMask(GetCurrentProcess(), newMask);
		}
	}
}
