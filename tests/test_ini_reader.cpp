#include <windows.h>
#include <stdio.h>
#include <assert.h>
#include "../EaglePatch/shared/ini_reader.h"
#include "../EaglePatch/shared/utils.h"

int main()
{
	printf("[TEST] Running EaglePatch+ Unit Tests...\n");

	// Test get_private_profile_bool parsing logic with defaults
	UINT valTrue = get_private_profile_bool("NonExistentKeyTrue", TRUE);
	assert(valTrue == TRUE);

	UINT valFalse = get_private_profile_bool("NonExistentKeyFalse", FALSE);
	assert(valFalse == FALSE);

	// Test get_private_profile_int with defaults
	UINT intVal = get_private_profile_int("NonExistentKeyInt", 60);
	assert(intVal == 60);

	// Test LimitFramerate with non-positive values (should return immediately)
	LimitFramerate(0);
	LimitFramerate(-1);

	// Test ApplyCpuCoreLimit (should complete safely)
	ApplyCpuCoreLimit();

	printf("[TEST] All Unit Tests Passed Successfully!\n");
	return 0;
}
