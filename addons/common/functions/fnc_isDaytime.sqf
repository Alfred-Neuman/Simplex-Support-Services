#include "..\script_component.hpp"

private _times = date call BIS_fnc_sunriseSunsetTime;

switch true do {
	case (_times isEqualTo [0,-1]) : {true};
	case (_times isEqualTo [-1,0]) : {false};
	default {dayTime > _times # 0 && dayTime < _times # 1};
};
