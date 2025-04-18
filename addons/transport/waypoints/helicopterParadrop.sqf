#include "..\script_component.hpp"
#define ORDER "PARADROP"

params [
	"_group",
	"_wpPos",
	"_attachedObject",
	["_behaviors",[]],
	["_timeout",0],
	["_ejectTypes",[]],
	["_ejectionsID",""],
	["_ejectInterval",OPTION(ejectInterval)],
	["_openAltitude",150]
];

private _entity = _group getVariable [QPVAR(entity),objNull];
private _vehicle = _entity getVariable [QPVAR(vehicle),objNull];

if (!alive _vehicle) exitWith {true};

[FUNC(waypointUpdate),[[_group,currentWaypoint _group],_entity,_vehicle,_behaviors,ORDER,_wpPos]] call CBA_fnc_directCall;

private _wp = _group addWaypoint [_wpPos getPos [1000,_vehicle getDir _wpPos],0,currentWaypoint _group + 1];
_wp setWaypointType "MOVE";

_vehicle doMove _wpPos;

waitUntil {
	if (unitReady _vehicle) then {
		if (isTouchingGround _vehicle && {_vehicle distance2D _wpPos < 200}) then {
			_vehicle doMove (_vehicle getPos [200,_vehicle getDir _wpPos]);
		} else {
			_vehicle doMove _wpPos;
		};
	};

	sleep WAYPOINT_SLEEP;

	!isTouchingGround _vehicle && unitReady _vehicle && _vehicle distance2D _wpPos < 200
};

_ejectTypes params [["_allPlayers",true,[true]],["_allAI",true,[true]],["_allCargo",true,[true]]];

private _ejections = _group getVariable [_ejectionsID,[]];
_ejections append ([[],getVehicleCargo _vehicle] select _allCargo);
_ejections append (SECONDARY_CREW(_vehicle) select {(_allPlayers && isPlayer _x) || (_allAI && !isPlayer _x)});

_vehicle setVariable [QGVAR(paradropEnd),false,true];

[{
	params ["_args","_PFHID"];
	_args params ["_entity","_vehicle","_ejections","_openAltitude"];

	if (!alive _vehicle || _ejections isEqualTo []) exitWith {
		_vehicle setVariable [QGVAR(paradropEnd),true,true];
		_PFHID call CBA_fnc_removePerFrameHandler;
	};

	private _item = _ejections deleteAt 0;

	[QEGVAR(common,execute),[[_item,_vehicle,_openAltitude],{
		params ["_item","_vehicle","_openAltitude"];

		if (_item isKindOf "CAManBase") then {
			unassignVehicle _item;
			[_item] orderGetIn false;
			moveOut _item;
			_item setVelocity (velocity _vehicle vectorMultiply 0.9);
			[_item,_openAltitude] call EFUNC(common,paradropUnit);
		} else {
			objNull setVehicleCargo _item;
			
			[{
				params ["_item","_vehicle"];
				(attachedTo _item) setVelocity (velocity _vehicle vectorMultiply 0.9);
			},[_item,_vehicle]] call CBA_fnc_execNextFrame;

			//[{
			//	params ["_item","_vehicle"];
			//	[_item,getPos _item # 2] call EFUNC(common,paradropObject);
			//	_item setVelocity (velocity _vehicle vectorMultiply 0.9);
			//},[_item,_vehicle]] call CBA_fnc_execNextFrame;
		};
	}],_item] call CBA_fnc_targetEvent;
},_ejectInterval,[_entity,_vehicle,_ejections,_openAltitude]] call CBA_fnc_addPerFrameHandler;

_vehicle doMove (_vehicle getRelPos [10000,0]);

waitUntil {
	if (unitReady _vehicle) then {
		_vehicle doMove (_vehicle getRelPos [10000,0]);
	};

	sleep WAYPOINT_SLEEP;

	_vehicle getVariable [QGVAR(paradropEnd),false]
};

_group setVariable [_ejectionsID,nil,true];

deleteWaypoint _wp;

if (currentWaypoint _group >= count waypoints _group - 1) then {
	_vehicle doMove getPos _vehicle;
};

if (driver _vehicle call EFUNC(common,isRemoteControlled)) exitWith {true};

if (_timeout > 0) then {
	[_entity,ORDER,_timeout] call FUNC(notifyWaiting);
	sleep _timeout;
};

true
