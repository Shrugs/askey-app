//
//  Config.h
//  ASCIIboardContainer
//
//  Created by Matt Condon on 1/3/15.
//  Copyright (c) 2015 Shrugs. All rights reserved.
//

#ifndef ASCIIboardContainer_Config_h
#define ASCIIboardContainer_Config_h

#define ASKEY_BLUE_COLOR [UIColor colorWithRed:24.0/255.0 green:109.0/255.0 blue:250.0/255.0 alpha: 1.0]
#define ASKEY_BACKGROUND_COLOR [UIColor colorWithRed:236.0/255.0 green:236.0/255.0 blue:236.0/255.0 alpha:1.0]
#define ASKEY_BUTTON_PURCHASED_SHADOW_COLOR [UIColor colorWithRed:119.0/255.0 green:219.0/255.0 blue:30.0/255.0 alpha:1.0]

#define ASKEY_BUTTON_BODY_COLOR [UIColor whiteColor]
#define ASKEY_BUTTON_SHADOW_COLOR [UIColor colorWithRed:0.515625f green:0.51953125f blue:0.53125f alpha:1.0f]
#define ASKEY_BUTTON_TEXT_COLOR [UIColor colorWithRed:67.0/255.0 green:67.0/255.0 blue:67.0/255.0 alpha:1.0f]
#define ASKEY_BUTTON_FONT @"HelveticaNeue-Medium"

#define ASKEY_TITLE_FONT @"HelveticaNeue-Medium"

#define LARGE_BUTTON_RATIO 0.933
#define NORMAL_BUTTON_HEIGHT 65

#define TEXT_IDENTIFIER @"com.shrugs.askey.text"
#define EMOJI_IDENTIFIER @"com.shrugs.askey.emoji"
#define MAIL_IDENTIFIER @"com.shrugs.askey.mail"
#define BUNDLE_IDENTIFIER @"com.shrugs.askey.bundle"

// DEBUG
#define DEBUG_SPACERS NO

// BRUSH SIZES
#define BRUSH_SIZE_SMALL 11.0f
#define BRUSH_SIZE_MEDIUM 15.0f
#define BRUSH_SIZE_LARGE 20.0f

#define BRUSH_BUTTON_RELATIVE_SIZE 0.9f

// ASKEY VALUES
#define ASKEY_HEIGHT 280.0
// same ratio as 8.5x11 paper
#define ASKEY_WIDTH_RATIO 0.772727273f
// ratio of sheet height to view height
#define ASKEY_HEIGHT_FRACTION 0.8f

// size of buttons relative to a fouth of the view height
#define RELATIVE_BUTTON_SIZE 0.75
#define BUTTON_HEIGHT (ASKEY_HEIGHT * 0.25 * RELATIVE_BUTTON_SIZE)

// height of exposed portion of sheet, relative to keyboard height
#define RELATIVE_SHEET_EXPOSED_HEIGHT 0.15
// base velocity of sheets
#define SHEET_VELOCITY 10
// initial delay in seconds for first sheet to slide in
#define INITIAL_SHEET_DELAY 0.3f
// speed to guarantee decrement
#define SHEET_VELOCITY_THRESHOLD 300
// position thresh to guarantee decrement
#define SHEET_TRANSLATION_THRESHOLD 50

// UI/UX
#define ASKEY_HOLD_DURATION 0.3f
#define ASKEY_KEYBOARD_BACKGROUND_COLOR [UIColor colorWithRed:0.863 green:.8671875 blue:.8828125 alpha:1.000]


// CONSTS
#define ASKEY_CONTAINER_GROUP_NAME @"group.io.askey"

#define LARGE_HEADER_HEIGHT 160
#define SMALL_HEADER_HEIGHT 60


typedef enum {
    ASKEYScreenOrientationUnknown,
    ASKEYScreenOrientationPortrait,
    ASKEYScreenOrientationLandscape
} ASKEYScreenOrientation;

#endif
