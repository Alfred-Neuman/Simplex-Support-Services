#include "script_component.hpp"
#define ORDER "HOLD"

params [
	"_group",
	"_wpPos",
	"_attachedObject",
	["_behaviors",[]]
];

private _entity = _group getVariable [QPVAR(entity),objNull];
private _vehicle = _entity getVariable [QPVAR(vehicle),objNull];

if (!alive _vehicle) exitWith {true};

[FUNC(waypointUpdate),[[_group,currentWaypoint _group],_entity,_vehicle,_behaviors,ORDER,_wpPos]] call CBA_fnc_directCall;

private _moveTick = 0;

_vehicle setVariable [QGVAR(endHold),nil,true];
_vehicle setVariable [QGVAR(hold),nil,true];

waitUntil {
	if (CBA_missionTime > _moveTick) then {
		_moveTick = CBA_missionTime + 3;
		_vehicle doMove _wpPos;
	};

	sleep 0.2;

	if (unitReady _vehicle && isNil {_vehicle getVariable QGVAR(hold)}) then {
		_vehicle setVariable [QGVAR(hold),LSTRING(stopHolding),true];
		NOTIFY(_entity,LSTRING(notifyHolding));
	};

	_vehicle getVariable [QGVAR(endHold),false]
};

_vehicle setVariable [QGVAR(endHold),nil,true];
_vehicle setVariable [QGVAR(hold),nil,true];

true