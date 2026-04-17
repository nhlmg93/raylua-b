---@meta

local ffi = require("ffi")

---@class Clay_String
---@field isStaticallyAllocated boolean
---@field length integer
---@field chars string

---@class Clay_StringSlice
---@field length integer
---@field chars string
---@field baseChars string

---@class Clay_Arena
---@field nextAllocation integer
---@field capacity integer
---@field memory ffi.cdata*

---@class Clay_Dimensions
---@field width number
---@field height number

---@class Clay_Vector2
---@field x number
---@field y number

---@class Clay_Color
---@field r number
---@field g number
---@field b number
---@field a number

---@class Clay_BoundingBox
---@field x number
---@field y number
---@field width number
---@field height number

---@class Clay_ElementId
---@field id integer
---@field offset integer
---@field baseId integer
---@field stringId Clay_String

---@class Clay_ElementIdArray
---@field capacity integer
---@field length integer
---@field internalArray ffi.cdata*

---@class Clay_CornerRadius
---@field topLeft number
---@field topRight number
---@field bottomLeft number
---@field bottomRight number

---@alias Clay_LayoutDirectionEnum
---| 0 # LEFT_TO_RIGHT
---| 1 # TOP_TO_BOTTOM

---@alias Clay_LayoutAlignmentXEnum
---| 0 # LEFT
---| 1 # RIGHT
---| 2 # CENTER

---@alias Clay_LayoutAlignmentYEnum
---| 0 # TOP
---| 1 # BOTTOM
---| 2 # CENTER

---@alias Clay_SizingTypeEnum
---| 0 # FIT
---| 1 # GROW
---| 2 # PERCENT
---| 3 # FIXED

---@alias Clay_TextWrapEnum
---| 0 # WORDS
---| 1 # NEWLINES
---| 2 # NONE

---@alias Clay_TextAlignEnum
---| 0 # LEFT
---| 1 # CENTER
---| 2 # RIGHT

---@alias Clay_FloatingAttachPointEnum
---| 0 # LEFT_TOP
---| 1 # LEFT_CENTER
---| 2 # LEFT_BOTTOM
---| 3 # CENTER_TOP
---| 4 # CENTER_CENTER
---| 5 # CENTER_BOTTOM
---| 6 # RIGHT_TOP
---| 7 # RIGHT_CENTER
---| 8 # RIGHT_BOTTOM

---@alias Clay_PointerCaptureModeEnum
---| 0 # CAPTURE
---| 1 # PASSTHROUGH

---@alias Clay_FloatingAttachToEnum
---| 0 # NONE
---| 1 # PARENT
---| 2 # ELEMENT_WITH_ID
---| 3 # ROOT

---@alias Clay_FloatingClipToEnum
---| 0 # NONE
---| 1 # ATTACHED_PARENT

---@alias Clay_TransitionStateEnum
---| 0 # IDLE
---| 1 # ENTERING
---| 2 # TRANSITIONING
---| 3 # EXITING

---@alias Clay_TransitionPropertyEnum integer

---@alias Clay_TransitionEnterTriggerEnum
---| 0 # SKIP_ON_FIRST_PARENT_FRAME
---| 1 # TRIGGER_ON_FIRST_PARENT_FRAME

---@alias Clay_TransitionExitTriggerEnum
---| 0 # SKIP_WHEN_PARENT_EXITS
---| 1 # TRIGGER_WHEN_PARENT_EXITS

---@alias Clay_TransitionInteractionHandlingEnum
---| 0 # DISABLE_INTERACTIONS_WHILE_TRANSITIONING_POSITION
---| 1 # ALLOW_INTERACTIONS_WHILE_TRANSITIONING_POSITION

---@alias Clay_ExitTransitionSiblingOrderingEnum
---| 0 # UNDERNEATH_SIBLINGS
---| 1 # NATURAL_ORDER
---| 2 # ABOVE_SIBLINGS

---@alias Clay_RenderCommandTypeEnum
---| 0 # NONE
---| 1 # RECTANGLE
---| 2 # BORDER
---| 3 # TEXT
---| 4 # IMAGE
---| 5 # SCISSOR_START
---| 6 # SCISSOR_END
---| 7 # OVERLAY_COLOR_START
---| 8 # OVERLAY_COLOR_END
---| 9 # CUSTOM

---@alias Clay_PointerDataInteractionStateEnum
---| 0 # PRESSED_THIS_FRAME
---| 1 # PRESSED
---| 2 # RELEASED_THIS_FRAME
---| 3 # RELEASED

---@alias Clay_ErrorTypeEnum
---| 0 # TEXT_MEASUREMENT_FUNCTION_NOT_PROVIDED
---| 1 # ARENA_CAPACITY_EXCEEDED
---| 2 # ELEMENTS_CAPACITY_EXCEEDED
---| 3 # TEXT_MEASUREMENT_CAPACITY_EXCEEDED
---| 4 # DUPLICATE_ID
---| 5 # FLOATING_CONTAINER_PARENT_NOT_FOUND
---| 6 # PERCENTAGE_OVER_1
---| 7 # INTERNAL_ERROR
---| 8 # UNBALANCED_OPEN_CLOSE

---@class Clay_ChildAlignment
---@field x Clay_LayoutAlignmentXEnum
---@field y Clay_LayoutAlignmentYEnum

---@class Clay_SizingMinMax
---@field min number
---@field max number

---@class Clay_SizingAxis
---@field size { minMax: Clay_SizingMinMax, percent: number }
---@field type Clay_SizingTypeEnum

---@class Clay_Sizing
---@field width Clay_SizingAxis
---@field height Clay_SizingAxis

---@class Clay_Padding
---@field left integer
---@field right integer
---@field top integer
---@field bottom integer

---@class Clay_LayoutConfig
---@field sizing Clay_Sizing
---@field padding Clay_Padding
---@field childGap integer
---@field childAlignment Clay_ChildAlignment
---@field layoutDirection Clay_LayoutDirectionEnum

---@class Clay_TextElementConfig
---@field userData ffi.cdata*|lightuserdata|nil
---@field textColor Clay_Color
---@field fontId integer
---@field fontSize integer
---@field letterSpacing integer
---@field lineHeight integer
---@field wrapMode Clay_TextWrapEnum
---@field textAlignment Clay_TextAlignEnum

---@class Clay_AspectRatioElementConfig
---@field aspectRatio number

---@class Clay_ImageElementConfig
---@field imageData ffi.cdata*|lightuserdata|nil

---@class Clay_FloatingAttachPoints
---@field element Clay_FloatingAttachPointEnum
---@field parent Clay_FloatingAttachPointEnum

---@class Clay_FloatingElementConfig
---@field offset Clay_Vector2
---@field expand Clay_Dimensions
---@field parentId integer
---@field zIndex integer
---@field attachPoints Clay_FloatingAttachPoints
---@field pointerCaptureMode Clay_PointerCaptureModeEnum
---@field attachTo Clay_FloatingAttachToEnum
---@field clipTo Clay_FloatingClipToEnum

---@class Clay_CustomElementConfig
---@field customData ffi.cdata*|lightuserdata|nil

