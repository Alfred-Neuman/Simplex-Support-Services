#define COMPONENT CDS
#include "\z\SSS\addons\main\script_mod.hpp"

// #define DEBUG_MODE_FULL
// #define DISABLE_COMPILE_CACHE

#ifdef DEBUG_ENABLED_CDS
	#define DEBUG_MODE_FULL
#endif
	#ifdef DEBUG_SETTINGS_CDS
	#define DEBUG_SETTINGS DEBUG_SETTINGS_CDS
#endif

#include "\z\SSS\addons\main\script_macros.hpp"

#define SPACING 0.005
#define BUFFER 0.01
#define SCROLLBAR_BUFFER 0.024
#define MIN_HEIGHT 0.05
#define MAX_HEIGHT 0.7
#define POS_X 0.15
#define CONTENT_WIDTH 0.8
#define ITEM_HEIGHT 0.05
#define DESCRIPTION_WIDTH 0.3
#define TITLE_HEIGHT 0.04
#define BUTTON_WIDTH 0.2
#define BUTTON_HEIGHT 0.045

#define CONTROL_X (DESCRIPTION_WIDTH + SPACING)
#define CONTROL_WIDTH (CONTENT_WIDTH - DESCRIPTION_WIDTH - SPACING - SCROLLBAR_BUFFER)

#define CHECKBOX_WIDTH 0.04
#define CHECKBOX_HEIGHT ITEM_HEIGHT
#define EDITBOX_WIDTH CONTROL_WIDTH
#define EDITBOX_HEIGHT ITEM_HEIGHT
#define SLIDER_EDIT_WIDTH 0.1
#define SLIDER_WIDTH (CONTROL_WIDTH - SPACING - SLIDER_EDIT_WIDTH)
#define SLIDER_HEIGHT ITEM_HEIGHT
#define COMBOBOX_WIDTH CONTROL_WIDTH
#define COMBOBOX_HEIGHT ITEM_HEIGHT
#define LISTNBOX_WIDTH (DESCRIPTION_WIDTH + SPACING + CONTROL_WIDTH)
#define LISTNBOX_HEIGHT ITEM_HEIGHT

#define GUI_GRID_WAbs ((safezoneW / safezoneH) min 1.2)
#define GUI_GRID_HAbs (GUI_GRID_WAbs / 1.2)
#define GUI_GRID_W (GUI_GRID_WAbs / 40)
#define GUI_GRID_H (GUI_GRID_HAbs / 25)
#define GUI_GRID_X (safezoneX)
#define GUI_GRID_Y (safezoneY + safezoneH - GUI_GRID_HAbs)
#define COLOR_DISABLED 1,1,1,0.35
