#pragma once

#include "./def.h"

#ifdef EDITDISTANCE_EXPORTS
#define EDITDISTANCE_API __declspec(dllexport)
#else
#define EDITDISTANCE_API __declspec(dllimport)
#endif


extern "C" {
	EDITDISTANCE_API unsigned int edit_distance(const int64_t* a, const unsigned int asize, const int64_t* b, const unsigned int bsize);
	EDITDISTANCE_API bool edit_distance_criterion(const int64_t* a, const unsigned int asize, const int64_t* b, const unsigned int bsize, const unsigned int thr);
	EDITDISTANCE_API unsigned int edit_distance_dp(int64_t const* str1, size_t const size1, int64_t const* str2, size_t const size2);
}