---@class Clay_ClipElementConfig
---@field horizontal boolean
---@field vertical boolean
---@field childOffset Clay_Vector2

---@class Clay_BorderWidth
---@field left integer
---@field right integer
---@field top integer
---@field bottom integer
---@field betweenChildren integer

---@class Clay_BorderElementConfig
---@field color Clay_Color
---@field width Clay_BorderWidth

---@class Clay_TransitionData
---@field boundingBox Clay_BoundingBox
---@field backgroundColor Clay_Color
---@field overlayColor Clay_Color
---@field borderColor Clay_Color
---@field borderWidth Clay_BorderWidth

---@class Clay_TransitionCallbackArguments
---@field transitionState Clay_TransitionStateEnum
---@field initial Clay_TransitionData
---@field current Clay_TransitionData
---@field target Clay_TransitionData
---@field elapsedTime number
---@field duration number
---@field properties Clay_TransitionPropertyEnum

---@class Clay_TransitionEnterConfig
---@field setInitialState ffi.cdata*|function|nil
---@field trigger Clay_TransitionEnterTriggerEnum

---@class Clay_TransitionExitConfig
---@field setFinalState ffi.cdata*|function|nil
---@field trigger Clay_TransitionExitTriggerEnum
---@field siblingOrdering Clay_ExitTransitionSiblingOrderingEnum

---@class Clay_TransitionElementConfig
---@field handler ffi.cdata*|function|nil
---@field duration number
---@field properties Clay_TransitionPropertyEnum
---@field interactionHandling Clay_TransitionInteractionHandlingEnum
---@field enter Clay_TransitionEnterConfig
---@field exit Clay_TransitionExitConfig

---@class Clay_TextRenderData
---@field stringContents Clay_StringSlice
---@field textColor Clay_Color
---@field fontId integer
---@field fontSize integer
---@field letterSpacing integer
---@field lineHeight integer

---@class Clay_RectangleRenderData
---@field backgroundColor Clay_Color
---@field cornerRadius Clay_CornerRadius

---@class Clay_ImageRenderData
---@field backgroundColor Clay_Color
---@field cornerRadius Clay_CornerRadius
---@field imageData ffi.cdata*|lightuserdata|nil

---@class Clay_CustomRenderData
---@field backgroundColor Clay_Color
---@field cornerRadius Clay_CornerRadius
---@field customData ffi.cdata*|lightuserdata|nil

---@class Clay_ClipRenderData
---@field horizontal boolean
---@field vertical boolean

---@class Clay_OverlayColorRenderData
---@field color Clay_Color

---@class Clay_BorderRenderData
---@field color Clay_Color
---@field cornerRadius Clay_CornerRadius
---@field width Clay_BorderWidth

---@class Clay_RenderData
---@field rectangle Clay_RectangleRenderData
---@field text Clay_TextRenderData
---@field image Clay_ImageRenderData
---@field custom Clay_CustomRenderData
---@field border Clay_BorderRenderData
---@field clip Clay_ClipRenderData
---@field overlayColor Clay_OverlayColorRenderData

---@class Clay_ScrollContainerData
---@field scrollPosition ffi.cdata*|nil
---@field scrollContainerDimensions Clay_Dimensions
---@field contentDimensions Clay_Dimensions
---@field config Clay_ClipElementConfig
---@field found boolean

---@class Clay_ElementData
---@field boundingBox Clay_BoundingBox
---@field found boolean

---@class Clay_RenderCommand
---@field boundingBox Clay_BoundingBox
---@field renderData Clay_RenderData
---@field userData ffi.cdata*|lightuserdata|nil
---@field id integer
---@field zIndex integer
---@field commandType Clay_RenderCommandTypeEnum

---@class Clay_RenderCommandArray
---@field capacity integer
---@field length integer
---@field internalArray ffi.cdata*

---@class Clay_PointerData
---@field position Clay_Vector2
---@field state Clay_PointerDataInteractionStateEnum

---@class Clay_ElementDeclaration
---@field layout Clay_LayoutConfig
---@field backgroundColor Clay_Color
---@field overlayColor Clay_Color
---@field cornerRadius Clay_CornerRadius
---@field aspectRatio Clay_AspectRatioElementConfig
---@field image Clay_ImageElementConfig
---@field floating Clay_FloatingElementConfig
---@field custom Clay_CustomElementConfig
---@field clip Clay_ClipElementConfig
---@field border Clay_BorderElementConfig
---@field transition Clay_TransitionElementConfig
---@field userData ffi.cdata*|lightuserdata|nil

---@class Clay_ErrorData
---@field errorType Clay_ErrorTypeEnum
---@field errorText Clay_String
---@field userData ffi.cdata*|lightuserdata|nil

---@class Clay_ErrorHandler
---@field errorHandlerFunction ffi.cdata*|function|nil
---@field userData ffi.cdata*|lightuserdata|nil

