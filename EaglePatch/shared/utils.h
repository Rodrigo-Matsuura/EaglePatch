#pragma once

#include <windows.h>
#include <stdint.h>
#include <xinput.h>

void LimitFramerate(int targetFps);

template<typename TPad> inline void CheckXInputReconnect(TPad* pad)
{
	if (!pad)
		return;

	static DWORD lastCheckTime = 0;
	DWORD now = GetTickCount();
	if (now - lastCheckTime < 250)
		return;
	lastCheckTime = now;

	typedef DWORD(WINAPI * pfnXInputGetState)(DWORD dwUserIndex, XINPUT_STATE * pState);
	typedef DWORD(WINAPI * pfnXInputGetCapabilities)(DWORD dwUserIndex, DWORD dwFlags, XINPUT_CAPABILITIES * pCapabilities);
	static pfnXInputGetState pGetState = nullptr;
	static pfnXInputGetCapabilities pGetCaps = nullptr;
	static bool attempted = false;

	if (!attempted)
	{
		attempted = true;
		HMODULE hXInput = GetModuleHandleA("xinput1_3.dll");
		if (!hXInput)
			hXInput = GetModuleHandleA("xinput1_4.dll");
		if (!hXInput)
			hXInput = GetModuleHandleA("xinput9_1_0.dll");
		if (!hXInput)
			hXInput = LoadLibraryA("xinput1_3.dll");
		if (!hXInput)
			hXInput = LoadLibraryA("xinput1_4.dll");
		if (!hXInput)
			hXInput = LoadLibraryA("xinput9_1_0.dll");

		if (hXInput)
		{
			pGetState = (pfnXInputGetState)GetProcAddress(hXInput, "XInputGetState");
			pGetCaps = (pfnXInputGetCapabilities)GetProcAddress(hXInput, "XInputGetCapabilities");
		}
	}

	if (!pGetState)
		return;

	XINPUT_STATE state;

	// 1. If currently connected, check if current slot is still connected
	if (pad->m_PadState.Connected)
	{
		if (pGetState(pad->m_PadIndex, &state) == ERROR_SUCCESS)
		{
			return;
		}
		// Connection lost on current slot
		pad->m_PadState.Connected = false;
		pad->m_PadState.Removed = true;
		pad->m_PadState.Inserted = false;
	}

	// 2. Not connected or connection lost: scan all 4 XInput slots (0 to 3) for any active controller
	for (DWORD i = 0; i < 4; i++)
	{
		if (pGetState(i, &state) == ERROR_SUCCESS)
		{
			pad->m_PadIndex = i;
			pad->m_PadState.Connected = true;
			pad->m_PadState.Inserted = true;
			pad->m_PadState.Removed = false;
			if (pGetCaps)
			{
				pGetCaps(i, 1 /* XINPUT_FLAG_GAMEPAD */, &pad->m_PadState.Caps);
			}
			return;
		}
	}
}

void ApplyCpuCoreLimit();
