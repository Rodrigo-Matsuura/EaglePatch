#pragma once

#include <windows.h>
#include <stdint.h>

void InitPrecisionTimer();

void LimitFramerate(int targetFps);

void CheckXInputReconnect(uint32_t padIndex, bool& connected, bool& inserted, bool& removed);

template<typename TPad>
inline void CheckXInputReconnect(TPad* pad)
{
	if (!pad || pad->m_PadState.Connected)
		return;

	CheckXInputReconnect(pad->m_PadIndex, pad->m_PadState.Connected, pad->m_PadState.Inserted, pad->m_PadState.Removed);
}

void ApplyCpuCoreLimit();