ffi.cdef([[ 
typedef struct Clay_Context Clay_Context;

typedef struct Clay_String {
    bool isStaticallyAllocated;
    int32_t length;
    const char *chars;
} Clay_String;

typedef struct Clay_StringSlice {
    int32_t length;
    const char *chars;
    const char *baseChars;
} Clay_StringSlice;

typedef struct Clay_Arena {
    uintptr_t nextAllocation;
    size_t capacity;
    char *memory;
} Clay_Arena;

typedef struct Clay_Dimensions {
    float width;
    float height;
} Clay_Dimensions;

typedef struct Clay_Vector2 {
    float x;
    float y;
} Clay_Vector2;

typedef struct Clay_Color {
    float r;
    float g;
    float b;
    float a;
} Clay_Color;

typedef struct Clay_BoundingBox {
    float x;
    float y;
    float width;
    float height;
} Clay_BoundingBox;

typedef struct Clay_ElementId {
    uint32_t id;
    uint32_t offset;
    uint32_t baseId;
    Clay_String stringId;
} Clay_ElementId;

typedef struct Clay_ElementIdArray {
    int32_t capacity;
    int32_t length;
    Clay_ElementId *internalArray;
} Clay_ElementIdArray;

typedef struct Clay_CornerRadius {
    float topLeft;
    float topRight;
    float bottomLeft;
    float bottomRight;
} Clay_CornerRadius;

typedef uint8_t Clay_LayoutDirection;
typedef uint8_t Clay_LayoutAlignmentX;
typedef uint8_t Clay_LayoutAlignmentY;
typedef uint8_t Clay__SizingType;
typedef uint8_t Clay_TextElementConfigWrapMode;
typedef uint8_t Clay_TextAlignment;
typedef uint8_t Clay_FloatingAttachPointType;
typedef uint8_t Clay_PointerCaptureMode;
typedef uint8_t Clay_FloatingAttachToElement;
typedef uint8_t Clay_FloatingClipToElement;
typedef uint8_t Clay_TransitionEnterTriggerType;
typedef uint8_t Clay_TransitionExitTriggerType;
typedef uint8_t Clay_TransitionInteractionHandlingType;
typedef uint8_t Clay_ExitTransitionSiblingOrdering;
typedef uint8_t Clay_RenderCommandType;
typedef uint8_t Clay_PointerDataInteractionState;
typedef uint8_t Clay_ErrorType;

typedef int32_t Clay_TransitionState;
typedef int32_t Clay_TransitionProperty;

typedef struct Clay_ChildAlignment {
    Clay_LayoutAlignmentX x;
    Clay_LayoutAlignmentY y;
} Clay_ChildAlignment;

typedef struct Clay_SizingMinMax {
    float min;
    float max;
} Clay_SizingMinMax;

typedef struct Clay_SizingAxis {
    union {
        Clay_SizingMinMax minMax;
        float percent;
    } size;
    Clay__SizingType type;
} Clay_SizingAxis;

typedef struct Clay_Sizing {
    Clay_SizingAxis width;
    Clay_SizingAxis height;
} Clay_Sizing;

typedef struct Clay_Padding {
    uint16_t left;
    uint16_t right;
    uint16_t top;
    uint16_t bottom;
} Clay_Padding;

typedef struct Clay_LayoutConfig {
    Clay_Sizing sizing;
    Clay_Padding padding;
    uint16_t childGap;
    Clay_ChildAlignment childAlignment;
    Clay_LayoutDirection layoutDirection;
} Clay_LayoutConfig;

typedef struct Clay_TextElementConfig {
    void *userData;
    Clay_Color textColor;
    uint16_t fontId;
    uint16_t fontSize;
    uint16_t letterSpacing;
    uint16_t lineHeight;
    Clay_TextElementConfigWrapMode wrapMode;
    Clay_TextAlignment textAlignment;
} Clay_TextElementConfig;

typedef struct Clay_AspectRatioElementConfig {
    float aspectRatio;
} Clay_AspectRatioElementConfig;

typedef struct Clay_ImageElementConfig {
    void *imageData;
} Clay_ImageElementConfig;

typedef struct Clay_FloatingAttachPoints {
    Clay_FloatingAttachPointType element;
    Clay_FloatingAttachPointType parent;
} Clay_FloatingAttachPoints;

typedef struct Clay_FloatingElementConfig {
    Clay_Vector2 offset;
    Clay_Dimensions expand;
    uint32_t parentId;
    int16_t zIndex;
    Clay_FloatingAttachPoints attachPoints;
    Clay_PointerCaptureMode pointerCaptureMode;
    Clay_FloatingAttachToElement attachTo;
    Clay_FloatingClipToElement clipTo;
} Clay_FloatingElementConfig;

typedef struct Clay_CustomElementConfig {
    void *customData;
} Clay_CustomElementConfig;

typedef struct Clay_ClipElementConfig {
    bool horizontal;
    bool vertical;
    Clay_Vector2 childOffset;
} Clay_ClipElementConfig;

typedef struct Clay_BorderWidth {
    uint16_t left;
    uint16_t right;
    uint16_t top;
    uint16_t bottom;
    uint16_t betweenChildren;
} Clay_BorderWidth;

typedef struct Clay_BorderElementConfig {
    Clay_Color color;
    Clay_BorderWidth width;
} Clay_BorderElementConfig;

typedef struct Clay_TransitionData {
    Clay_BoundingBox boundingBox;
    Clay_Color backgroundColor;
    Clay_Color overlayColor;
    Clay_Color borderColor;
    Clay_BorderWidth borderWidth;
} Clay_TransitionData;

typedef struct Clay_TransitionCallbackArguments {
    Clay_TransitionState transitionState;
    Clay_TransitionData initial;
    Clay_TransitionData *current;
    Clay_TransitionData target;
    float elapsedTime;
    float duration;
    Clay_TransitionProperty properties;
} Clay_TransitionCallbackArguments;

typedef struct Clay_TransitionEnterConfig {
    Clay_TransitionData (*setInitialState)(Clay_TransitionData targetState, Clay_TransitionProperty properties);
    Clay_TransitionEnterTriggerType trigger;
} Clay_TransitionEnterConfig;

typedef struct Clay_TransitionExitConfig {
    Clay_TransitionData (*setFinalState)(Clay_TransitionData initialState, Clay_TransitionProperty properties);
    Clay_TransitionExitTriggerType trigger;
    Clay_ExitTransitionSiblingOrdering siblingOrdering;
} Clay_TransitionExitConfig;

typedef struct Clay_TransitionElementConfig {
    bool (*handler)(Clay_TransitionCallbackArguments arguments);
    float duration;
    Clay_TransitionProperty properties;
    Clay_TransitionInteractionHandlingType interactionHandling;
    Clay_TransitionEnterConfig enter;
    Clay_TransitionExitConfig exit;
} Clay_TransitionElementConfig;

typedef struct Clay_TextRenderData {
    Clay_StringSlice stringContents;
    Clay_Color textColor;
    uint16_t fontId;
    uint16_t fontSize;
    uint16_t letterSpacing;
    uint16_t lineHeight;
} Clay_TextRenderData;

typedef struct Clay_RectangleRenderData {
    Clay_Color backgroundColor;
    Clay_CornerRadius cornerRadius;
} Clay_RectangleRenderData;

typedef struct Clay_ImageRenderData {
    Clay_Color backgroundColor;
    Clay_CornerRadius cornerRadius;
    void *imageData;
} Clay_ImageRenderData;

typedef struct Clay_CustomRenderData {
    Clay_Color backgroundColor;
    Clay_CornerRadius cornerRadius;
    void *customData;
} Clay_CustomRenderData;

typedef struct Clay_ClipRenderData {
    bool horizontal;
    bool vertical;
} Clay_ClipRenderData;

typedef struct Clay_OverlayColorRenderData {
    Clay_Color color;
} Clay_OverlayColorRenderData;

typedef struct Clay_BorderRenderData {
    Clay_Color color;
    Clay_CornerRadius cornerRadius;
    Clay_BorderWidth width;
} Clay_BorderRenderData;

typedef union Clay_RenderData {
    Clay_RectangleRenderData rectangle;
    Clay_TextRenderData text;
    Clay_ImageRenderData image;
    Clay_CustomRenderData custom;
    Clay_BorderRenderData border;
    Clay_ClipRenderData clip;
    Clay_OverlayColorRenderData overlayColor;
} Clay_RenderData;

typedef struct Clay_ScrollContainerData {
    Clay_Vector2 *scrollPosition;
    Clay_Dimensions scrollContainerDimensions;
    Clay_Dimensions contentDimensions;
    Clay_ClipElementConfig config;
    bool found;
} Clay_ScrollContainerData;

typedef struct Clay_ElementData {
    Clay_BoundingBox boundingBox;
    bool found;
} Clay_ElementData;

typedef struct Clay_RenderCommand {
    Clay_BoundingBox boundingBox;
    Clay_RenderData renderData;
    void *userData;
    uint32_t id;
    int16_t zIndex;
    Clay_RenderCommandType commandType;
} Clay_RenderCommand;

typedef struct Clay_RenderCommandArray {
    int32_t capacity;
    int32_t length;
    Clay_RenderCommand *internalArray;
} Clay_RenderCommandArray;

typedef struct Clay_PointerData {
    Clay_Vector2 position;
    Clay_PointerDataInteractionState state;
} Clay_PointerData;

typedef struct Clay_ElementDeclaration {
    Clay_LayoutConfig layout;
    Clay_Color backgroundColor;
    Clay_Color overlayColor;
    Clay_CornerRadius cornerRadius;
    Clay_AspectRatioElementConfig aspectRatio;
    Clay_ImageElementConfig image;
    Clay_FloatingElementConfig floating;
    Clay_CustomElementConfig custom;
    Clay_ClipElementConfig clip;
    Clay_BorderElementConfig border;
    Clay_TransitionElementConfig transition;
    void *userData;
} Clay_ElementDeclaration;

typedef struct Clay_ErrorData {
    Clay_ErrorType errorType;
    Clay_String errorText;
    void *userData;
} Clay_ErrorData;

typedef struct Clay_ErrorHandler {
    void (*errorHandlerFunction)(Clay_ErrorData errorText);
    void *userData;
} Clay_ErrorHandler;

uint32_t Clay_MinMemorySize(void);
Clay_Arena Clay_CreateArenaWithCapacityAndMemory(size_t capacity, void *memory);
void Clay_SetPointerState(Clay_Vector2 position, bool pointerDown);
Clay_PointerData Clay_GetPointerState(void);
Clay_Context *Clay_Initialize(Clay_Arena arena, Clay_Dimensions layoutDimensions, Clay_ErrorHandler errorHandler);
Clay_Context *Clay_GetCurrentContext(void);
void Clay_SetCurrentContext(Clay_Context *context);
void Clay_UpdateScrollContainers(bool enableDragScrolling, Clay_Vector2 scrollDelta, float deltaTime);
Clay_Vector2 Clay_GetScrollOffset(void);
void Clay_SetLayoutDimensions(Clay_Dimensions dimensions);
void Clay_BeginLayout(void);
Clay_RenderCommandArray Clay_EndLayout(float deltaTime);
uint32_t Clay_GetOpenElementId(void);
Clay_ElementId Clay_GetElementId(Clay_String idString);
Clay_ElementId Clay_GetElementIdWithIndex(Clay_String idString, uint32_t index);
Clay_ElementData Clay_GetElementData(Clay_ElementId id);
bool Clay_Hovered(void);
void Clay_OnHover(void (*onHoverFunction)(Clay_ElementId elementId, Clay_PointerData pointerData, void *userData), void *userData);
bool Clay_PointerOver(Clay_ElementId elementId);
Clay_ElementIdArray Clay_GetPointerOverIds(void);
Clay_ScrollContainerData Clay_GetScrollContainerData(Clay_ElementId id);
void Clay_SetMeasureTextFunction(Clay_Dimensions (*measureTextFunction)(Clay_StringSlice text, Clay_TextElementConfig *config, void *userData), void *userData);
void Clay_SetQueryScrollOffsetFunction(Clay_Vector2 (*queryScrollOffsetFunction)(uint32_t elementId, void *userData), void *userData);
Clay_RenderCommand *Clay_RenderCommandArray_Get(Clay_RenderCommandArray *array, int32_t index);
void Clay_SetDebugModeEnabled(bool enabled);
bool Clay_IsDebugModeEnabled(void);
void Clay_SetCullingEnabled(bool enabled);
int32_t Clay_GetMaxElementCount(void);
void Clay_SetMaxElementCount(int32_t maxElementCount);
int32_t Clay_GetMaxMeasureTextCacheWordCount(void);
void Clay_SetMaxMeasureTextCacheWordCount(int32_t maxMeasureTextCacheWordCount);
void Clay_ResetMeasureTextCache(void);
bool Clay_EaseOut(Clay_TransitionCallbackArguments arguments);

void Clay__OpenElement(void);
void Clay__OpenElementWithId(Clay_ElementId elementId);
void Clay__ConfigureOpenElement(Clay_ElementDeclaration config);
void Clay__ConfigureOpenElementPtr(const Clay_ElementDeclaration *config);
void Clay__CloseElement(void);
Clay_ElementId Clay__HashString(Clay_String key, uint32_t seed);
Clay_ElementId Clay__HashStringWithOffset(Clay_String key, uint32_t offset, uint32_t seed);
void Clay__OpenTextElement(Clay_String text, Clay_TextElementConfig textConfig);

extern Clay_Color Clay__debugViewHighlightColor;
extern uint32_t Clay__debugViewWidth;

void *malloc(size_t size);
void free(void *ptr);
]])

---@class ClayContext
---@field _context ffi.cdata*
---@field _memory ffi.cdata*
---@field set_current fun(self: ClayContext)
---@field set_layout_dimensions fun(self: ClayContext, width: number, height: number)
---@field begin_layout fun(self: ClayContext)
---@field end_layout fun(self: ClayContext, delta_time?: number): Clay_RenderCommandArray
---@field destroy fun(self: ClayContext)
local Context = {}
Context.__index = Context

---@class ClayModule
---@field ffi ffi
---@field lib ffi.CLibrary
---@field layout_direction table<string, Clay_LayoutDirectionEnum>
---@field align_x table<string, Clay_LayoutAlignmentXEnum>
---@field align_y table<string, Clay_LayoutAlignmentYEnum>
---@field sizing_type table<string, Clay_SizingTypeEnum>
---@field text_wrap table<string, Clay_TextWrapEnum>
---@field text_align table<string, Clay_TextAlignEnum>
---@field floating_attach_point table<string, Clay_FloatingAttachPointEnum>
---@field pointer_capture_mode table<string, Clay_PointerCaptureModeEnum>
---@field floating_attach_to table<string, Clay_FloatingAttachToEnum>
---@field floating_clip_to table<string, Clay_FloatingClipToEnum>
---@field transition_state table<string, Clay_TransitionStateEnum>
---@field transition_property table<string, Clay_TransitionPropertyEnum>
---@field transition_enter_trigger table<string, Clay_TransitionEnterTriggerEnum>
---@field transition_exit_trigger table<string, Clay_TransitionExitTriggerEnum>
---@field transition_interaction_handling table<string, Clay_TransitionInteractionHandlingEnum>
---@field exit_transition_sibling_ordering table<string, Clay_ExitTransitionSiblingOrderingEnum>
---@field render_command_type table<string, Clay_RenderCommandTypeEnum>
---@field pointer_data_interaction_state table<string, Clay_PointerDataInteractionStateEnum>
---@field error_type table<string, Clay_ErrorTypeEnum>
---@field LayoutDirection table<string, Clay_LayoutDirectionEnum>
---@field AlignX table<string, Clay_LayoutAlignmentXEnum>
---@field AlignY table<string, Clay_LayoutAlignmentYEnum>
---@field SizingType table<string, Clay_SizingTypeEnum>
---@field TextWrap table<string, Clay_TextWrapEnum>
---@field TextAlign table<string, Clay_TextAlignEnum>
---@field FloatingAttachPoint table<string, Clay_FloatingAttachPointEnum>
---@field PointerCaptureMode table<string, Clay_PointerCaptureModeEnum>
---@field FloatingAttachTo table<string, Clay_FloatingAttachToEnum>
---@field FloatingClipTo table<string, Clay_FloatingClipToEnum>
---@field TransitionState table<string, Clay_TransitionStateEnum>
---@field TransitionProperty table<string, Clay_TransitionPropertyEnum>
---@field TransitionEnterTrigger table<string, Clay_TransitionEnterTriggerEnum>
---@field TransitionExitTrigger table<string, Clay_TransitionExitTriggerEnum>
---@field TransitionInteractionHandling table<string, Clay_TransitionInteractionHandlingEnum>
---@field ExitTransitionSiblingOrdering table<string, Clay_ExitTransitionSiblingOrderingEnum>
---@field RenderCommandType table<string, Clay_RenderCommandTypeEnum>
---@field PointerDataInteractionState table<string, Clay_PointerDataInteractionStateEnum>
---@field ErrorType table<string, Clay_ErrorTypeEnum>
---@field string fun(text: string, is_static?: boolean): Clay_String
---@field string_slice fun(text: string): Clay_StringSlice
---@field dimensions fun(width?: number, height?: number): Clay_Dimensions
---@field vector2 fun(x?: number, y?: number): Clay_Vector2
---@field color fun(r?: number, g?: number, b?: number, a?: number): Clay_Color
---@field bounding_box fun(x?: number, y?: number, width?: number, height?: number): Clay_BoundingBox
---@field corner_radius fun(top_left?: number, top_right?: number, bottom_left?: number, bottom_right?: number): Clay_CornerRadius
---@field padding fun(left?: integer, right?: integer, top?: integer, bottom?: integer): Clay_Padding
---@field child_alignment fun(x?: Clay_LayoutAlignmentXEnum, y?: Clay_LayoutAlignmentYEnum): Clay_ChildAlignment
---@field floating_attach_points fun(element?: Clay_FloatingAttachPointEnum, parent?: Clay_FloatingAttachPointEnum): Clay_FloatingAttachPoints
---@field border_width fun(left?: integer, right?: integer, top?: integer, bottom?: integer, between_children?: integer): Clay_BorderWidth
---@field sizing_fit fun(min?: number, max?: number): Clay_SizingAxis
---@field sizing_grow fun(min?: number, max?: number): Clay_SizingAxis
---@field sizing_fixed fun(value: number): Clay_SizingAxis
---@field sizing_percent fun(percent: number): Clay_SizingAxis
---@field sizing fun(width?: Clay_SizingAxis, height?: Clay_SizingAxis): Clay_Sizing
---@field layout_config fun(): Clay_LayoutConfig
---@field element_declaration fun(): Clay_ElementDeclaration
---@field text_config fun(): Clay_TextElementConfig
---@field aspect_ratio_config fun(aspect_ratio?: number): Clay_AspectRatioElementConfig
---@field image_config fun(image_data?: ffi.cdata*|lightuserdata): Clay_ImageElementConfig
---@field floating_config fun(): Clay_FloatingElementConfig
---@field custom_config fun(custom_data?: ffi.cdata*|lightuserdata): Clay_CustomElementConfig
---@field clip_config fun(horizontal?: boolean, vertical?: boolean, child_offset?: Clay_Vector2): Clay_ClipElementConfig
---@field border_config fun(color?: Clay_Color, width?: Clay_BorderWidth): Clay_BorderElementConfig
---@field transition_data fun(): Clay_TransitionData
---@field transition_enter_config fun(): Clay_TransitionEnterConfig
---@field transition_exit_config fun(): Clay_TransitionExitConfig
---@field transition_config fun(): Clay_TransitionElementConfig
---@field error_handler fun(): Clay_ErrorHandler
---@field min_memory_size fun(): integer
---@field create_arena_with_capacity_and_memory fun(capacity: integer, memory: ffi.cdata*|lightuserdata): Clay_Arena
---@field set_pointer_state fun(position: Clay_Vector2, pointer_down: boolean)
---@field get_pointer_state fun(): Clay_PointerData
---@field initialize fun(arena: Clay_Arena, dimensions: Clay_Dimensions, error_handler?: Clay_ErrorHandler): ffi.cdata*
---@field get_current_context fun(): ffi.cdata*
---@field set_current_context fun(context: ffi.cdata*)
---@field update_scroll_containers fun(enable_drag_scrolling: boolean, scroll_delta: Clay_Vector2, delta_time: number)
---@field get_scroll_offset fun(): Clay_Vector2
---@field set_layout_dimensions fun(dimensions: Clay_Dimensions)
---@field begin_layout fun()
---@field end_layout fun(delta_time?: number): Clay_RenderCommandArray
---@field get_open_element_id fun(): integer
---@field get_element_id fun(id_string: string|Clay_String): Clay_ElementId
---@field get_element_id_with_index fun(id_string: string|Clay_String, index: integer): Clay_ElementId
---@field get_element_data fun(id: Clay_ElementId): Clay_ElementData
---@field hovered fun(): boolean
---@field on_hover fun(callback: ffi.cdata*|function, user_data?: ffi.cdata*|lightuserdata)
---@field pointer_over fun(id: Clay_ElementId): boolean
---@field get_pointer_over_ids fun(): Clay_ElementIdArray
---@field get_scroll_container_data fun(id: Clay_ElementId): Clay_ScrollContainerData
---@field set_measure_text_function fun(callback: ffi.cdata*|function, user_data?: ffi.cdata*|lightuserdata)
---@field set_query_scroll_offset_function fun(callback: ffi.cdata*|function, user_data?: ffi.cdata*|lightuserdata)
---@field render_command_array_get fun(commands: Clay_RenderCommandArray, index: integer): Clay_RenderCommand?
---@field set_debug_mode_enabled fun(enabled: boolean)
---@field is_debug_mode_enabled fun(): boolean
---@field set_culling_enabled fun(enabled: boolean)
---@field get_max_element_count fun(): integer
---@field set_max_element_count fun(max_element_count: integer)
---@field get_max_measure_text_cache_word_count fun(): integer
---@field set_max_measure_text_cache_word_count fun(count: integer)
---@field reset_measure_text_cache fun()
---@field ease_out fun(arguments: Clay_TransitionCallbackArguments): boolean
---@field open_element fun()
---@field open_element_with_id fun(element_id: Clay_ElementId)
---@field configure_open_element fun(config: Clay_ElementDeclaration)
---@field configure_open_element_ptr fun(config: Clay_ElementDeclaration)
---@field close_element fun()
---@field hash_string fun(key: string|Clay_String, seed?: integer): Clay_ElementId
---@field hash_string_with_offset fun(key: string|Clay_String, offset: integer, seed?: integer): Clay_ElementId
---@field open_text_element fun(text: string|Clay_String, text_config: Clay_TextElementConfig)
---@field debug_view_highlight_color fun(): Clay_Color
---@field debug_view_width fun(): integer
---@field new_context fun(width?: number, height?: number, error_handler?: Clay_ErrorHandler): ClayContext
---@field new fun(width?: number, height?: number, error_handler?: Clay_ErrorHandler): ClayContext
---@type ClayModule
local clay = {}

local ok, lib = pcall(ffi.load, "clay")
if not ok then
    error("missing clay library. Install libclay like raylib (e.g. `make install`).")
end

clay.ffi = ffi
clay.lib = lib

local function safe_c_string(chars, length)
    if chars == nil then
        return ""
    end
    return ffi.string(chars, length)
end

ffi.metatype("Clay_String", {
    __tostring = function(value)
        return safe_c_string(value.chars, value.length)
    end,
})

ffi.metatype("Clay_StringSlice", {
    __tostring = function(value)
        return safe_c_string(value.chars, value.length)
    end,
})

ffi.metatype("Clay_Dimensions", {
    __tostring = function(value)
        return string.format("Clay_Dimensions(%.2f, %.2f)", value.width, value.height)
    end,
})

ffi.metatype("Clay_Vector2", {
    __tostring = function(value)
        return string.format("Clay_Vector2(%.2f, %.2f)", value.x, value.y)
    end,
})

ffi.metatype("Clay_Color", {
    __tostring = function(value)
        return string.format("Clay_Color(%.0f, %.0f, %.0f, %.0f)", value.r, value.g, value.b, value.a)
    end,
})

ffi.metatype("Clay_BoundingBox", {
    __tostring = function(value)
        return string.format("Clay_BoundingBox(%.2f, %.2f, %.2f, %.2f)", value.x, value.y, value.width, value.height)
    end,
})

ffi.metatype("Clay_ElementId", {
    __tostring = function(value)
        return string.format("Clay_ElementId(id=%u, offset=%u, baseId=%u, stringId=%s)", value.id, value.offset, value.baseId, tostring(value.stringId))
    end,
})

clay.layout_direction = { LEFT_TO_RIGHT = 0, TOP_TO_BOTTOM = 1 }
clay.align_x = { LEFT = 0, RIGHT = 1, CENTER = 2 }
clay.align_y = { TOP = 0, BOTTOM = 1, CENTER = 2 }
clay.sizing_type = { FIT = 0, GROW = 1, PERCENT = 2, FIXED = 3 }
clay.text_wrap = { WORDS = 0, NEWLINES = 1, NONE = 2 }
clay.text_align = { LEFT = 0, CENTER = 1, RIGHT = 2 }
clay.floating_attach_point = {
    LEFT_TOP = 0,
    LEFT_CENTER = 1,
    LEFT_BOTTOM = 2,
    CENTER_TOP = 3,
    CENTER_CENTER = 4,
    CENTER_BOTTOM = 5,
    RIGHT_TOP = 6,
    RIGHT_CENTER = 7,
    RIGHT_BOTTOM = 8,
}
clay.pointer_capture_mode = { CAPTURE = 0, PASSTHROUGH = 1 }
clay.floating_attach_to = { NONE = 0, PARENT = 1, ELEMENT_WITH_ID = 2, ROOT = 3 }
clay.floating_clip_to = { NONE = 0, ATTACHED_PARENT = 1 }
clay.transition_state = { IDLE = 0, ENTERING = 1, TRANSITIONING = 2, EXITING = 3 }
clay.transition_property = {
    NONE = 0,
    X = 1,
    Y = 2,
    POSITION = 3,
    WIDTH = 4,
    HEIGHT = 8,
    DIMENSIONS = 12,
    BOUNDING_BOX = 15,
    BACKGROUND_COLOR = 16,
    OVERLAY_COLOR = 32,
    CORNER_RADIUS = 64,
    BORDER_COLOR = 128,
    BORDER_WIDTH = 256,
    BORDER = 384,
}
clay.transition_enter_trigger = { SKIP_ON_FIRST_PARENT_FRAME = 0, TRIGGER_ON_FIRST_PARENT_FRAME = 1 }
clay.transition_exit_trigger = { SKIP_WHEN_PARENT_EXITS = 0, TRIGGER_WHEN_PARENT_EXITS = 1 }
clay.transition_interaction_handling = {
    DISABLE_INTERACTIONS_WHILE_TRANSITIONING_POSITION = 0,
    ALLOW_INTERACTIONS_WHILE_TRANSITIONING_POSITION = 1,
}
clay.exit_transition_sibling_ordering = {
    UNDERNEATH_SIBLINGS = 0,
    NATURAL_ORDER = 1,
    ABOVE_SIBLINGS = 2,
}
clay.render_command_type = {
    NONE = 0,
    RECTANGLE = 1,
    BORDER = 2,
    TEXT = 3,
    IMAGE = 4,
    SCISSOR_START = 5,
    SCISSOR_END = 6,
    OVERLAY_COLOR_START = 7,
    OVERLAY_COLOR_END = 8,
    CUSTOM = 9,
}
clay.pointer_data_interaction_state = {
    PRESSED_THIS_FRAME = 0,
    PRESSED = 1,
    RELEASED_THIS_FRAME = 2,
    RELEASED = 3,
}
clay.error_type = {
    TEXT_MEASUREMENT_FUNCTION_NOT_PROVIDED = 0,
    ARENA_CAPACITY_EXCEEDED = 1,
    ELEMENTS_CAPACITY_EXCEEDED = 2,
    TEXT_MEASUREMENT_CAPACITY_EXCEEDED = 3,
    DUPLICATE_ID = 4,
    FLOATING_CONTAINER_PARENT_NOT_FOUND = 5,
    PERCENTAGE_OVER_1 = 6,
    INTERNAL_ERROR = 7,
    UNBALANCED_OPEN_CLOSE = 8,
}

clay.LayoutDirection = clay.layout_direction
clay.AlignX = clay.align_x
clay.AlignY = clay.align_y
clay.SizingType = clay.sizing_type
clay.TextWrap = clay.text_wrap
clay.TextAlign = clay.text_align
clay.FloatingAttachPoint = clay.floating_attach_point
clay.PointerCaptureMode = clay.pointer_capture_mode
clay.FloatingAttachTo = clay.floating_attach_to
clay.FloatingClipTo = clay.floating_clip_to
clay.TransitionState = clay.transition_state
clay.TransitionProperty = clay.transition_property
clay.TransitionEnterTrigger = clay.transition_enter_trigger
clay.TransitionExitTrigger = clay.transition_exit_trigger
clay.TransitionInteractionHandling = clay.transition_interaction_handling
clay.ExitTransitionSiblingOrdering = clay.exit_transition_sibling_ordering
clay.RenderCommandType = clay.render_command_type
clay.PointerDataInteractionState = clay.pointer_data_interaction_state
clay.ErrorType = clay.error_type

---@generic T
---@param ctype string
---@param ... any
---@return T
local function new(ctype, ...)
    return ffi.new(ctype, ...)
end

---@param text string
---@param is_static? boolean
---@return Clay_String
function clay.string(text, is_static)
    return new("Clay_String", is_static or false, #text, text)
end

---@param text string
---@return Clay_StringSlice
function clay.string_slice(text)
    return new("Clay_StringSlice", #text, text, text)
end

---@param width? number
---@param height? number
---@return Clay_Dimensions
function clay.dimensions(width, height)
    return new("Clay_Dimensions", width or 0, height or 0)
end

---@param x? number
---@param y? number
---@return Clay_Vector2
function clay.vector2(x, y)
    return new("Clay_Vector2", x or 0, y or 0)
end

---@param r? number
---@param g? number
---@param b? number
---@param a? number
---@return Clay_Color
function clay.color(r, g, b, a)
    return new("Clay_Color", r or 0, g or 0, b or 0, a or 255)
end

---@param x? number
---@param y? number
---@param width? number
---@param height? number
---@return Clay_BoundingBox
function clay.bounding_box(x, y, width, height)
    return new("Clay_BoundingBox", x or 0, y or 0, width or 0, height or 0)
end

---@param top_left? number
---@param top_right? number
---@param bottom_left? number
---@param bottom_right? number
---@return Clay_CornerRadius
function clay.corner_radius(top_left, top_right, bottom_left, bottom_right)
    return new("Clay_CornerRadius", top_left or 0, top_right or top_left or 0, bottom_left or top_left or 0, bottom_right or top_right or top_left or 0)
end

---@param left? integer
---@param right? integer
---@param top? integer
---@param bottom? integer
---@return Clay_Padding
function clay.padding(left, right, top, bottom)
    return new("Clay_Padding", left or 0, right or left or 0, top or left or 0, bottom or top or left or 0)
end

---@param x? Clay_LayoutAlignmentXEnum
---@param y? Clay_LayoutAlignmentYEnum
---@return Clay_ChildAlignment
function clay.child_alignment(x, y)
    return new("Clay_ChildAlignment", x or clay.align_x.LEFT, y or clay.align_y.TOP)
end

---@param element? Clay_FloatingAttachPointEnum
---@param parent? Clay_FloatingAttachPointEnum
---@return Clay_FloatingAttachPoints
function clay.floating_attach_points(element, parent)
    return new("Clay_FloatingAttachPoints", element or clay.floating_attach_point.LEFT_TOP, parent or clay.floating_attach_point.LEFT_TOP)
end

---@param left? integer
---@param right? integer
---@param top? integer
---@param bottom? integer
---@param between_children? integer
---@return Clay_BorderWidth
function clay.border_width(left, right, top, bottom, between_children)
    return new("Clay_BorderWidth", left or 0, right or left or 0, top or left or 0, bottom or top or left or 0, between_children or 0)
end

---@param min? number
---@param max? number
---@return Clay_SizingAxis
function clay.sizing_fit(min, max)
    local axis = new("Clay_SizingAxis")
    axis.size.minMax.min = min or 0
    axis.size.minMax.max = max or 0
    axis.type = clay.sizing_type.FIT
    return axis
end

---@param min? number
---@param max? number
---@return Clay_SizingAxis
function clay.sizing_grow(min, max)
    local axis = new("Clay_SizingAxis")
    axis.size.minMax.min = min or 0
    axis.size.minMax.max = max or 0
    axis.type = clay.sizing_type.GROW
    return axis
end

---@param value number
---@return Clay_SizingAxis
function clay.sizing_fixed(value)
    local axis = new("Clay_SizingAxis")
    axis.size.minMax.min = value
    axis.size.minMax.max = value
    axis.type = clay.sizing_type.FIXED
    return axis
end

---@param percent number
---@return Clay_SizingAxis
function clay.sizing_percent(percent)
    local axis = new("Clay_SizingAxis")
    axis.size.percent = percent
    axis.type = clay.sizing_type.PERCENT
    return axis
end

---@param width? Clay_SizingAxis
---@param height? Clay_SizingAxis
---@return Clay_Sizing
function clay.sizing(width, height)
    local value = new("Clay_Sizing")
    value.width = width or clay.sizing_fit()
    value.height = height or clay.sizing_fit()
    return value
end

---@return Clay_LayoutConfig
function clay.layout_config()
    return new("Clay_LayoutConfig")
end

---@return Clay_ElementDeclaration
function clay.element_declaration()
    return new("Clay_ElementDeclaration")
end

---@return Clay_TextElementConfig
function clay.text_config()
    return new("Clay_TextElementConfig")
end

---@param aspect_ratio? number
---@return Clay_AspectRatioElementConfig
function clay.aspect_ratio_config(aspect_ratio)
    return new("Clay_AspectRatioElementConfig", aspect_ratio or 0)
end

---@param image_data? ffi.cdata*|lightuserdata
---@return Clay_ImageElementConfig
function clay.image_config(image_data)
    local config = new("Clay_ImageElementConfig")
    config.imageData = image_data
    return config
end

---@return Clay_FloatingElementConfig
function clay.floating_config()
    return new("Clay_FloatingElementConfig")
end

---@param custom_data? ffi.cdata*|lightuserdata
---@return Clay_CustomElementConfig
function clay.custom_config(custom_data)
    local config = new("Clay_CustomElementConfig")
    config.customData = custom_data
    return config
end

---@param horizontal? boolean
---@param vertical? boolean
---@param child_offset? Clay_Vector2
---@return Clay_ClipElementConfig
function clay.clip_config(horizontal, vertical, child_offset)
    local config = new("Clay_ClipElementConfig")
    config.horizontal = horizontal or false
    config.vertical = vertical or false
    config.childOffset = child_offset or clay.vector2()
    return config
end

---@param color? Clay_Color
---@param width? Clay_BorderWidth
---@return Clay_BorderElementConfig
function clay.border_config(color, width)
    local config = new("Clay_BorderElementConfig")
    config.color = color or clay.color()
    config.width = width or clay.border_width()
    return config
end

---@return Clay_TransitionData
function clay.transition_data()
    return new("Clay_TransitionData")
end

---@return Clay_TransitionEnterConfig
function clay.transition_enter_config()
    return new("Clay_TransitionEnterConfig")
end

---@return Clay_TransitionExitConfig
function clay.transition_exit_config()
    return new("Clay_TransitionExitConfig")
end

---@return Clay_TransitionElementConfig
function clay.transition_config()
    return new("Clay_TransitionElementConfig")
end

---@return Clay_ErrorHandler
function clay.error_handler()
    return new("Clay_ErrorHandler")
end

---@return integer
function clay.min_memory_size()
    return tonumber(lib.Clay_MinMemorySize())
end

---@param capacity integer
---@param memory ffi.cdata*|lightuserdata
---@return Clay_Arena
function clay.create_arena_with_capacity_and_memory(capacity, memory)
    return lib.Clay_CreateArenaWithCapacityAndMemory(capacity, memory)
end

---@param position Clay_Vector2
---@param pointer_down boolean
function clay.set_pointer_state(position, pointer_down)
    lib.Clay_SetPointerState(position, pointer_down)
end

---@return Clay_PointerData
function clay.get_pointer_state()
    return lib.Clay_GetPointerState()
end

---@param arena Clay_Arena
---@param dimensions Clay_Dimensions
---@param error_handler? Clay_ErrorHandler
---@return ffi.cdata*
function clay.initialize(arena, dimensions, error_handler)
    return lib.Clay_Initialize(arena, dimensions, error_handler or clay.error_handler())
end

---@return ffi.cdata*
function clay.get_current_context()
    return lib.Clay_GetCurrentContext()
end

---@param context ffi.cdata*
function clay.set_current_context(context)
    lib.Clay_SetCurrentContext(context)
end

---@param enable_drag_scrolling boolean
---@param scroll_delta Clay_Vector2
---@param delta_time number
function clay.update_scroll_containers(enable_drag_scrolling, scroll_delta, delta_time)
    lib.Clay_UpdateScrollContainers(enable_drag_scrolling, scroll_delta, delta_time)
end

---@return Clay_Vector2
function clay.get_scroll_offset()
    return lib.Clay_GetScrollOffset()
end

---@param dimensions Clay_Dimensions
function clay.set_layout_dimensions(dimensions)
    lib.Clay_SetLayoutDimensions(dimensions)
end

function clay.begin_layout()
    lib.Clay_BeginLayout()
end

---@param delta_time? number
---@return Clay_RenderCommandArray
function clay.end_layout(delta_time)
    return lib.Clay_EndLayout(delta_time or 0)
end

---@return integer
function clay.get_open_element_id()
    return tonumber(lib.Clay_GetOpenElementId())
end

---@param id_string string|Clay_String
---@return Clay_ElementId
function clay.get_element_id(id_string)
    return lib.Clay_GetElementId(type(id_string) == "string" and clay.string(id_string, true) or id_string)
end

---@param id_string string|Clay_String
---@param index integer
---@return Clay_ElementId
function clay.get_element_id_with_index(id_string, index)
    return lib.Clay_GetElementIdWithIndex(type(id_string) == "string" and clay.string(id_string, true) or id_string, index)
end

---@param id Clay_ElementId
---@return Clay_ElementData
function clay.get_element_data(id)
    return lib.Clay_GetElementData(id)
end

---@return boolean
function clay.hovered()
    return lib.Clay_Hovered()
end

---@param callback ffi.cdata*|function
---@param user_data? ffi.cdata*|lightuserdata
function clay.on_hover(callback, user_data)
    lib.Clay_OnHover(callback, user_data)
end

---@param id Clay_ElementId
---@return boolean
function clay.pointer_over(id)
    return lib.Clay_PointerOver(id)
end

---@return Clay_ElementIdArray
function clay.get_pointer_over_ids()
    return lib.Clay_GetPointerOverIds()
end

---@param id Clay_ElementId
---@return Clay_ScrollContainerData
function clay.get_scroll_container_data(id)
    return lib.Clay_GetScrollContainerData(id)
end

---@param callback ffi.cdata*|function
---@param user_data? ffi.cdata*|lightuserdata
function clay.set_measure_text_function(callback, user_data)
    lib.Clay_SetMeasureTextFunction(callback, user_data)
end

---@param callback ffi.cdata*|function
---@param user_data? ffi.cdata*|lightuserdata
function clay.set_query_scroll_offset_function(callback, user_data)
    lib.Clay_SetQueryScrollOffsetFunction(callback, user_data)
end

---@param commands Clay_RenderCommandArray
---@param index integer
---@return Clay_RenderCommand?
function clay.render_command_array_get(commands, index)
    local array_ref = new("Clay_RenderCommandArray[1]", commands)
    local ptr = lib.Clay_RenderCommandArray_Get(array_ref, index)
    return ptr ~= nil and ptr[0] or nil
end

---@param enabled boolean
function clay.set_debug_mode_enabled(enabled)
    lib.Clay_SetDebugModeEnabled(enabled)
end

---@return boolean
function clay.is_debug_mode_enabled()
    return lib.Clay_IsDebugModeEnabled()
end

---@param enabled boolean
function clay.set_culling_enabled(enabled)
    lib.Clay_SetCullingEnabled(enabled)
end

---@return integer
function clay.get_max_element_count()
    return tonumber(lib.Clay_GetMaxElementCount())
end

---@param max_element_count integer
function clay.set_max_element_count(max_element_count)
    lib.Clay_SetMaxElementCount(max_element_count)
end

---@return integer
function clay.get_max_measure_text_cache_word_count()
    return tonumber(lib.Clay_GetMaxMeasureTextCacheWordCount())
end

---@param count integer
function clay.set_max_measure_text_cache_word_count(count)
    lib.Clay_SetMaxMeasureTextCacheWordCount(count)
end

function clay.reset_measure_text_cache()
    lib.Clay_ResetMeasureTextCache()
end

---@param arguments Clay_TransitionCallbackArguments
---@return boolean
function clay.ease_out(arguments)
    return lib.Clay_EaseOut(arguments)
end

function clay.open_element()
    lib.Clay__OpenElement()
end

---@param element_id Clay_ElementId
function clay.open_element_with_id(element_id)
    lib.Clay__OpenElementWithId(element_id)
end

---@param config Clay_ElementDeclaration
function clay.configure_open_element(config)
    lib.Clay__ConfigureOpenElement(config)
end

---@param config Clay_ElementDeclaration
function clay.configure_open_element_ptr(config)
    local config_ref = new("Clay_ElementDeclaration[1]", config)
    lib.Clay__ConfigureOpenElementPtr(config_ref)
end

function clay.close_element()
    lib.Clay__CloseElement()
end

---@param key string|Clay_String
---@param seed? integer
---@return Clay_ElementId
function clay.hash_string(key, seed)
    return lib.Clay__HashString(type(key) == "string" and clay.string(key, true) or key, seed or 0)
end

---@param key string|Clay_String
---@param offset integer
---@param seed? integer
---@return Clay_ElementId
function clay.hash_string_with_offset(key, offset, seed)
    return lib.Clay__HashStringWithOffset(type(key) == "string" and clay.string(key, true) or key, offset, seed or 0)
end

---@param text string|Clay_String
---@param text_config Clay_TextElementConfig
function clay.open_text_element(text, text_config)
    lib.Clay__OpenTextElement(type(text) == "string" and clay.string(text, true) or text, text_config)
end

---@return Clay_Color
function clay.debug_view_highlight_color()
    return lib.Clay__debugViewHighlightColor
end

---@return integer
function clay.debug_view_width()
    return tonumber(lib.Clay__debugViewWidth)
end

---@param width? number
---@param height? number
---@param error_handler? Clay_ErrorHandler
---@return ClayContext
function clay.new_context(width, height, error_handler)
    local capacity = clay.min_memory_size()
    local memory = ffi.C.malloc(capacity)
    assert(memory ~= nil, "failed to allocate clay arena memory")
    memory = ffi.gc(memory, ffi.C.free)

    local arena = clay.create_arena_with_capacity_and_memory(capacity, memory)
    local context = clay.initialize(arena, clay.dimensions(width or 0, height or 0), error_handler)
    assert(context ~= nil, "failed to initialize clay context")

    return setmetatable({
        _context = context,
        _memory = memory,
    }, Context)
end

---@param width? number
---@param height? number
---@param error_handler? Clay_ErrorHandler
---@return ClayContext
function clay.new(width, height, error_handler)
    return clay.new_context(width, height, error_handler)
end

function Context:set_current()
    clay.set_current_context(self._context)
end

---@param width number
---@param height number
function Context:set_layout_dimensions(width, height)
    self:set_current()
    clay.set_layout_dimensions(clay.dimensions(width, height))
end

function Context:begin_layout()
    self:set_current()
    clay.begin_layout()
end

---@param delta_time? number
---@return Clay_RenderCommandArray
function Context:end_layout(delta_time)
    self:set_current()
    return clay.end_layout(delta_time)
end

function Context:destroy()
    ffi.gc(self._memory, nil)
    ffi.C.free(self._memory)
end

return clay
